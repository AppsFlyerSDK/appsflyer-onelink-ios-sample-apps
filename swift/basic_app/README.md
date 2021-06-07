# FEED.ME fruit store sample app
<img src="https://user-images.githubusercontent.com/61788924/97542099-d906f000-19ce-11eb-8fe3-911d616ea953.jpg" height="400">

## What is it for?
This app demonstrates the basic functionality of AppsFlyer's OneLink deep-linking solution.
The app will be able to register it in AppsFlyer's dashboard, create real OneLink link and 'test-drive' them.

> You can read more in our Developer Hub for iOS [here](https://afonelink.readme.io/docs/ios).

## Compatability
- **iOS version >= 13**

- **AppsFlyer SDK versions >= 5.4.1**

## How to use this app?
1. Clone the repository
2. ** Make sure to open the work environment via Xcode workspace `basic_app.xcworkspace` **
3. Get your AppsFlyer Dev Key using [these instructions][get_af_devkey].
4. Create the file `basic_app\afdevkey_donotpush.plist` with the following content:
```xml
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>appsFlyerDevKey</key>
        <string>YOUR_AF_DEV_KEY_HERE</string>
        <key>appleAppID</key>
        <string>YOUR_APPLE_APP_ID_HERE</string>
</dict>
</plist>
```
5. Add the file into your Xcode project
> The file `basic_app/basic_app.xcodeproj/project.pbxproj` will have some changes. **Do not commit them!**

[get_af_devkey]: https://support.appsflyer.com/hc/en-us/articles/207032066-iOS-SDK-integration-for-developers#integration-31-retrieving-your-dev-key
6. Ask your marketer to create some OneLink links and start running fruit campaigns 🍎
