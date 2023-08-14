package com.firtorent.awarz

import android.os.CountDownTimer
import android.util.Log
import com.facebook.FacebookSdk
import com.google.android.gms.ads.identifier.AdvertisingIdClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import com.appsflyer.AppsFlyerConversionListener
import com.appsflyer.AppsFlyerLib
import com.facebook.applinks.AppLinkData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlin.coroutines.suspendCoroutine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_AGENT
        ).setMethodCallHandler { call,
                                 result ->
            if (call.method.equals("getUserAgent")) {
                result.success(System.getProperty("http.agent") ?: "")
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_FB
        ).setMethodCallHandler { call,
                                 result ->
            if (call.method.equals("initfb")) {
                val param1 = call.argument<String>("param1")!!
                val param2 = call.argument<String>("param2")!!

                FacebookSdk.setApplicationId(param1)
                FacebookSdk.setClientToken(param2)
                FacebookSdk.sdkInitialize(context)
                FacebookSdk.fullyInitialize()

                result.success(true)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_UID
        ).setMethodCallHandler { call,
                                 result ->
            if (call.method.equals("get_uid")) {
                val uid =  AppsFlyerLib.getInstance().getAppsFlyerUID(context.applicationContext)
                result.success(uid)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_NAMING
        ).setMethodCallHandler { call,
                                 result ->
            if (call.method.equals("get_naming")) {
                CoroutineScope(Dispatchers.Main).launch {
                    val key = call.argument<String>("key")!!
                    val naming = getNaming(key)
                    result.success(naming)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GET_DEEP
        ).setMethodCallHandler { call,
                                 result ->
            if (call.method.equals("get_deep")) {
                CoroutineScope(Dispatchers.Main).launch {
                    val deep = getDeepLink()
                    result.success(deep)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private suspend fun getNaming(key: String): String {
        return suspendCoroutine {
            var isFinishedSucceed = false
            val timer = object : CountDownTimer(14_000, 1000) {
                override fun onTick(millisUntilFinished: Long) {
                }

                override fun onFinish() {
                    if (!isFinishedSucceed) it.resumeWith(Result.success(""))
                }
            }.start()
            val conversionListener = object : AppsFlyerConversionListener {

                override fun onConversionDataSuccess(map: MutableMap<String, Any>?) {
                    if (map != null) {
                        if (map.isNotEmpty()) {
                            val credentials = if (map["af_status"].toString() != "Organic") {
                                map["campaign"].toString()
                            } else {
                                ""
                            }
                            isFinishedSucceed = true
                            timer.cancel()
                            it.resumeWith(Result.success(credentials))
                        } else {
                            isFinishedSucceed = true
                            timer.cancel()
                            it.resumeWith(Result.success(""))
                        }
                    } else {
                        isFinishedSucceed = true
                        timer.cancel()
                        it.resumeWith(Result.success(""))
                    }
                }

                override fun onConversionDataFail(p0: String?) {
                    isFinishedSucceed = true
                    timer.cancel()
                    it.resumeWith(Result.success(""))
                }

                override fun onAppOpenAttribution(p0: MutableMap<String, String>?) {
                    isFinishedSucceed = true
                    timer.cancel()
                    it.resumeWith(Result.success(""))
                }

                override fun onAttributionFailure(p0: String?) {
                    isFinishedSucceed = true
                    timer.cancel()
                    it.resumeWith(Result.success(""))
                }
            }
            AppsFlyerLib.getInstance().apply {
                init(key, conversionListener, context)
                start(context)
            }
        }
    }

    suspend fun getDeepLink(): String? {
        return suspendCoroutine { coroutine ->
            try {
                AppLinkData.fetchDeferredAppLinkData(context) { appLinkData ->
                    coroutine.resumeWith(Result.success(appLinkData?.targetUri?.host))
                }
            } catch (e: Exception) {
                coroutine.resumeWith(Result.success(null))
            }
        }
    }

    companion object {
        private const val GET_AGENT = "get_agent"
        private const val GET_FB = "get_fb"
        private const val GET_UID = "get_uid"
        private const val GET_NAMING = "get_naming"
        private const val GET_DEEP = "get_deep"
    }
}
