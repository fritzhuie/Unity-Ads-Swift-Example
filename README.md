This is an example project for implementing the Unity Ads SDK in a SpriteKit game using Swift

<i>Planet illustration provided by NASA - Original image by ESA/Hubble (M. Kornmesser) - https://www.spacetelescope.org/</i>

#How to integrate Unity Ads into your project

## 1. Import the Unity Ads Framework

####Download the Unity SDK from https://github.com/Applifier/unity-ads-sdk
  - [Down the zip file](https://github.com/Applifier/unity-ads-sdk/archive/master.zip)
  - Unzip the project, and locate `UnityAds.framework` and `UnityAds.bundle`

####Import `UnityAds.framework` and `UnityAds.bundle` into your project
  - Drag and drop the files into your project
  - Select the box next to "Copy 

####Make sure all of the following dependancies are enabled in your project
  
  `CoreMedia.framework`,  `CoreTelephony.framework`,
  
  `SystemConfiguration.framework`, `AdSupport.framework`,
  
  `CFNetwork.framework`, `StoreKit.framework`

####Add a bridging header for `UnityAds.framework`
  - Create a new file in your project called **UnityAds-Bridging-Header.h**
  - In the file, add the following line:
  
> **`#import <UnityAds/UnityAds.h>`**

## 2. Initialize Unity Ads

####In Your AppDelegate:
- Create a shared instance of Unity ads

<code>
<b>static let unityAds = UnityAds()</b>
</code>

####In Your Root View Controller
- Initialize the SDK

<code>
UnityAds.sharedInstance().startWithGameId("YOUR_GAME_ID", andViewController: self)
</code>

- Implement unityAdsVideoCompleted callback

<code>
func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {if (!skipped) {//Provide ingame reward}}</code>

- Implement a method for displaying ads

<code>
UnityAds.sharedInstance().canShowZone(placement)) { UnityAds.sharedInstance().show() )</code>

####In Your SKScene or Any ViewController

- Call for a rewarded ad

<code>
let vc = self.view!.window!.rootViewController as! YourRootViewController
vc.playAd("rewardedVideo")
</code>
