![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat)

# Jentis

Jentis is a Package to support app Tracking to Jentis.

## Basic usage

First setup the `TrackService` by passing a `TrackConfig` object the `initTracking` method (on App Start).

```swift
let config = TrackConfig(trackDomain: "https://kndmjh.demoApp.jtm-demo.com/", trackID: "demoApp", environment: .live)

TrackService.shared.initTracking(config: config)
```

Afterwards, let the user setup the vendors he allows tracking to. Use the `setConsents` method to pass Key-Value Pairs of vendors to the SDK.
The setConsents method asynchronously returns whether it was successful or not. The method supports both, async/await & completion handler.

```swift
let result = await TrackService.shared.setConsents(consents: ["googleanalytics":true, "easymarketing":false])
switch result {
case .success:
    // Successfully set consents - retrieve ConsentID
    consentID = TrackService.shared.getConsentId()
case .failure:
    // An error occured - display error to user (e.g. if no internet connection was available)
    displayAlert = true
}
```

From now on you can track data using the `push` method. Pass key-value pairs to the method to add information. At least a track key is needed on each push request, use ["track":"submit"] to submit the tracking to the Jenkis server. The other keys can be used to track custom properties. The following values are tracked in the sdk by default.

### Default Trackings

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

 Key  | Description | Example Value(s) 
| ------------- | ------------- |
| app_device_brand  | The brand of the device | Apple |
| app_device_model  | The device model | iPhone14,5 (for iPhone 13, see [Lookup table]([https://www.google.com](https://gist.github.com/adamawolf/3048717)) for more Information ) |
| app_device_os | The device operating System | iOS |
| app_device_os_version | The device os Version | 15.0, 13.1 |
| app_device_language | The device language | de, en |
| app_device_region | The device region specified in the device settings (not the current location) | US |
| app_device_width | The screen width of the device | 390 |
| app_device_height | The screen height of the device | 844 |
| app_application_name | The name of the application | ExampleApp |
| app_application_version | The app version | 1.0, 2.1 |
| app_application_build_number | The app build number | 1, 2, 3 |

### Example usage

Example usage when the user navigates to a new screen:

```swift
TrackService.shared.push(data: ["track":"pageview", "pagetitle":"Tracking Screen", "virtualPagePath":"MainScreen/TrackingScreen"])
TrackService.shared.push(data: ["track":"submit"])
```

## Debugging

Use the `debugTracking` method to enable/disable debugging.

### Enable Debugging

```swift
TrackService.shared.debugTracking(true, debugId: "62a9e9c727255", version: "2")
```

### Disable Debugging

```swift
TrackService.shared.debugTracking(false)
```
