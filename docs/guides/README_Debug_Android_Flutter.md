
# Debugging Flutter App on Android Device from Android Studio

## Prerequisites:
1. **Android Studio**: Ensure you have Android Studio installed and updated to the latest version.
2. **Flutter SDK**: Install the Flutter SDK and ensure it’s added to your system path.
3. **Android SDK**: Make sure the Android SDK is installed. You can check this in Android Studio under **SDK Manager**.
4. **USB Debugging Enabled**: On your Android device, enable USB debugging:
    - Go to **Settings** → **About phone**.
    - Tap **Build number** seven times to unlock Developer Options.
    - Go back to **Settings** → **Developer Options**, and enable **USB Debugging**.

## Steps to Debug on an Android Device:

### 1. Set Up Your Android Device for Development
- Connect your Android device to your computer via a USB cable.
- You should see a prompt on the device to allow USB debugging from your computer. Tap **Allow**.
- Ensure the device is recognized by running:
   ```bash
   flutter devices
   ```
  Your Android device should be listed here.

### 2. Open Your Flutter Project in Android Studio
- Open **Android Studio** and load your Flutter project.
- Make sure your Android device is connected.

### 3. Select Your Android Device for Debugging
- In Android Studio, click the **Device Selector** at the top right and select your connected Android device from the list.
- If your device is not listed, ensure that USB debugging is enabled and that the device is properly connected.

### 4. Build and Run the App
- To compile and run your Flutter app on the Android device, use the following command:
   ```bash
   flutter run
   ```
- Alternatively, in Android Studio, click the **Run** button (the green play button) to compile and install the app on your Android device.

### 5. Debug the App
- Once the app is installed on your Android device, you can debug it using the **Debug** tab in Android Studio.
- You can set breakpoints, inspect variables, and step through code just as you would with any Android application.

### 6. Monitor Logs with Logcat
- Open the **Logcat** tab at the bottom of Android Studio to view real-time logs from your Android device.
- You can filter logs to show only your app’s output by searching for your app's package name.

### 7. Hot Reload/Hot Restart
- During debugging, you can make changes to the code and use **Hot Reload** to instantly apply changes without restarting the app:
   ```bash
   r  // For hot reload
   R  // For full restart
   ```
- Alternatively, you can use the **Hot Reload** and **Hot Restart** buttons in Android Studio.
