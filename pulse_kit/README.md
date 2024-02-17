# Pulse Kit

Pulse Kit is a comprehensive library designed for WearOS applications, facilitating seamless interaction with various sensors and features on WearOS devices. This library is tailored to empower developers in building advanced fitness and health tracking applications, leveraging the capabilities of WearOS.

## Getting Started

To integrate Pulse Kit into your project, you need to make a few updates to your project's configuration files. This ensures that your application has the necessary permissions and minimum SDK requirements to utilize the library effectively.

### Update `android/app/build.gradle`

Set the minimum SDK version to 30 to ensure compatibility with the features used by Pulse Kit:

```gradle
minSdkVersion 30
```

### Update `AndroidManifest.xml`

Add the following permissions to your `AndroidManifest.xml` to allow access to body sensors, activity recognition, and fine location. These permissions are crucial for the library to function correctly, as they enable it to collect sensor data and provide accurate fitness tracking.

```xml
<uses-permission android:name="android.permission.BODY_SENSORS" />
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

By following these setup instructions, you ensure that your WearOS application can fully leverage the Pulse Kit library to deliver a rich and engaging user experience in fitness and health tracking.
