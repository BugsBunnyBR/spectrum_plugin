import Flutter
import UIKit
import SpectrumKit

public class SwiftSpectrumPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "spectrum_plugin", binaryMessenger: registrar.messenger())
    let delegate = SpectrumDelegateImpl()
    let instance = SwiftSpectrumPlugin(delegate: delegate)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    let  delegate : SpectrumDelegate
    init(delegate : SpectrumDelegateImpl) {
        self.delegate = delegate
    }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "transcode" {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let tr = TranscodeRequest.build(data: arguments)
        let map = self.delegate.transcode(request: tr)
        result(map)
    } else {
        result(FlutterMethodNotImplemented)
    }
    
  }
}
public protocol SpectrumDelegate {
    func transcode(request: TranscodeRequest) -> Dictionary<String, Any>
}
public class SpectrumDelegateImpl: SpectrumDelegate {
    
    public func transcode(request: TranscodeRequest) -> Dictionary<String, Any> {
        let requirement = EncodeRequirement(format: request.format, mode: request.mode, quality: request.quality)
        let transformations = Transformations()
        
        transformations.resizeRequirement = request.resize?.toRequirement()
        transformations.rotateRequirement = request.rotate?.toRequirement()
        transformations.cropRequirement = request.crop?.toRequirement()
        
        let options = TranscodeOptions(encodeRequirement: requirement,
                                       transformations: transformations,
                                       metadata: nil,
                                       configuration: nil,
                                       outputPixelSpecificationRequirement: nil)
    
        let result = Spectrum.shared.transcodeImage(fromFileAt: request.source,
                                       toFileAt: request.sink,
                                       options: options,
                                       error: nil)
        
        return TranscodeResponse.build(r: result)
    }
}
public class TranscodeResponse{
    
    static func build(r: Result) -> Dictionary<String, Any>{
      var map = Dictionary<String, Any>()
        map["isSuccessful"] = r.didSucceed
        map["ruleName"] = r.ruleName
        map["totalBytesRead"] = r.totalBytesRead
        map["totalBytesWritten"] = r.totalBytesWritten
        map["outputImageSpecification"] = imageSpecificationAsDictionary(imgSpec: r.outputImageSpecification)
    
        return map
    }
    
    static func imageSpecificationAsDictionary(imgSpec: ImageSpecification?) -> Dictionary<String, Any>{
        if(imgSpec == nil){
            return Dictionary()
        }
        var map = Dictionary<String, Any>()
        map["format"] = imgSpec!.format.identifier.uppercased()
        map["chromaSamplingMode"] = chromaSamplingModeAsString(chroma: imgSpec!.chromaSamplingMode)
        map["orientation"] = imageOrientationAsString(orientation: imgSpec!.orientation)
        map["metadata"] = imgSpec!.metadata.dictionary
        map["size"] = sizeAsMap(size: imgSpec!.size)
        map["pixelSpecification"] = pixelSpecficationAsString(pixelSpec: imgSpec!.pixelSpecification)
        
        return map
    }
    static func pixelSpecficationAsString(pixelSpec: ImagePixelSpecification) -> String {
        if(pixelSpec == ImagePixelSpecification.rgb){
            return "RGB"
        }
        if(pixelSpec == ImagePixelSpecification.rgba){
            return "RGBA"
        }
        if(pixelSpec == ImagePixelSpecification.gray){
            return "GRAY"
        }
        if(pixelSpec == ImagePixelSpecification.grayA){
            return "GRAY_A"
        }
        if(pixelSpec == ImagePixelSpecification.aGray){
            return "A_GRAY"
        }
        if(pixelSpec == ImagePixelSpecification.argb){
            return "ARGB"
        }
        if(pixelSpec == ImagePixelSpecification.bgr){
            return "BGR"
        }
        if(pixelSpec == ImagePixelSpecification.bgra){
            return "BGRA"
        }
        if(pixelSpec == ImagePixelSpecification.abgr){
            return "ABGR"
        }
        return ""
    }
    static func sizeAsMap(size: CGSize) -> Dictionary<String, Any>{
        var map = Dictionary<String, Any>()
        map["width"] = size.width
        map["height"] = size.height
        return map
    }
    static func imageOrientationAsString(orientation: ImageOrientation)  -> String {
        switch orientation {
        case .up:
            return "UP"
        case .upMirrored:
            return "UP_MIRRORED"
        case .bottom:
            return "BOTTOM"
        case .bottomMirrored:
            return "BOTTOM_MIRRORED"
        case .left:
            return "LEFT"
        case .leftMirrored:
            return "LEFT_MIRRORED"
        case .right:
            return "RIGHT"
        case .rightMirrored:
            return "RIGHT_MIRRORED"
        }
    }
    static func chromaSamplingModeAsString(chroma: ImageChromaSamplingMode)-> String {
        switch  chroma{
        case .mode411:
            return "S411"
        case .mode420:
            return "S420"
        case .mode422:
            return "S422"
        case .mode440:
            return "S440"
        case .mode444:
            return "S444"
        case .modeNone:
            return "NONE"
        }
    }
}
public class ResizeRequest{
    let mode: ResizeRequirementMode
    let width, height : Int
    
