package com.example.listen_for_sms

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.wifi.hotspot2.pps.Credential
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.auth.api.phone.SmsRetrieverClient
import com.google.android.gms.tasks.OnSuccessListener
import com.google.android.gms.tasks.Task
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** ListenForSmsPlugin */
class ListenForSmsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    companion object {
        private const val PHONE_HINT_REQUEST = 11012
        private const val CHANNEL_NAME = "listen_for_sms"
    }
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var channel: MethodChannel
    private val pendingHintResult: Result? = null
    private var broadcastReceiver: BroadcastReceiver? = null

    private val activityResultListener: PluginRegistry.ActivityResultListener = object : PluginRegistry.ActivityResultListener {


        override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
            if (requestCode == PHONE_HINT_REQUEST && pendingHintResult != null) {
                if (resultCode == Activity.RESULT_OK && data != null) {
                    val credential: Credential? = data.getParcelableExtra<Credential>("Credential")!!
                    val phoneNumber: String = credential.getId()
                    pendingHintResult.success(phoneNumber)
                } else {
                    pendingHintResult.success(null)
                }
                return true
            }
            return false
        }
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.app/smsStream")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
//        } else {
//            result.notImplemented()
//        }
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "startListening" -> {
                val smsCodeRegexPattern : String? = call.argument("smsCodeRegexPattern")
                val client : SmsRetrieverClient = SmsRetriever.getClient(activity)
                val task: Task<Void> = client.startSmsRetriever()

                task.addOnSuccessListener { OnSuccessListener<Void>() {
                    unregisterReceiver()
                } }

                startListening()
            }
            "stopListening" -> {
                stopListening()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun unregisterReceiver() {
        if (broadcastReceiver != null) {
            try {
                activity.unregisterReceiver(broadcastReceiver)
            } catch (ex: Exception) {
                // silent catch to avoir crash if receiver is not registered
            }
            broadcastReceiver = null
        }
    }

    private fun setupChannel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun startListening() {
    }

    private fun stopListening() {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
        binding.addActivityResultListener(activityResultListener);
    }

    override fun onDetachedFromActivityForConfigChanges() {
        unregisterReceiver()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity;
        binding.addActivityResultListener(activityResultListener);
    }

    override fun onDetachedFromActivity() {
        unregisterReceiver()
    }
}