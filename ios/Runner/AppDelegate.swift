import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,FlutterStreamHandler {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let usernameChannel = FlutterMethodChannel(name: "username",
                                                    binaryMessenger: controller.binaryMessenger)
      usernameChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "getUsername" else {
              result(FlutterMethodNotImplemented)
              return
            }
            result(self.getUsername(result: result))
          })

      let timerChannel = FlutterEventChannel(name: "timer",
                                              binaryMessenger: controller.binaryMessenger)
      timerChannel.setStreamHandler(self)

  


    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }



   public func onListen(withArguments arguments: Any?,
                       eventSink: @escaping FlutterEventSink) -> FlutterError? {
            startTimer(eventSink:eventSink)
      
  }

    let time = 30

    private func startTimer(eventSink: @escaping FlutterEventSink){
     Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: false)
     @objc func action () {
       time = time - 1
   eventSink(time)
}
   
    }

    
    
    private func getUsername(result: FlutterResult) -> String{
      let username = "Asmit"
      return username
    }
    
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}