    init(mode: ResizeRequirementMode, width: Int, height: Int) {
        self.mode = mode
        self.width = width
        self.height = height
    }
    func toRequirement() -> ResizeRequirement{
        return ResizeRequirement.init(mode: mode,
                                      targetSize: CGSize(width: width, height: height)
        )
    }
    static func findResizeRequirementMode(mode: String) -> ResizeRequirementMode {
        if("exactOrLarger".caseInsensitiveCompare(mode) == .orderedSame){
            return ResizeRequirementMode.exactOrLarger
        }
        if("exactOrSmaller".caseInsensitiveCompare(mode) == .orderedSame){
            return ResizeRequirementMode.exactOrSmaller
        }
        
        return ResizeRequirementMode.exact
    }
    static func build(data: Dictionary<String, AnyObject>) -> ResizeRequest? {
        let mode = data["mode"] as? String
        let height = data["height"] as? Int
        let width = data["width"] as? Int
        
        if(mode == nil || height == nil || width == nil){
            return nil
        }
        
        return ResizeRequest(
            mode: findResizeRequirementMode(mode : mode!),
                width: width!,
                height: height!)
    }
}

public class CropRequest {
    let left, top, right, bottom: Double
    let mustBeExact: Bool
    init(left: Double, top: Double, right: Double, bottom: Double, mustBeExact: Bool) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
        self.mustBeExact = mustBeExact
    }
    func toRequirement() -> RelativeToOriginCropRequirement {
        let values = RelativeToOriginCropRequirementValues.init(top: Float(top),
                                                                left: Float(left),
                                                                bottom: Float(bottom),
                                                                right: Float(right))

        let enforcement = mustBeExact ?
            CropRequirementEnforcement.mustBeExact :
            CropRequirementEnforcement.approximate
        return RelativeToOriginCropRequirement.init(values: values, enforcement: enforcement)
    }
    static func build(data: Dictionary<String, AnyObject>) -> CropRequest?{
        let left = data["left"] as? Double
        let top = data["top"] as? Double
        let right = data["right"] as? Double
        let bottom = data["bottom"] as? Double
        let mustBeExact = data["mustBeExact"] as? Bool
        
        if(left == nil || top == nil || right == nil || bottom == nil || mustBeExact == nil ){
            return nil
        }
        return CropRequest(
            left: left!,
            top: top!,
            right: right!,
            bottom: bottom!,
            mustBeExact: mustBeExact!
        )
    }
}
public class RotateRequest{
    let degrees: Int
    let flipVertically: Bool
    let flipHorizontally: Bool
    let forceUpOrientation: Bool
    init(degrees:Int, flipVertically: Bool, flipHorizontally: Bool, forceUpOrientation: Bool) {
        self.degrees = degrees
        self.flipVertically = flipVertically
        self.flipHorizontally = flipHorizontally
        self.forceUpOrientation = forceUpOrientation
    }
    func toRequirement() -> RotateRequirement {
        return RotateRequirement.init(degrees: degrees,
                                      shouldFlipHorizontally: flipHorizontally,
                                      shouldFlipVertically: flipVertically,
                                      shouldForceUpOrientation: forceUpOrientation )
    }
    static func build(data: Dictionary<String, AnyObject>) -> RotateRequest?{
        let degrees = data["degrees"] as? Int
        let flipVertically = data["flipVertically"] as? Bool
        let flipHorizontally = data["flipHorizontally"] as? Bool
        let forceUpOrientation = data["forceUpOrientation"] as? Bool
        
        if(degrees == nil || flipHorizontally == nil || flipHorizontally == nil || forceUpOrientation == nil){
            return nil
        }
        
        return RotateRequest(degrees: degrees!,
                                  flipVertically: flipVertically!,
                                  flipHorizontally: flipHorizontally!,
                                  forceUpOrientation: forceUpOrientation!)
    }
}
public class TranscodeRequest{
    let source, sink : URL
    let callerContext: String
    let format: EncodedImageFormat
    let mode: EncodeRequirementMode
    let quality: Int
    let resize: ResizeRequest?
    let crop: CropRequest?
    let rotate: RotateRequest?
    init(source: URL,
         sink: URL,
         callerContext: String,
         format: EncodedImageFormat,
         mode: EncodeRequirementMode,
         quality: Int,
         resize: ResizeRequest?,
         crop: CropRequest?,
         rotate: RotateRequest?) {
        self.source = source
        self.sink = sink
        self.callerContext = callerContext
        self.format = format
        self.mode = mode
        self.quality = quality
        self.resize = resize
        self.crop = crop
        self.rotate = rotate
    }
   
    static func build(data: Dictionary<String, AnyObject>) -> TranscodeRequest{
        let source = data["source"] as! String
        let sink = data["sink"] as! String
        let callerContext = data["callerContext"] as! String
        let format = data["format"] as! String
        let mode = data["mode"] as! String
        let quality = data["quality"] as! Int
        let resize = data["resize"] as! Dictionary<String, AnyObject>
        let crop = data["crop"] as! Dictionary<String, AnyObject>
        let rotate = data["rotate"] as! Dictionary<String, AnyObject>
        
        
        return TranscodeRequest(
            source: URL(fileURLWithPath: source),
            sink: URL(fileURLWithPath: sink),
            callerContext: callerContext,
            format: supportedFormats.first(where: {$0.identifier == format })!,
            mode :  findEncodeRequirementMode(mode: mode),
            quality: quality,
            resize: ResizeRequest.build(data: resize),
            crop: CropRequest.build(data: crop),
            rotate : RotateRequest.build(data: rotate)
        )
    }
    
    static let supportedFormats = [
        EncodedImageFormat.jpeg,
        EncodedImageFormat.png,
        EncodedImageFormat.webp,
    ]
    
    static func findEncodeRequirementMode(mode: String)  -> EncodeRequirementMode {
        if("any".caseInsensitiveCompare(mode) == .orderedSame){
            return EncodeRequirementMode.any
        }
        if("lossy".caseInsensitiveCompare(mode) == .orderedSame){
            return EncodeRequirementMode.lossy
        }
        
        return EncodeRequirementMode.lossless
    }
}
