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
    
    public static func standard(label: String, category: String = "General") -> ALTENConsoleLogHandler {
        return ALTENConsoleLogHandler(label: label, category: category)
    }
    
    private let label: String
    
    private let dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "y-MM-dd HH:mm:ss.SSSS"
        return dateFormat
    }()
    
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
    internal init(label: String, category: String) {
        self.label = label
        self.logger = Logger(subsystem: label, category: category)
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
        
        let result = "\(self.timestamp()) [\(level.rawValue.uppercased()) \(self.label)] [\(file.split(separator: "/").last ?? "\(file)") ➝ \(function) ➝ L:\(line)] : \(message)\(prettyMetadata.map { " - [\($0)]" } ?? "")"
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
        dateFormat.string(from: Date())
    }
}

