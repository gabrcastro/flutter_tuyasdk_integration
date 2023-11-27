package com.example.testfluter.scan

import android.content.Context
import android.util.Log
import android.widget.Toast
import com.thingclips.smart.android.ble.api.LeScanSetting
import com.thingclips.smart.android.ble.api.ScanDeviceBean
import com.thingclips.smart.android.ble.api.ScanType
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.home.sdk.bean.ConfigProductInfoBean
import com.thingclips.smart.sdk.api.IThingDataCallback
import com.thingclips.smart.sdk.bean.DeviceBean

class ScanDevice (
    private val context: Context,
)  {

    private var deviceBean: ScanDeviceBean? = null
    private var deviceFound: DeviceFound? = null
    private val scanSetting = LeScanSetting.Builder()
        .setTimeout(60000)
        .addScanType(ScanType.SINGLE)
        .build()

    fun bluetoothScan() : DeviceFound? {
        Toast.makeText(context, "Blueetooth Scan", Toast.LENGTH_SHORT).show()

        ThingHomeSdk.getBleOperator().startLeScan(
            scanSetting
        ) { deviceBean ->
            Log.i("scan", "bluetoothScan: ${deviceBean?.data.toString()}")
            Toast.makeText(context, deviceBean?.data.toString(), Toast.LENGTH_SHORT).show()

            ThingHomeSdk.getActivatorInstance().getActivatorDeviceInfo(
                deviceBean?.productId,
                deviceBean?.uuid,
                deviceBean?.mac,
                object : IThingDataCallback<ConfigProductInfoBean> {
                    override fun onSuccess(resConfigProductInfoBean: ConfigProductInfoBean?) {
                        Log.i(
                            "scan",
                            "getDeviceInfo: ${resConfigProductInfoBean?.toString()}"
                        )
                        Toast.makeText(
                            context,
                            deviceBean?.data.toString(),
                            Toast.LENGTH_SHORT
                        ).show()

                        if (resConfigProductInfoBean?.name != null) {
                            deviceFound = DeviceFound(
                                name = resConfigProductInfoBean.name.toString(),
                                icon = resConfigProductInfoBean.icon.toString(),
                                type = deviceBean.deviceType
                            )
                        }
                    }

                    override fun onError(errorCode: String?, errorMessage: String?) {
                        Log.i("scan", "error getDeviceInfo: ${errorCode.toString()}")
                        Toast.makeText(context, errorMessage.toString(), Toast.LENGTH_SHORT)
                            .show()
                    }
                })
        }

        return deviceFound
    }

}