package com.example.flutter_tasks

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "username"
    private fun getUsername() : String{
      return "Asmit"
 }

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

    

   EventChannel(flutterEngine.dartExecutor.binaryMessenger, "timer").setStreamHandler(
      object : EventChannel.StreamHandler {
          override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
            startTimer(events)
          }

          override fun onCancel(arguments: Any?) {
          }
      }

) 

   startTimer(events){
      object : CountDownTimer(30000, 1000) {
 
         override fun onTick(millisUntilFinished: Long) {
            events?.success(millisUntilFinished / 1000);
         }
    
         override fun onFinish() {
             
         }
     }.start()
   }

  }


}
