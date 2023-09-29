- [ALTENLoggerConsole](#altenloggerconsole)
  - [Introducción](#introducción)
  - [Instalación](#instalación)
    - [Añadir al proyecto](#añadir-al-proyecto)
    - [Como dependencia en Package.swift](#como-dependencia-en-packageswift)
  - [Cómo se usa](#cómo-se-usa)
    - [Ejemplos de uso](#ejemplos-de-uso)

# ALTENLoggerConsole
- Changelog: https://github.com/SDOSLabs/ALTENLoggerConsole/blob/main/CHANGELOG.md

## Introducción
`ALTENLoggerConsole` es una librería que se apoya en la librería `Logging` proporcionada por Apple en el [siguiente enlace](https://github.com/apple/swift-log.git). La librería `Logging` permite la creación de `Loggers` para personalizar la salida de los logs.

## Instalación

### Añadir al proyecto

Abrir Xcode y e ir al apartado `File > Add Packages...`. En el cuadro de búsqueda introducir la url del respositorio y seleccionar la versión:
```
https://github.com/SDOSLabs/ALTENLoggerConsole.git
```

### Como dependencia en Package.swift

``` swift
dependencies: [
    .package(url: "https://github.com/SDOSLabs/ALTENLoggerConsole.git", .upToNextMajor(from: "2.0.0"))
]
```

``` swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "ALTENLoggerConsole", package: "ALTENLoggerConsole")
    ]),
```

## Cómo se usa

Para usar esta librería hay que seguir la documentación de la librería [`Logging`](https://github.com/apple/swift-log.git). Esta librería se usará como parte de su configuración.

De forma recomendada se puede añadir un fichero al proyecto con la siguiente implementación:

``` swift
//Fichero LoggerManager.swift

import Foundation
import Logging
import ALTENLoggerConsole

public let logger: Logger = {
    var logger = Logger(label: Bundle.main.bundleIdentifier ?? "AppLogger") {
        MultiplexLogHandler([
            ALTENConsoleLogHandler.standard(label: $0)
        ])
    }
    logger.logLevel = .trace
    return logger
}()
```
De esta forma tendremos disponible en todo el proyecto la variable `logger` que se usará para realizar los logs deseados.

---

Una vez realizada la configuración de `logger` se podrá usar en cualquier parte del proyecto.

### Ejemplos de uso

``` swift
public func loadData() async {
    logger.info("Start", metadata: nil)
    defer { logger.info("End", metadata: nil) }
    //Logic here
}
```
Salida por consola
```
🟦 2023-09-29 10:47:37.7970 [INFO com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:88] : Start
🟦 2023-09-29 10:47:37.7970 [INFO com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:89] : End
```
---
``` swift
public func search(searchTerm: String) async throws -> [FilmBO] {
    logger.debug("Start", metadata: ["searchTerm": "\(searchTerm)"])
    defer { logger.debug("End", metadata: ["searchTerm": "\(searchTerm)"]) }
    //Logic here
}
```
Salida por consola
```
🟩 2023-09-29 10:47:37.7970 [DEBUG com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:100] : Start - [searchTerm: "Avengers"]
🟩 2023-09-29 10:47:37.7970 [DEBUG com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:101] : End - [searchTerm: "Avengers"]
```
---
``` swift
public func save(text: String) {
    do {
        //Logic here
        logger.info("Save success", metadata: nil)
    } catch {
        logger.error("Error on save", metadata: ["error": "\(error.localizedDescription)"])
    }
}
```
Salida por consola
```
🟦 2023-09-29 10:47:37.7970 [INFO com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:132] : Save success
🟥 2023-09-29 10:47:37.7970 [ERROR com.your_bundle] [ListFilmViewModel.swift ➝ loadData() ➝ L:134] : Error on save
```
---

