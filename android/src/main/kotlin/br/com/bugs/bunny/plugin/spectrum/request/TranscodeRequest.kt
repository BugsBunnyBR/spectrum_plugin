package br.com.bugs.bunny.plugin.spectrum.request

import android.net.Uri
import br.com.bugs.bunny.plugin.spectrum.asInt
import br.com.bugs.bunny.plugin.spectrum.asMap
import br.com.bugs.bunny.plugin.spectrum.asString
import com.facebook.spectrum.image.EncodedImageFormat
import com.facebook.spectrum.requirements.EncodeRequirement
import java.io.File

data class TranscodeRequest(val source: Uri,
                            val sink: String,
                            val callerContext: String,
                            val format: EncodedImageFormat,
                            val mode: EncodeRequirement.Mode,
                            val quality: Int,
                            val resize: ResizeRequest? = null,
                            val crop: CropRequest? = null,
                            val rotate: RotateRequest? = null) {


  object Builder {
    @Throws
    fun build(data: Map<String, Any>): TranscodeRequest {
      val source = data["source"]
      val sink = data["sink"]
      val callerContext = data["callerContext"]
      val format = data["format"]
      val mode = data["mode"]
      val quality = data["quality"]

      val crop = data["crop"]
      val resize = data["resize"]
      val rotate = data["rotate"]

      if (
          source == null ||
          sink == null ||
          callerContext == null ||
          format == null ||
          mode == null ||
          quality == null ||
          crop == null ||
          resize == null ||
          rotate == null
      ) {
        throw Exception("Missing one or more parameters")
      }
      val src = source.asString()
      // NOTE: Android needs it to be done using Uri.fromFile()
      val srcUri = Uri.fromFile(File(src))

      return TranscodeRequest(
          source = srcUri,
          sink = sink.asString(),
          callerContext = callerContext.asString(),
          format = findFormat(format.asString()),
          mode = findEncodingMode(mode.asString()),
          quality = quality.asInt(),
          crop = CropRequest.Builder.build(crop.asMap()),
          resize = ResizeRequest.Builder.build(resize.asMap()),
          rotate = RotateRequest.Builder.build(rotate.asMap())
      )

    }

    private val supportedFormats = listOf(
        EncodedImageFormat.JPEG,
        EncodedImageFormat.PNG,
        EncodedImageFormat.WEBP
    )

    @Throws(Exception::class)
    private fun findEncodingMode(mode: String): EncodeRequirement.Mode {
      return EncodeRequirement.Mode.valueOf(mode.toUpperCase())
    }

    private fun findFormat(format: String): EncodedImageFormat {
      return supportedFormats.first { it.identifier.equals(format, true) }
    }

  }
}