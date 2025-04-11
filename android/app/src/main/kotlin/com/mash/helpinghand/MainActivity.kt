package com.mash.helpinghand

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "helping_hand/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "rocketLaunch" -> {
                    launchApplication()
                    result.success(true)
                }
                "showToastNative" -> {
                    val message = call.argument<String>("message") ?: "Default message"
                    val duration = call.argument<String>("duration") ?: "short"
                    
                    Toast.makeText(this, message, if (duration == "long") Toast.LENGTH_LONG else Toast.LENGTH_SHORT).show()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun launchApplication() {
        val intent = packageManager.getLaunchIntentForPackage("com.mash.helping_hand") 
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } else {
            println("Target application not found!")
        }
    }
}
