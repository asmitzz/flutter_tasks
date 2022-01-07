package com.example.flutter_tasks

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "username"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->

      if(call.method == "getUsername"){
          val username = getUsername()
          if(username != -1){
             result.success(username)
          }
          else{
             result.error("UNAVAILABLE", "Username not available.", null)
          }
      }
      else{
         result.notImplemented()
      }
       
    }

    private fun getUsername() : String{
         return "Asmit"
    }
  }
}
