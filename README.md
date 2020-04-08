# poe_clicker

PoE simulator for mobile. Crafting and clicker game

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build release Android

1. Build the app bundle
flutter build appbundle

2. Remove old build 
rm /Users/fpet/Documents/builds.apks

3. Build apks from appbundle
bundletool build-apks --bundle=build/app/outputs/bundle/release/app.aab --output=/Users/fpet/Documents/builds.apks

4. Install appbundle on phone
bundletool install-apks --apks=/Users/fpet/Documents/builds.apks --adb /Users/fpet/Library/Android/sdk/platform-tools/adb


## Build release iOS

#### 1. WARNING: The app cannot run on emulator!!!!!
#### 2. build
flutter build ios --release
#### 3. test run
run the app from xcode (make sure you run the release version)
#### 4. if it fails
flutter clean, 
delete podfile & podfile.lock & Pods/ & .xcodeworkspace
go to step 2.
#### 5. upload to appstore
in xcode: select device: generic device (or somthing like that) then press archive.
When done, press 'distribute app' -> 'to appstore' -> 'automatic signing'

