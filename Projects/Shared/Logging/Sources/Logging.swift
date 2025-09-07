import Foundation

// MARK: - LogLevel

public enum LogLevel: Int, CaseIterable, Comparable {
    /// Very detailed execution information for debugging complex issues during development
    case verbose = 0
    /// General debugging information for developers
    case debug = 1
    /// Important events and state changes for operational monitoring
    case info = 2
    /// Potential issues and exceptional situations that require monitoring
    case warning = 3
    /// Actual errors and failures that require immediate attention
    case error = 4
    
    public var name: String {
        switch self {
        case .verbose:
            return "VERBOSE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
    
    public var emoji: String {
        switch self {
        case .verbose:
            return "💬"
        case .debug:
            return "👾"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Logger Protocol

protocol Logger {
    func log(
        level: LogLevel,
        message: String,
        file: String,
        function: String,
        line: Int
    )
}

// MARK: - DebugLogger

final class DebugLogger: Logger {
    private let queue = DispatchQueue(label: "logging.debug.queue", qos: .utility)
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.current
    }
    
    public func log(
        level: LogLevel,
        message: String,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let timestamp = self.dateFormatter.string(from: Date())
            let fileName = URL(fileURLWithPath: file).lastPathComponent
            
            let logMessage = """
            [\(timestamp)] \(level.emoji) \(level.name) \(fileName):\(line) \(function)
            : \(message)
            """
            
            print(logMessage)
        }
        #endif
    }
}

// MARK: - Log Main Class

public final class Log {
    public static let shared = Log()
    
    private let logger: Logger
    
    private init() {
        self.logger = DebugLogger()
    }
    
    // MARK: - Global Logging Methods
    
    public static func welcome() {
        
    }
    
    public static func verbose(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.logger.log(
            level: .verbose,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.logger.log(
            level: .debug,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.logger.log(
            level: .info,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.logger.log(
            level: .warning,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
    
    public static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.logger.log(
            level: .error,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
}
