package br.com.bugs.bunny.plugin.spectrum.request


import br.com.bugs.bunny.plugin.spectrum.asInt
import br.com.bugs.bunny.plugin.spectrum.asString
import com.facebook.spectrum.image.ImageSize
import com.facebook.spectrum.requirements.ResizeRequirement

data class ResizeRequest(
    val mode: ResizeRequirement.Mode,
    val width: Int,
    val height: Int) {

  fun toRequirement(): ResizeRequirement {
    val imageSize = ImageSize(width, width)
    return ResizeRequirement(mode, imageSize)
  }

  object Builder {

    @Throws(Exception::class)
    fun build(data: Map<String, Any>): ResizeRequest? {
      val mode = data["mode"]
      val width = data["width"]
      val height = data["height"]
      if (
          mode == null ||
          width == null ||
          height == null
      ) {
        return null
      }

      return ResizeRequest(
          mode = findResizeMode(mode.asString()),
          width = width.asInt(),
          height = height.asInt()
      )
    }

    @Throws(Exception::class)
    private fun findResizeMode(mode: String): ResizeRequirement.Mode {
      return ResizeRequirement.Mode.valueOf(mode.toUpperCase())
    }

  }
}

