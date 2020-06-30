import Flutter
import UIKit

public class SwiftPluginObjcSwiftPlugin: NSObject, FlutterPlugin, FLTHelloApi {
  public func initialize(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
    // noop
  }

  public func hello(_ input: FLTHelloMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
    // noop
  }

  public func helloAndReply(_ input: FLTHelloMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTReplyMessage? {
    let msg = FLTReplyMessage()
    msg.reply = "Hello World!"
    return msg
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftPluginObjcSwiftPlugin()
    FLTHelloApiSetup(registrar.messenger(), instance)
  }
}

