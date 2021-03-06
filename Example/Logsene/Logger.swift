import Foundation
import Logsene
import CocoaLumberjack

/**
    Logsene logger for CocoaLumberjack.
*/
class LogseneLogger: DDAbstractLogger {
    override func logMessage(logMessage: DDLogMessage!) {
        var message = logMessage.message

        // See https://github.com/CocoaLumberjack/CocoaLumberjack/issues/643
        let ivar = class_getInstanceVariable(object_getClass(self), "_logFormatter")
        if let formatter = object_getIvar(self, ivar) as? DDLogFormatter {
            message = formatter.formatLogMessage(logMessage)
        }

        LLogEvent([
            "@timestamp": logMessage.timestamp.logseneTimestamp(),
            "level": LogseneLogger.formatLogLevel(logMessage.flag),
            "fileName": logMessage.fileName,
            "line": logMessage.line,
            "message": message,
            "threadID": logMessage.threadID,
            "threadName": logMessage.threadName
        ])
    }

    private class func formatLogLevel(level: DDLogFlag) -> String {
        switch level {
        case DDLogFlag.Debug:
            return "debug"
        case DDLogFlag.Error:
            return "error"
        case DDLogFlag.Info:
            return "info"
        case DDLogFlag.Verbose:
            return "verbose"
        case DDLogFlag.Warning:
            return "warn"
        default:
            return "other"
        }
    }
}
