
# Debugging Flutter App on iOS Device from Android Studio

## Prerequisites:
1. **MacOS**: You need to be on a Mac machine to build and install Flutter apps on iOS.
2. **Xcode**: Ensure Xcode is installed and updated to the latest version from the Mac App Store.
3. **Xcode Command-Line Tools**: Install them by running:
   ```bash
   xcode-select --install
   ```
4. **Cocoapods**: Install Cocoapods for managing iOS dependencies by running:
   ```bash
   sudo gem install cocoapods
   ```

## Steps to Debug on an iOS Device:

### 1. Set Up Your iOS Device for Development
- Open **Xcode** and go to **Preferences** → **Accounts**.
- Log in with your Apple ID and add your account.
- Connect your iPhone or iPad to your Mac via a USB cable.
- In Xcode, open **Window** → **Devices and Simulators** and ensure your device appears and is recognized as a developer device.
- Select **Use for Development** if prompted.

### 2. Open Your Flutter Project in Android Studio
- Make sure your Flutter project is set up in Android Studio.
- Open the **iOS** folder of your Flutter project in Android Studio.

### 3. Update iOS Dependencies
- In the terminal, navigate to the `ios` folder of your Flutter project and run:
   ```bash
   flutter clean
   pod install
   ```

### 4. Change to Physical iOS Device
#### Enable Developer Mode on Your iPhone
Open Settings on your iPhone.
Navigate to Privacy & Security > Developer Mode.
Enable Developer Mode and restart your iPhone if prompted.

- Ensure the device is trusted by your Mac, and its UDID is registered.
- In Android Studio, open the **Device Selector** at the top and select your connected iOS device.

### 5. Build and Run the App
- Run the following command to install the app onto your device for debugging:
   ```bash
   flutter run
   ```
- Alternatively, in Android Studio, click the **Run** button (the green play button) with your iOS device selected. This will compile and install the app on your iOS device.

### 6. Trust the Developer
- On your iPhone, you may be prompted to trust the developer. Go to **Settings** → **General** → **Device Management** and trust your developer account.

Once completed, the Flutter app will be installed and running on your iOS device, allowing you to debug it directly from Android Studio.

## Extra Troubleshooting Section

### 1. `PhoneNumberKit` Not Found in Swift Code:
- Ensure the following is added to the `Podfile`:
  ```ruby
  use_frameworks!
  ```
- Reinstall pods:
  ```bash
  cd ios
  pod install
  ```
- Clean the build folder in Xcode: **Product** → **Clean Build Folder**.
- Make sure `PhoneNumberKit` is imported correctly:
  ```swift
  import PhoneNumberKit
  ```

### 2. Missing `.xcconfig` File:
- Run `flutter pub get` to regenerate the necessary Flutter build settings, including the `Generated.xcconfig` file:
  ```bash
  flutter pub get
  ```

### 3. Linking `.xcconfig` Manually:
- In Xcode, navigate to **Build Settings** of the `Runner` target.
- Find **Base Configuration** for both **Debug** and **Release**.
- Set them to:
  ```
  ios/Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig
  ios/Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig
  ```

### 4. Swift Compatibility Issues:
- Make sure the **Swift Language Version** is set to the latest supported version in **Build Settings**.
- If using an older Xcode version, specify the compatible version of the `PhoneNumberKit` library in the `Podfile`:
  ```ruby
  pod 'PhoneNumberKit', '~> 3.0'
  ```

### 5. Manual Clean and Rebuild:
- If issues persist, perform a clean rebuild:
  ```bash
  flutter clean
  flutter run
  pod deintegrate
  pod install
  ```

### 6. If PhoneNumberKit number error still persists
- Follow this guide : https://stackoverflow.com/questions/78900034/cannot-find-type-phonenumberkit-and-extra-argument-phonenumberkit-in-call-er
  ```bash
  cd ios
  rm Podfile.lock
  vi Podfile # -> Add or EDit line pod 'PhoneNumberKit', '~> 3.7.6' (Could be > 4, depending on your device)
  pod install
  flutter run
  ```

Following these steps will help resolve issues related to missing dependencies, linking errors, and framework compatibility.

