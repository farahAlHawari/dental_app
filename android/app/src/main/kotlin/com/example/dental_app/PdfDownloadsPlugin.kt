package com.example.dental_app

import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class PdfDownloadsPlugin : FlutterPlugin, ActivityAware {
    private var channel: MethodChannel? = null
    private var appContext: Context? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            if (call.method != "savePdfToDownloads") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val fileName = call.argument<String>("fileName") ?: "report.pdf"
            val bytes = call.argument<ByteArray>("bytes")
            if (bytes == null) {
                result.error("NO_BYTES", "Missing PDF bytes", null)
                return@setMethodCallHandler
            }

            val context = activity ?: appContext
            if (context == null) {
                result.error("NO_CONTEXT", "No Android context", null)
                return@setMethodCallHandler
            }

            try {
                result.success(savePdfToDownloads(context, fileName, bytes))
            } catch (e: Exception) {
                result.error("SAVE_FAILED", e.message, null)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        appContext = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    private fun savePdfToDownloads(
        context: Context,
        fileName: String,
        bytes: ByteArray,
    ): String {
        val safeName = if (fileName.lowercase().endsWith(".pdf")) {
            fileName
        } else {
            "$fileName.pdf"
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, safeName)
                put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val resolver = context.contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Could not create Downloads entry")

            resolver.openOutputStream(uri)?.use { stream ->
                stream.write(bytes)
            } ?: throw IllegalStateException("Could not write PDF")

            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
            return uri.toString()
        }

        val dir = Environment.getExternalStoragePublicDirectory(
            Environment.DIRECTORY_DOWNLOADS,
        )
        if (!dir.exists()) {
            dir.mkdirs()
        }
        val file = uniqueFile(dir, safeName)
        FileOutputStream(file).use { it.write(bytes) }
        return file.absolutePath
    }

    private fun uniqueFile(dir: File, fileName: String): File {
        val file = File(dir, fileName)
        if (!file.exists()) return file

        val dot = fileName.lastIndexOf('.')
        val base = if (dot > 0) fileName.substring(0, dot) else fileName
        val ext = if (dot > 0) fileName.substring(dot) else ""
        var index = 1
        while (true) {
            val candidate = File(dir, "$base ($index)$ext")
            if (!candidate.exists()) return candidate
            index++
        }
    }

    companion object {
        const val CHANNEL = "dental_app/files"
    }
}
