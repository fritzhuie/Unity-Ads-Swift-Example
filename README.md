This is an example project for implementing the Unity Ads SDK in a SpriteKit game using Swift

<i>Planet illustration provided by NASA - Original image by ESA/Hubble (M. Kornmesser) - https://www.spacetelescope.org/</i>

#How to integrate Unity Ads into your project

### Import the Unity Ads Framework

Download the Unity SDK from https://github.com/Applifier/unity-ads-sdk
  - [Down the zip file](https://github.com/Applifier/unity-ads-sdk/archive/master.zip)
  - Unzip the project, and locate **UnityAds.framework** and **UnityAds.bundle**

Import **UnityAds.framework** and **UnityAds.bundle** into your project
  - Drag and drop the files into your project
  - Select the box next to "Copy 

Make sure all of the following dependancies are enabled in your project
  
  `CoreMedia.framework`,  `CoreTelephony.framework`,
  
  `SystemConfiguration.framework`, `AdSupport.framework`,
  
  `CFNetwork.framework`, `StoreKit.framework`

Add a bridging header for **UnityAds.framework**
  - Create a new file in your project called **UnityAds-Bridging-Header.h**
  - In the file, add the following line:
  
**`#import <UnityAds/UnityAds.h>`**

### Initialize Unity Ads

Add UnityAds to your **AppDelegate**
- Open **AppDelegate.swift**
- Create a shared instance of Unity ads by adding the following code to your **AppDelegate** class
```Swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let unityAds = UnityAds() //Create a shared instance of Unity Ads
```

Initialize Unity Ads in your *root ViewController*
- Open your root ViewController
- In **viewDidLoad()**, add the following code to initialize the SDK
```Swift
override func viewDidLoad() {
  super.viewDidLoad()

  UnityAds.sharedInstance().delegate = self
  UnityAds.sharedInstance().setTestMode(true) //enable client-side test mode
  UnityAds.sharedInstance().startWithGameId("1003843", andViewController: self)
```
> NOTE: The game ID in the example project is **1003843**, you need to replace this number with your own game ID

Add unityAdsVideoCompleted callback to your root ViewController
- In your root ViewController, add the following function:
- 
```Swift
func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool {
  if (!skipped) {
    //Provide ingame reward, give coins, report to analytics, etc...
  }
}
```
- Implement a method for displaying ads

<code>
UnityAds.sharedInstance().canShowZone(placement)) { UnityAds.sharedInstance().show() )</code>

####In Your SKScene or Any ViewController

- Call for a rewarded ad

<code>
let vc = self.view!.window!.rootViewController as! YourRootViewController
vc.playAd("rewardedVideo")
</code>
