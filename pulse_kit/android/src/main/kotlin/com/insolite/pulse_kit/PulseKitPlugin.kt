package com.insolite.pulse_kit

import android.os.SystemClock
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseClient
import androidx.health.services.client.ExerciseUpdateCallback
import androidx.health.services.client.HealthServices
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.ExerciseConfig
import androidx.health.services.client.data.ExerciseLapSummary
import androidx.health.services.client.data.ExerciseType
import androidx.health.services.client.data.ExerciseUpdate
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.coroutineScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.time.Instant

/**
 * Flutter plugin for accessing exercise data using Health Services API.
 */
class PulseKitPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ExerciseUpdateCallback {
    private lateinit var channel: MethodChannel
    private lateinit var lifecycleScope: CoroutineScope
    private lateinit var exerciseClient: ExerciseClient

    // Mapping of DataType to string representation.
    private val dataTypeStringMap = mapOf(
        DataType.HEART_RATE_BPM to "heartRate",
        DataType.CALORIES_TOTAL to "calories",
        DataType.STEPS_TOTAL to "steps",
        DataType.DISTANCE_TOTAL to "distance",
        DataType.SPEED to "speed",
    )

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pulse")
        channel.setMethodCallHandler(this)
        exerciseClient = HealthServices.getClient(flutterPluginBinding.applicationContext).exerciseClient
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopExercise()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val lifecycle: Lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        lifecycleScope = lifecycle.coroutineScope
        exerciseClient.setUpdateCallback(this)
    }

    // Unused callbacks.
    override fun onLapSummaryReceived(lapSummary: ExerciseLapSummary) {}
    override fun onRegistered() {}
    override fun onRegistrationFailed(throwable: Throwable) {}
    override fun onAvailabilityChanged(dataType: DataType<*, *>, availability: Availability) {}
    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}

    /**
     * Handles method calls from the Flutter side.
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSupportedExercises" -> getSupportedExercises(result)
            "startExercise" -> startExercise(call.arguments as Map<String, Any>, result)
            "stopExercise" -> {
                stopExercise()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Starts an exercise session.
     * @param arguments Map containing exercise type and sensor information.
     * @param result Result callback for the Flutter side.
     */
    private fun startExercise(arguments: Map<String, Any>, result: MethodChannel.Result) {
        val exerciseTypeId = arguments["exerciseType"] as? Int
            ?: throw IllegalArgumentException("Exercise type is required.")
        val exerciseType = ExerciseType.fromId(exerciseTypeId)

        val typeStrings = arguments["sensors"] as? List<String>
            ?: throw IllegalArgumentException("Sensor data is required.")
        val requestedDataTypes = typeStrings.map { dataTypeFromString(it) }

        val enableGps = arguments["enableGps"] as? Boolean
            ?: throw IllegalArgumentException("GPS enablement flag is required.")

        lifecycleScope.launch {
            try {
                val capabilities = exerciseClient.getCapabilitiesAsync().await()
                if (exerciseType !in capabilities.supportedExerciseTypes) {
                    result.error("UnsupportedExerciseType", "Exercise type $exerciseType is not supported.", null)
                    return@launch
                }

                val exerciseCapabilities = capabilities.getExerciseTypeCapabilities(exerciseType)
                val supportedDataTypes = exerciseCapabilities.supportedDataTypes
                val unsupportedDataTypes = requestedDataTypes - supportedDataTypes
                val supportedRequestedDataTypes = requestedDataTypes.intersect(supportedDataTypes)

                val config = ExerciseConfig(
                    exerciseType = exerciseType,
                    dataTypes = supportedRequestedDataTypes,
                    isAutoPauseAndResumeEnabled = false,
                    isGpsEnabled = enableGps,
                )

                exerciseClient.startExerciseAsync(config).await()

                result.success(mapOf("unsupportedWorkoutTypes" to unsupportedDataTypes.map { dataTypeToString(it) }))
            } catch (e: Exception) {
                result.error("ExerciseStartError", "Failed to start exercise: ${e.message}", null)
            }
        }
    }

    /**
     * Stops the current exercise session.
     */
    private fun stopExercise() {
        exerciseClient.endExerciseAsync()
    }

    /**
     * Converts a DataType object to its string representation.
     * @param type DataType to be converted.
     * @return String representation of the DataType.
     */
    private fun dataTypeToString(type: DataType<*, *>): String {
        return dataTypeStringMap[type] ?: "unknown"
    }

    /**
     * Converts a string representation of a DataType back to its DataType object.
     * @param string String representation of the DataType.
     * @return DataType corresponding to the given string.
     */
    private fun dataTypeFromString(string: String): DataType<*, *> {
        // Explicitly specifying the type of the map entry
        val entry = dataTypeStringMap.entries.firstOrNull { it.value == string }
            ?: throw IllegalArgumentException("Unknown data type: $string")
        return entry.key
    }

    /**
     * Retrieves and sends the list of supported exercises to the Flutter side.
     * @param result Result callback for the Flutter side.
     */
    private fun getSupportedExercises(result: MethodChannel.Result) {
        lifecycleScope.launch {
            try {
                val capabilities = exerciseClient.getCapabilitiesAsync().await()
                result.success(capabilities.supportedExerciseTypes.map { it.id })
            } catch (e: Exception) {
                result.error("ExerciseRetrievalError", "Failed to retrieve exercises: ${e.message}", null)
            }
        }
    }

    /**
     * Callback for receiving exercise updates.
     * @param update ExerciseUpdate received from the Health Services API.
     */
    override fun onExerciseUpdateReceived(update: ExerciseUpdate) {
        val bootInstant = Instant.ofEpochMilli(System.currentTimeMillis() - SystemClock.elapsedRealtime())

        update.latestMetrics.sampleDataPoints.forEach { dataPoint ->
            channel.invokeMethod("dataReceived", listOf(
                dataTypeToString(dataPoint.dataType),
                (dataPoint.value as Number).toDouble(),
                dataPoint.getTimeInstant(bootInstant).toEpochMilli()
            ))
        }

        update.latestMetrics.cumulativeDataPoints.forEach { dataPoint ->
            channel.invokeMethod("dataReceived", listOf(
                dataTypeToString(dataPoint.dataType),
                dataPoint.total.toDouble(),
                dataPoint.end.toEpochMilli()
            ))
        }
    }
}
