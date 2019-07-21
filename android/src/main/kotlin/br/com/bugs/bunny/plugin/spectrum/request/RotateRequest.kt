package br.com.bugs.bunny.plugin.spectrum.request

import br.com.bugs.bunny.plugin.spectrum.asBoolean
import br.com.bugs.bunny.plugin.spectrum.asInt
import com.facebook.spectrum.requirements.RotateRequirement

data class RotateRequest(val degrees: Int,
                         val flipVertically: Boolean,
                         val flipHorizontally: Boolean,
                         val forceUpOrientation: Boolean) {

  fun toRequirement(): RotateRequirement {
    return RotateRequirement(
        degrees,
        flipHorizontally,
        flipVertically,
        forceUpOrientation
    )
  }

  object Builder {

    @Throws(Exception::class)
    fun build(data: Map<String, Any>): RotateRequest? {
      val degrees = data["degrees"]
      val flipHorizontally = data["flipHorizontally"]
      val flipVertically = data["flipVertically"]
      val forceUpOrientation = data["forceUpOrientation"]

      if (degrees == null ||
          flipHorizontally == null ||
          flipVertically == null ||
          forceUpOrientation == null
      ) {
        return null
      }
      return RotateRequest(
          degrees = degrees.asInt(),
          flipHorizontally = flipHorizontally.asBoolean(),
          flipVertically = flipVertically.asBoolean(),
          forceUpOrientation = forceUpOrientation.asBoolean()
      )
    }

  }
}