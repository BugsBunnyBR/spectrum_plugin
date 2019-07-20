package br.com.bugs.bunny.plugin.spectrum

import android.annotation.SuppressLint
import android.content.Context
import android.os.AsyncTask
import android.util.Log
import br.com.bugs.bunny.plugin.spectrum.request.TranscodeRequest
import com.facebook.spectrum.DefaultPlugins
import com.facebook.spectrum.Spectrum
import com.facebook.spectrum.SpectrumSoLoader
import com.facebook.spectrum.logging.SpectrumLogcatLogger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class SpectrumPlugin(private val delegate: SpectrumDelegate) : MethodCallHandler {
  companion object {

    var isInitialized = false

    // NOTE: We can initialize Spectrum only once!
    // TODO: Figure out if I should ask the client developers to place this call in the application instance
    private fun initSpectrum(context: Context) {
      if (!isInitialized) {
        isInitialized = true
        SpectrumSoLoader.init(context)
      }
    }

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      initSpectrum(registrar.context())

      val spectrum = Spectrum.make(SpectrumLogcatLogger(Log.ERROR), DefaultPlugins.get())
      val delegate = SpectrumDelegateImpl(spectrum, registrar.context())
      val plugin = SpectrumPlugin(delegate)
      val channel = MethodChannel(registrar.messenger(), "br.com.bugs.bunny.plugin.spectrum")
      channel.setMethodCallHandler(plugin)
    }
  }

  @SuppressLint("StaticFieldLeak")
  override fun onMethodCall(call: MethodCall, result: Result) {

    if (call.method == "transcode") {

      object : AsyncTask<Void, Void, Map<String, Any?>>() {

        override fun doInBackground(vararg params: Void?): Map<String, Any?>? {

          val tr = TranscodeRequest.Builder.build(call.arguments.asMap())
          return delegate.transcode(tr)
        }

        override fun onPostExecute(map: Map<String, Any?>?) {
          super.onPostExecute(map)

          result.success(map)
        }
      }.execute()


    }
    else {
      result.notImplemented()
    }
  }

}
