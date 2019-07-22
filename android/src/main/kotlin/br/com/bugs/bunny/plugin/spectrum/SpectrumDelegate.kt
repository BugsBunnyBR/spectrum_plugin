package br.com.bugs.bunny.plugin.spectrum

import android.content.Context
import br.com.bugs.bunny.plugin.spectrum.request.TranscodeRequest
import com.facebook.spectrum.EncodedImageSink
import com.facebook.spectrum.EncodedImageSource
import com.facebook.spectrum.ISpectrum
import com.facebook.spectrum.options.TranscodeOptions
import com.facebook.spectrum.requirements.EncodeRequirement
import io.flutter.Log


interface SpectrumDelegate {
  @Throws(Exception::class)
  fun transcode(tr: TranscodeRequest): Map<String, Any?>
}

class SpectrumDelegateImpl(private val spectrum: ISpectrum, private val context: Context) : SpectrumDelegate {

  @Throws(Exception::class)
  override fun transcode(tr: TranscodeRequest): Map<String, Any?> {

    val requirement = EncodeRequirement(tr.format, tr.quality, tr.mode)
    val builder = TranscodeOptions.Builder(requirement)
        .apply {
          tr.resize?.let { resize ->
            resize(resize.toRequirement())
          }
          tr.crop?.let { crop ->
            crop(crop.toRequirement())
          }
          tr.rotate?.let { rotate ->
            rotate(rotate.toRequirement())
          }
        }
    try {

      context.contentResolver.openInputStream(tr.source).use { inputStream ->
        val sr = spectrum.transcode(
            EncodedImageSource.from(inputStream),
            EncodedImageSink.from(tr.sink),
            builder.build(),
            tr.callerContext)
        return TranscodeResponse.Builder.build(sr)
      }

    }
    catch (e: Throwable) {
      Log.e("SpectrumDelegate", "Fail to read image", e)
      return mapOf("isSuccessful" to false)
    }
  }
}