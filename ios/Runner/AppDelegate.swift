import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    loadRocketSimConnect()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  // TODO: remove this from release versions. #DEBUG flag doesn't work because of flutter
  private func loadRocketSimConnect() {
      guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
          print("Failed to load linker framework")
          return
      }
      print("RocketSim Connect successfully linked")
    }
}
