import Flutter
import UIKit

public class SwiftBatterySwiftPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "plugins.demo.io/battery",
            binaryMessenger: registrar.messenger())

        let instance = SwiftBatterySwiftPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let chargingChannel = FlutterEventChannel(
            name: "plugins.demo.io/charging",
            binaryMessenger: registrar.messenger())

        chargingChannel.setStreamHandler(instance)
    }

    // MARK: FlutterMethodChannel

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == "getBatteryLevel" else {
            result(FlutterMethodNotImplemented)
            return
        }

        let batteryLevel = getBatteryLevel()
        if batteryLevel == -1 {
            let error = FlutterError(
                code: "UNAVAILABLE",
                message: "Battery info unavailable",
                details: nil)
            result(error)
            return
        }

        result(batteryLevel)
    }

    private func getBatteryLevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if (device.batteryState == .unknown) {
            return -1
        } else {
            return Int(device.batteryLevel * 100)
        }
    }

    @objc
    private func onBatteryStateDidChange(notification: Notification) {
        sendBatteryStateEvent();
    }

    private func sendBatteryStateEvent() {
        if _eventSink == nil {
            return
        }
        let state = UIDevice.current.batteryState;
        switch (state) {
        case .full:
            _eventSink?("full")
        case .charging:
            _eventSink?("charging")
        case .unplugged:
            _eventSink?("discharging")
        default:
            let error = FlutterError(
                code: "UNAVAILABLE",
                message: "Charging state unavaiable",
                details: nil)
            _eventSink?(error)
        }
    }

    // MARK: FlutterStreamHandler

    private var _eventSink: FlutterEventSink? = nil

    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        _eventSink = events;
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onBatteryStateDidChange(notification:)),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
}

