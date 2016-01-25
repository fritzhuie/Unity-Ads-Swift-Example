# SpaceAds-Swift
An example project for implementing the Unity Ads SDK in SpriteKit using Swift

<i>Planet illustration provided by NASA - Original image by ESA/Hubble (M. Kornmesser) - https://www.spacetelescope.org/</i>

##Integration summary:

- Download Unity SDK from https://github.com/Applifier/unity-ads-sdk

- Import UnityAds.framework and UnityAds.bundle to your project

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
