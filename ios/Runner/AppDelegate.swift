import UIKit
import Flutter
import GoogleMaps
import Braintree
import BraintreeDropIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAIB_jrdSCoM7SB_AixhfGycL7Tyd_8oqk")
    GeneratedPluginRegistrant.register(with: self)
    BTAppSwitch.setReturnURLScheme("com.charismakausar.foodstack.payments")
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
