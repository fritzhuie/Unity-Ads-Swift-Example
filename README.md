This Swift project provides two examples for integrating the Unity Ads SDK into a SpriteKit or Cocos2D game

1. **Simple Example:** One scene, minimumal integration to play a video ad
2. **Complete Example:** Two scenes that can play ads, incentivized callbacks, rewarded placements

*Planet illustration provided by NASA - Original image by ESA/Hubble (M. Kornmesser) - https://www.spacetelescope.org/*

# How to integrate Unity Ads into your Swift project

### Create a Game Project on the [Unity Ads Dashboard](https://dashboard.unityads.unity3d.com)
- Log into the [dashboard](https://dashboard.unityads.unity3d.com) using your [UDN Account](https://accounts.unity3d.com/sign-in)
- Create a new game project
- Look for your iOS **Game ID** in the project, a 7-digit number that you will use in your integration

### Import the Unity Ads Framework

Download the Unity SDK from https://github.com/Applifier/unity-ads-sdk
  1. [Download the SDK zip file](https://github.com/Applifier/unity-ads-sdk/archive/master.zip)
  2. Unzip the project, and locate **UnityAds.framework** and **UnityAds.bundle**

Import **UnityAds.framework** and **UnityAds.bundle** into your project
  1. Drag and drop the files into your project's file manager
  2. Select the box next to **"Copy items if needed"**

Make sure the following dependancies are enabled in your project  
  
> **AdSupport**.framework  
> **AVFoundation**.framework  
> **CFNetwork**.framework  
> **CoreFoundation**.framework  
> **CoreMedia**.framework  
> **CoreTelephony**.framework  
> **StoreKit**.framework  
> **SystemConfiguration**.framework  
  
  
  
  1. Click your project settings
  2. select **Build Phases** > **Link Binary With Library**
  3. Click the **+** button > select the Framework > Click **Add**

Add a bridging header for **UnityAds.framework**
  1. Create a new file in your project called **UnityAds-Bridging-Header.h**
  2. In the file, add the following line:  
  
**`#import <UnityAds/UnityAds.h>`**

### Initialize Unity Ads

Add UnityAds to your **AppDelegate**
  1. Open **AppDelegate.swift**
  2. Create a shared instance of Unity ads by adding the following code to your **AppDelegate** class  
```Swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let unityAds = UnityAds() //Create a shared instance of Unity Ads
```

Initialize Unity Ads in your *root ViewController*
1. Open your root ViewController
2. In **viewDidLoad()**, add the following code to initialize the SDK  
```Swift
override func viewDidLoad() {
  super.viewDidLoad()

  UnityAds.sharedInstance().delegate = self
  UnityAds.sharedInstance().setTestMode(true) //enable client-side test mode
  UnityAds.sharedInstance().startWithGameId("1003843", andViewController: self)
```
> NOTE: The game ID in the example project is **1003843**, you need to replace this number with your own game ID

Add the *@required* callback to your root ViewController  

```Swift
func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool {
  if (!skipped) {
    //Provide ingame reward, give coins, report to analytics, etc...
  }
}
```
> Note: **rewardItemKey** was deprecated; Use custom zones in the [dashboard](https://dashboard.unityads.unity3d.com) to track reward types

### Show a Video Ad

In the root View Controller, the following function will play a video ad

```swift
func playAd(placement: String) {
  if (UnityAds.sharedInstance().canShow(placement)) {
    UnityAds.sharedInstance().show(placement)
  }
}
```

To call an ad from another ViewController (including a SpriteKit or Cocos2D scene)
```swift
let vc = self.view!.window!.rootViewController as! YourRootViewController
vc.playAd("video")
```

For more information, check out the [iOS Integration Guide](http://unityads.unity3d.com/help/monetization/integration-guide-ios), the [support Forum](http://forum.unity3d.com/forums/unity-ads.67/), or contact unityads-sales@unity3d.com
