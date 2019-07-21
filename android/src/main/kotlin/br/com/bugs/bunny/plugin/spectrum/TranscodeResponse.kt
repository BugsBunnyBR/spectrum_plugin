package br.com.bugs.bunny.plugin.spectrum

import com.facebook.spectrum.SpectrumResult
import com.facebook.spectrum.image.ImageSize
import com.facebook.spectrum.image.ImageSpecification


class TranscodeResponse {
  object Builder {
    fun build(sr: SpectrumResult): Map<String, Any?> {
      return mapOf(
          "isSuccessful" to sr.isSuccessful,
          "ruleName" to sr.ruleName,
          "totalBytesRead" to sr.totalBytesRead,
          "totalBytesWritten" to sr.totalBytesWritten,
          "inputImageSpecification" to sr.inputImageSpecification?.asMap(),
          "outputImageSpecification" to sr.outputImageSpecification?.asMap()
      )
    }

    private fun ImageSpecification.asMap(): Map<String, Any?> {
      return mapOf(
          "chromaSamplingMode" to chromaSamplingMode?.name,
          "format" to format.identifier.toUpperCase(),
          "orientation" to orientation.name.toUpperCase(),
          // NOTE: There is no implementation available in the library for metadata :-/
          "metadata" to mapOf<String, Any>(),
          "size" to size.asMap(),
          "pixelSpecification" to pixelSpecification.name.toUpperCase()
      )
    }

    private fun ImageSize.asMap(): Map<String, Int> {
      return mapOf(
          "width" to width,
          "height" to height
      )
    }

  }
}