import XCTest
import Logging
@testable import ALTENLoggerConsole

final class ALTENLoggerTests: XCTestCase {
    
    public private(set) var logger: Logging.Logger = ALTENLoggerTests.createLogger()
    
    fileprivate static func createLogger() -> Logging.Logger {
        var logger = Logging.Logger(label: Bundle.main.bundleIdentifier ?? "AppLogger") {
            return MultiplexLogHandler([
                ALTENConsoleLogHandler.standard(label: $0)
            ])
        }
        logger.logLevel = .trace
        return logger
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print("Hola")
        logger.trace("Esto es un trace")
        logger.debug("Esto es un debug")
        logger.info("Esto es un info")
        logger.notice("Esto es un debug")
        logger.warning("Esto es un warning")
        logger.error("Esto es un error")
        logger.critical("Esto es un critical")
    }
}
