package com.example.fintech_task

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SIM_CHANNEL = "sim_manager"
    private val SMS_CHANNEL = "sms_manager"
    private val SIM_STREAM = "sim_manager_stream"
    private val PERMISSION_REQUEST_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SIM_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSimCards" -> {
                    if (checkSimPermissions()) {
                        val simCards = getSimCardsInfo()
                        result.success(simCards)
                    } else {
                        result.error("PERMISSION_DENIED", "SIM permissions not granted", null)
                    }
                }
                "checkPermissions" -> {
                    result.success(checkSimPermissions())
                }
                "requestPermissions" -> {
                    requestSimPermissions()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getFinancialSms" -> {
                    if (checkSmsPermissions()) {
                        val messages = getFinancialSmsMessages()
                        result.success(messages)
                    } else {
                        result.error("PERMISSION_DENIED", "SMS permissions not granted", null)
                    }
                }
                "checkSmsPermissions" -> {
                    result.success(checkSmsPermissions())
                }
                "requestSmsPermissions" -> {
                    requestSmsPermissions()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkSimPermissions(): Boolean {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            arrayOf(
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_PHONE_NUMBERS
            )
        } else {
            arrayOf(Manifest.permission.READ_PHONE_STATE)
        }

        return permissions.all {
            ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun requestSimPermissions() {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            arrayOf(
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_PHONE_NUMBERS
            )
        } else {
            arrayOf(Manifest.permission.READ_PHONE_STATE)
        }

        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE)
    }

    private fun getSimCardsInfo(): List<Map<String, Any>> {
        val simCards = mutableListOf<Map<String, Any>>()
        
        try {
            val subscriptionManager = getSystemService(TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val telephonyManager = getSystemService(TELEPHONY_SERVICE) as TelephonyManager

            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                return simCards
            }

            val activeSubscriptions: List<SubscriptionInfo> = subscriptionManager.activeSubscriptionInfoList ?: emptyList()

            activeSubscriptions.forEachIndexed { index, info ->
                val simCard = mapOf(
                    "iccid" to (info.iccId ?: "Unknown"),
                    "phoneNumber" to (info.number ?: "Unknown"),
                    "carrierName" to (info.carrierName?.toString() ?: "Unknown"),
                    "countryCode" to (info.countryIso ?: ""),
                    "slotIndex" to (info.simSlotIndex + 1),
                    "isActive" to true,
                    "connectionStatus" to "connected",
                    "signalStrength" to 4,
                    "networkType" to getNetworkType(telephonyManager),
                    "isRoaming" to false,
                    "isDefaultDataSim" to (index == 0)
                )
                simCards.add(simCard)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return simCards
    }

    private fun getNetworkType(telephonyManager: TelephonyManager): String {
        return try {
            when (telephonyManager.dataNetworkType) {
                TelephonyManager.NETWORK_TYPE_LTE -> "4g"
                TelephonyManager.NETWORK_TYPE_NR -> "5g"
                TelephonyManager.NETWORK_TYPE_HSDPA,
                TelephonyManager.NETWORK_TYPE_HSUPA,
                TelephonyManager.NETWORK_TYPE_HSPA,
                TelephonyManager.NETWORK_TYPE_HSPAP -> "3g"
                else -> "unknown"
            }
        } catch (e: Exception) {
            "unknown"
        }
    }

    private fun checkSmsPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_SMS),
            PERMISSION_REQUEST_CODE + 1
        )
    }

    private fun getFinancialSmsMessages(): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        
        val financialKeywords = listOf(
            "otp", "code", "verification",
            "transaction", "paid", "payment", "debit", "credit",
            "balance", "account", "bank",
            "تحويل", "رصيد", "دفع", "سحب"
        )

        try {
            val cursor = contentResolver.query(
                android.provider.Telephony.Sms.CONTENT_URI,
                arrayOf("_id", "address", "body", "date"),
                null,
                null,
                "date DESC LIMIT 50"
            )

            cursor?.use {
                val idIndex = it.getColumnIndex("_id")
                val addressIndex = it.getColumnIndex("address")
                val bodyIndex = it.getColumnIndex("body")
                val dateIndex = it.getColumnIndex("date")

                while (it.moveToNext()) {
                    val body = it.getString(bodyIndex)
                    val isFinancial = financialKeywords.any { keyword ->
                        body.contains(keyword, ignoreCase = true)
                    }

                    if (isFinancial) {
                        val category = when {
                            body.contains("otp", ignoreCase = true) || 
                            body.contains("code", ignoreCase = true) -> "otp"
                            body.contains("transaction", ignoreCase = true) ||
                            body.contains("paid", ignoreCase = true) -> "transaction"
                            body.contains("balance", ignoreCase = true) ||
                            body.contains("رصيد", ignoreCase = true) -> "balance"
                            body.contains("payment", ignoreCase = true) ||
                            body.contains("دفع", ignoreCase = true) -> "payment"
                            else -> "general"
                        }

                        val message = mapOf(
                            "id" to it.getString(idIndex),
                            "address" to it.getString(addressIndex),
                            "body" to body,
                            "date" to it.getLong(dateIndex),
                            "isFinancial" to true,
                            "category" to category
                        )
                        messages.add(message)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return messages
    }
}
