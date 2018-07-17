package com.sanousun.flutterweather;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL_SENSOR = "com.sanousun.flutterweather/sensor";
    private static final String CHANNEL_LOCATION = "com.sanousun.flutterweather/location";

    private static final int REQUEST_LOCATION_CODE = 0x19;

    private boolean mIsOpenGravitySensor;
    private SensorManager mSensorManager;
    private Sensor mGravitySensor;

    private double mRotation2D;
    private double mRotation3D;

    private SensorEventListener mGravityListener = new SensorEventListener() {

        @Override
        public void onSensorChanged(SensorEvent ev) {
            // x : (+) fall to the left / (-) fall to the right.
            // y : (+) stand / (-) head stand.
            // z : (+) look down / (-) look up.
            // rotation2D : (+) anticlockwise / (-) clockwise.
            // rotation3D : (+) look down / (-) look up.
            if (mIsOpenGravitySensor) {
                float aX = ev.values[0];
                float aY = ev.values[1];
                float aZ = ev.values[2];
                double g2D = Math.sqrt(aX * aX + aY * aY);
                double g3D = Math.sqrt(aX * aX + aY * aY + aZ * aZ);
                double cos2D = Math.max(Math.min(1, aY / g2D), -1);
                double cos3D = Math.max(Math.min(1, g2D * (aY >= 0 ? 1 : -1) / g3D), -1);
                mRotation2D = (float) Math.toDegrees(Math.acos(cos2D)) * (aX >= 0 ? 1 : -1);
                mRotation3D = (float) Math.toDegrees(Math.acos(cos3D)) * (aZ >= 0 ? 1 : -1);
            } else {
                mRotation2D = 0;
                mRotation3D = 0;
            }
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {
            // 空实现
        }
    };

    private MethodChannel.Result mLocationResult;

    private AMapLocationListener mLocationListener = new AMapLocationListener() {
        @Override
        public void onLocationChanged(AMapLocation aMapLocation) {
            if (mLocationResult != null) {
                if (aMapLocation != null) {
                    HashMap<String, String> map = new HashMap<>();
                    map.put("location", aMapLocation.getDistrict());
                    map.put("parent_city", aMapLocation.getCity());
                    map.put("admin_area", aMapLocation.getProvince());
                    map.put("cnty", aMapLocation.getCountry());
                    mLocationResult.success(map);
                } else {
                    mLocationResult.error("location failed", "定位失败", null);
                }
            }
            mLocationResult = null;
        }
    };

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL_SENSOR)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        switch (methodCall.method) {
                            case "registerSensor":
                                mSensorManager = (SensorManager)
                                        MainActivity.this.getSystemService(Context.SENSOR_SERVICE);
                                if (mSensorManager != null) {
                                    mIsOpenGravitySensor = true;
                                    mGravitySensor = mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);
                                    boolean success = mSensorManager.registerListener(
                                            mGravityListener, mGravitySensor,
                                            SensorManager.SENSOR_DELAY_FASTEST);
                                    result.success(success);
                                } else {
                                    result.error("UNAVAILABLE", "无法获取重力传感器.", null);
                                }
                                break;
                            case "unregisterSensor":
                                if (mSensorManager != null) {
                                    mSensorManager.unregisterListener(
                                            mGravityListener, mGravitySensor);
                                }
                                break;
                            case "getRotation":
                                List<Double> rotation = new ArrayList<>();
                                rotation.add(mRotation2D);
                                rotation.add(mRotation3D);
                                result.success(rotation);
                                break;
                            default:
                                result.notImplemented();
                        }
                    }
                });


        new MethodChannel(getFlutterView(), CHANNEL_LOCATION)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        switch (methodCall.method) {
                            case "getLocation":
                                mLocationResult = result;
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
                                            != PackageManager.PERMISSION_GRANTED) {
                                        requestPermissions(
                                                new String[]{Manifest.permission.ACCESS_COARSE_LOCATION},
                                                REQUEST_LOCATION_CODE);//自定义的code
                                    } else {
                                        startLocation();
                                    }
                                } else {
                                    startLocation();
                                }
                                break;
                            default:
                                result.notImplemented();
                        }
                    }
                });
    }

    private void startLocation() {
        AMapLocationClientOption locationOption =
                new AMapLocationClientOption();
        locationOption.setOnceLocation(true);
        AMapLocationClient locationClient =
                new AMapLocationClient(MainActivity.this);
        locationClient.setLocationListener(mLocationListener);
        locationClient.setLocationOption(locationOption);
        locationClient.startLocation();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_LOCATION_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startLocation();
            } else {
                mLocationResult.error("permission denied", "定位权限被拒绝", null);
                mLocationResult = null;
            }
        }
    }
}
