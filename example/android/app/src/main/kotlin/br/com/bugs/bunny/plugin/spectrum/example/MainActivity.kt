package br.com.bugs.bunny.plugin.spectrum.example

import android.os.Build
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.KITKAT) {
      intent.putExtra("enable-software-rendering", true)
    }
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}

