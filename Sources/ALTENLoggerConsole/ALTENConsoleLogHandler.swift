//
//  ALTENConsoleLogHandler.swift
//
//  Copyright © 2022 ALTEN. All rights reserved.
//

import Foundation
import Logging
import ALTENLoggerCore
import OSLog

/// Logger que devuelve la salida por consola
public struct ALTENConsoleLogHandler: LogHandler {
    
    public static func standard(label: String) -> ALTENConsoleLogHandler {
        return ALTENConsoleLogHandler(label: label)
    }
    
    private let label: String
    
    /// Nivel de log a partir del cual mostrará la información
    public var logLevel: Logging.Logger.Level = .info

    private var prettyMetadata: String?
    private var logger: os.Logger
    
    /// Metadatos globales del log que se incluirán en cada llamada al log
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    // internal for testing only
    internal init(label: String) {
        self.label = label
        self.logger = Logger(subsystem: label, category: "General")
    }

    public func log(level: Logging.Logger.Level,
                    message: Logging.Logger.Message,
                    metadata: Logging.Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        
        let result = "[\(level.rawValue.uppercased()) \(self.label)] [\(file.split(separator: "/").last ?? "\(file)") ➝ \(function) ➝ L:\(line)] : \(message)\(prettyMetadata.map { " - [\($0)]" } ?? "")"
        
        switch level {
        case .trace:
            logger.trace("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .debug:
            logger.debug("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .info:
            logger.info("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .notice:
            logger.notice("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .warning:
            logger.warning("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .error:
            logger.error("\(level.color, privacy: .public) \(result, privacy: .public)")
        case .critical:
            logger.critical("\(level.color, privacy: .public) \(result, privacy: .public)")
        }
    }

    private func prettify(_ metadata: Logging.Logger.Metadata) -> String? {
        return !metadata.isEmpty
            ? metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0): \"\($1)\"" }.joined(separator: " ")
            : nil
    }

    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}

