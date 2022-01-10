import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        startTimer(eventSink:events)

        return nil
        
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
         timerId?.invalidate()
         timerId = nil
        return nil
    }
    
    
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
      
    func registerPlugins(registry: FlutterPluginRegistry) {
          if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
             FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
          }
      }
      
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    

    var time = 30
var timerId : Timer?
    private func startTimer(eventSink: @escaping FlutterEventSink){
        
        if #available(iOS 10.0, *) {
           timerId = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                print("timer fired!")
                
                self.time -= 1
                eventSink(self.time)
                if(self.time==0){
                    timer.invalidate()
                    self.time = 30
                    eventSink(self.time)
                }
            }
        } else {
            // Fallback on earlier versions
        }
          
    
}
   
    
    private func getUsername(result: FlutterResult) -> String{
      let username = "Asmit"
      return username
    }
    



}
