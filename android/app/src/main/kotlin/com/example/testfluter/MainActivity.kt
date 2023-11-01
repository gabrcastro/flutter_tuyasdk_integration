package com.example.testfluter

import android.util.Log
import android.widget.Toast
import com.thingclips.smart.activator.core.kit.bean.ThingActivatorScanKey
import com.thingclips.smart.android.ble.api.BleScanResponse
import com.thingclips.smart.android.ble.api.LeScanSetting
import com.thingclips.smart.android.ble.api.ScanDeviceBean
import com.thingclips.smart.android.ble.api.ScanType
import com.thingclips.smart.android.device.bean.DeviceDpInfoBean
import com.thingclips.smart.android.network.request.ThingSmartNetWorkConfig
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.user.api.ILogoutCallback
import com.thingclips.smart.android.user.api.IRegisterCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.home.sdk.bean.ConfigProductInfoBean
import com.thingclips.smart.home.sdk.bean.HomeBean
import com.thingclips.smart.home.sdk.builder.ActivatorBuilder
import com.thingclips.smart.home.sdk.callback.IThingGetHomeListCallback
import com.thingclips.smart.home.sdk.callback.IThingHomeResultCallback
import com.thingclips.smart.sdk.api.IResultCallback
import com.thingclips.smart.sdk.api.IThingActivator
import com.thingclips.smart.sdk.api.IThingActivatorGetToken
import com.thingclips.smart.sdk.api.IThingDataCallback
import com.thingclips.smart.sdk.api.IThingSmartActivatorListener
import com.thingclips.smart.sdk.bean.DeviceBean
import com.thingclips.smart.sdk.enums.ActivatorEZStepCode
import com.thingclips.smart.sdk.enums.ActivatorModelEnum
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    private lateinit var channel: MethodChannel
    private var currentHomeBean: HomeBean? = null
    private var currentDeviceBean: DeviceBean? = null
    private var thingActivator: IThingActivator? = null
    private var devicesFound: MutableList<Any?>? = null
    private var devices: MutableList<Devices>? = null
    private var rooms: List<String> = listOf("Living Room")
    private var dataDeviceFound: Any? = null
    private var activatorScanKey: ThingActivatorScanKey? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        ThingHomeSdk.setDebugMode(true)
        ThingHomeSdk.init(
            application,
            "9uhxr4vup89da4afxjut",
            "3hpra89jcrfrk84cqrd5s79yhpwjhncy"
        )

        channel.setMethodCallHandler { call, result ->

            val argument = call.arguments as Map<String, String>
            val countryCode = argument["country_code"]
            val ssid = argument["ssid"]
            val networkPasswd = argument["networkPasswd"]
            val email = argument["email"]
            val password = argument["password"]
            val code = argument["code"]
            val homeName = argument["home_name"]
            val homeId: String? = argument["home_id"]
            val homeIdLong: Long? = homeId?.toLong()

            fun getRegistrationToken() {
                ThingSmartNetWorkConfig.Builder().build()
                Toast.makeText(context, "home: ${currentHomeBean?.homeId}", Toast.LENGTH_SHORT)
                    .show()
                currentHomeBean?.let {
                    ThingHomeSdk.getActivatorInstance().getActivatorToken(
                        it.homeId,
                        object : IThingActivatorGetToken {
                            override fun onSuccess(token: String?) {
                                thingActivator = ThingHomeSdk.getActivatorInstance()
                                    .newMultiActivator(
                                        ActivatorBuilder()
                                            .setContext(context)
                                            .setSsid(ssid)
                                            .setPassword(networkPasswd)
                                            .setActivatorModel(ActivatorModelEnum.THING_EZ)
                                            .setTimeOut(60000)
                                            .setToken(token)
                                            .setListener(object : IThingSmartActivatorListener {
                                                override fun onError(
                                                    errorCode: String?,
                                                    errorMsg: String?
                                                ) {
                                                    Log.i(
                                                        "devices",
                                                        "error: ${errorMsg.toString()}"
                                                    )
                                                    Toast.makeText(
                                                        context,
                                                        errorMsg.toString(),
                                                        Toast.LENGTH_SHORT
                                                    )
                                                        .show()
                                                }

                                                override fun onActiveSuccess(devResp: DeviceBean?) {
                                                    Log.i(
                                                        "devices",
                                                        "success: ${devResp.toString()}"
                                                    )
                                                    Toast.makeText(
                                                        context,
                                                        devResp.toString(),
                                                        Toast.LENGTH_SHORT
                                                    )
                                                        .show()
                                                    currentDeviceBean = devResp
                                                    result.success(ACTIVE_SUCCESS)
                                                }

                                                override fun onStep(step: String?, data: Any?) {
                                                    Log.i("devices", "step: ${data.toString()}")
                                                    when (step) {
                                                        ActivatorEZStepCode.DEVICE_FIND ->
                                                            Toast.makeText(
                                                                context,
                                                                "device find",
                                                                Toast.LENGTH_SHORT
                                                            ).show()


                                                        ActivatorEZStepCode.DEVICE_BIND_SUCCESS ->
                                                            Toast.makeText(
                                                                context,
                                                                "device bind",
                                                                Toast.LENGTH_SHORT
                                                            ).show()
                                                    }
                                                }
                                            })
                                    )
                                Log.i("device", thingActivator.toString())
                            }

                            override fun onFailure(errorCode: String?, errorMsg: String?) {
                                Toast.makeText(
                                    context,
                                    "Failed get Registration Token",
                                    Toast.LENGTH_SHORT
                                )
                                    .show()
                            }
                        }
                    )
                }
            }
            fun createHome(homeName: String) {
                ThingHomeSdk.getHomeManagerInstance().createHome(
                    homeName,
                    0.0,
                    0.0,
                    null,
                    rooms,
                    object : IThingHomeResultCallback {
                        override fun onSuccess(bean: HomeBean?) {
                            currentHomeBean = bean
                            Log.i("homebeans", bean.toString())
                        }

                        override fun onError(errorCode: String?, errorMsg: String?) {
                            Toast.makeText(context, "Error home created", Toast.LENGTH_LONG)
                                .show()
                        }
                    }
                )
            }
            fun bluetoothScan(callback: (ScanDeviceBean?) -> Unit) {

                var deviceBean: ScanDeviceBean? = null

                Toast.makeText(context, "Blueetooth Scan", Toast.LENGTH_SHORT).show()

                val scanSetting = LeScanSetting.Builder()
                    .setTimeout(60000)
                    .addScanType(ScanType.SINGLE)
                    .build()

                ThingHomeSdk.getBleOperator().startLeScan(
                    scanSetting
                ) { bean ->
                    callback(bean)
                }
            }

            if (call.method == ALREADY_LOGGED) {
                val isLogged = ThingHomeSdk.getUserInstance().isLogin
                result.success(isLogged)
            }
            if (call.method == SEND_CODE) {
                ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(
                    email.toString(),
                    "",
                    countryCode.toString(),
                    1,
                    object : IResultCallback {
                        override fun onError(code: String?, error: String?) {
                            Toast.makeText(context, "Erro: $code - $error", Toast.LENGTH_LONG)
                                .show()
                        }

                        override fun onSuccess() {
                            Toast.makeText(context, "Codigo enviado", Toast.LENGTH_LONG)
                                .show()
                        }
                    }
                )
            }
            if (call.method == REGISTER) {
                ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                    countryCode.toString(),
                    email.toString(),
                    password.toString(),
                    code.toString(),
                    object : IRegisterCallback {
                        override fun onSuccess(user: User?) {
                            Toast.makeText(context, "User: $user", Toast.LENGTH_LONG)
                                .show()
                        }

                        override fun onError(code: String?, error: String?) {
                            Toast.makeText(context, "Erro: $code - $error", Toast.LENGTH_LONG)
                                .show()
                        }
                    }
                )
            }
            if (call.method == AUTHENTICATE) {
                //String countryCode, String email, String passwd, final ILoginCallback callback
                ThingHomeSdk.getUserInstance().loginWithEmail(
                    countryCode.toString(),
                    email.toString(),
                    password.toString(),
                    object : ILoginCallback {
                        override fun onSuccess(user: User?) {
                            user?.let {
                                result.success(it.uid)
                            }
                        }

                        override fun onError(code: String?, error: String?) {
                            if (code != null && error != null) {
                                result.error(code, error, null)
                            };
                        }
                    }
                )
            }
            if (call.method == LOGOUT) {
                ThingHomeSdk.getUserInstance().logout(object : ILogoutCallback {
                    override fun onSuccess() {
                        Toast.makeText(context, "Logout success", Toast.LENGTH_SHORT).show()
                        result.success(true)
                    }

                    override fun onError(p0: String?, p1: String?) {
                        Toast.makeText(context, p1.toString(), Toast.LENGTH_SHORT).show()
                        result.error(p0.toString(), p1.toString(), null)
                    }
                })
            }
            if (call.method == SEARCH_DEVICES) {
                bluetoothScan { deviceBean ->
                    Log.i("scan", "bluetoothScan")
                    Log.i("scan", "bluetoothScan: ${deviceBean?.data.toString()}")
                    Log.i("scan", "bluetoothScan: ${deviceBean?.productId.toString()}")
                    Log.i("scan", "bluetoothScan: ${deviceBean?.name.toString()}")
                    Log.i("scan", "bluetoothScan: ${deviceBean?.providerName.toString()}")
                    Toast.makeText(context, deviceBean?.data.toString(), Toast.LENGTH_SHORT).show()

                    ThingHomeSdk.getActivatorInstance().getActivatorDeviceInfo(
                        deviceBean?.productId,
                        deviceBean?.uuid,
                        deviceBean?.mac,
                        object: IThingDataCallback<ConfigProductInfoBean> {
                            override fun onSuccess(resConfigProductInfoBean: ConfigProductInfoBean?) {
                                Log.i("scan", "getDeviceInfo: ${resConfigProductInfoBean?.toString()}")
                                Log.i("scan", "getDeviceInfo: ${resConfigProductInfoBean?.name.toString()}")
                                Toast.makeText(context, deviceBean?.data.toString(), Toast.LENGTH_SHORT).show()

                                if (resConfigProductInfoBean?.name != null) {
                                    var deviceFound = arrayListOf(
                                        resConfigProductInfoBean.name.toString(),
                                        resConfigProductInfoBean.icon.toString()
                                    )
                                    result.success(deviceFound)
                                }
                            }

                            override fun onError(errorCode: String?, errorMessage: String?) {
                                Log.i("scan", "error getDeviceInfo: ${errorCode.toString()}")
                                Toast.makeText(context, errorMessage.toString(), Toast.LENGTH_SHORT).show()
                            }
                        })
                }

            }
            if (call.method == STOP_SEARCH_DEVICES) {
                ThingHomeSdk.getBleOperator().stopLeScan();
                thingActivator?.stop()
                result.success(true)
            }
            if (call.method == TURN_ON_OFF_BULB) {
                ThingHomeSdk.getDeviceMultiControlInstance().getDeviceDpInfoList(
                    currentDeviceBean?.devId,
                    object : IThingDataCallback<ArrayList<DeviceDpInfoBean>> {
                        override fun onSuccess(result: ArrayList<DeviceDpInfoBean>?) {
                            Log.i("turn_on", result.toString())
                        }

                        override fun onError(errorCode: String?, errorMessage: String?) {
                            Log.i("turn_on", errorMessage.toString())
                        }
                    }
                )
            }
            if (call.method == GET_HOME_DEVICES) {
                Log.i("devices", homeId.toString()) //172533729
                Log.i("devices", "CURRENT HOME >>>>>>>>>>>>>>>>>>>")
                Log.i("devices", currentHomeBean.toString())
                if (homeIdLong != null) {
                    ThingHomeSdk.getHomeManagerInstance().queryHomeInfo(
                        homeIdLong,
                        object : IThingHomeResultCallback {
                            override fun onSuccess(bean: HomeBean?) {
                                result.success(bean.toString())
                                Log.i("devices", "DEVICES >>>>>>>>>>>>>>>>>>>")
                                Log.i("devices", bean.toString())
                            }

                            override fun onError(errorCode: String?, errorMsg: String?) {
                                Log.i("devices", "DEVICES >>>>>>>>>>>>>>>>>>>")
                                Log.i("devices", errorMsg.toString())
                            }
                        }
                    )
                }
            }
            if (call.method == CHECK_HOME_ALREADY_EXIST) {
                ThingHomeSdk.getHomeManagerInstance()
                    .queryHomeList(object : IThingGetHomeListCallback {
                        override fun onSuccess(homeBeans: MutableList<HomeBean>?) {
                            if (homeBeans != null) {
                                for (homeBean in homeBeans) {
                                    if (homeBean.name == "Home") {
                                        currentHomeBean = homeBean
                                    } else {
                                        createHome(homeName.toString())
                                    }
                                }
                            } else {
                                createHome(homeName.toString())
                            }
                            result.success(currentHomeBean?.homeId)
                            Log.i("homebeans", homeBeans.toString())
                        }

                        override fun onError(errorCode: String?, error: String?) {
                            Toast.makeText(context, error.toString(), Toast.LENGTH_SHORT).show()
                        }
                    })
            }
            if (call.method == START_PAIR) {
                // iniciar pareamento
            }
            if (call.method == CONFIG_PAIR) {
                // configurar pareamento
            }

        }
    }

    companion object {
        const val ALREADY_LOGGED = "already_logged"
        const val CHANNEL = "tuya_integration"
        const val SEND_CODE = "send_code"
        const val REGISTER = "register"
        const val AUTHENTICATE = "authenticate"
        const val LOGOUT = "logout"
        const val SEARCH = "search"
        const val START_PAIR = "start_pair"
        const val CONFIG_PAIR = "config_pair"
        const val SEARCH_DEVICES = "search_devices"
        const val STOP_SEARCH_DEVICES = "stop_search_devices"
        const val CONNECT_DEVICE = "connect_device"
        const val CREATE_HOME = "create_home"
        const val GET_ACTIVATOR_TOKEN = "get_activator_token"
        const val TURN_ON_OFF_BULB = "turn_on_off_bulb"
        const val GET_HOME_DEVICES = "get_home_devices"
        const val CHECK_HOME_ALREADY_EXIST = "check_home_exist"
        const val ACTIVE_SUCCESS = "active_success"
    }

}
