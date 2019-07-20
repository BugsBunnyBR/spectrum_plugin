package br.com.bugs.bunny.plugin.spectrum.request

import br.com.bugs.bunny.plugin.spectrum.asBoolean
import br.com.bugs.bunny.plugin.spectrum.asDouble
import com.facebook.spectrum.requirements.CropRequirement

data class CropRequest(val left: Double,
                       val right: Double,
                       val top: Double,
                       val bottom: Double,
                       val mustBeExact: Boolean) {

  fun toRequirement(): CropRequirement {
    return CropRequirement.makeRelativeToOrigin(
        left.toFloat(),
        top.toFloat(),
        right.toFloat(),
        bottom.toFloat(),
        mustBeExact
    )
  }

  object Builder {

    @Throws(Exception::class)
    fun build(data: Map<String, Any>): CropRequest? {
      val left = data["left"]
      val top = data["top"]
      val right = data["right"]
      val bottom = data["bottom"]
      val mustBeExact = data["mustBeExact"]
      if (
          left == null ||
          top == null ||
          right == null ||
          bottom == null ||
          mustBeExact == null
      ) {
        return null
      }
      return CropRequest(
          left = left.asDouble(),
          top = top.asDouble(),
          right = right.asDouble(),
          bottom = bottom.asDouble(),
          mustBeExact = mustBeExact.asBoolean()
      )
    }


  }
}