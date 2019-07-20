package br.com.bugs.bunny.plugin.spectrum


fun Any.asDouble(): Double {
  return this as Double
}

fun Any.asBoolean(): Boolean {
  return this as Boolean
}

fun Any.asString(): String {
  return this as String
}

fun Any.asInt(): Int {
  return this as Int
}

fun Any.asMap(): Map<String, Any> {
  return this as Map<String, Any>
}