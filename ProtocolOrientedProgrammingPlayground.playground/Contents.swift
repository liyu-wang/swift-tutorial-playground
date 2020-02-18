import Foundation

// Hatching the Egg

protocol Bird {
    var name: String { get }
    var canFly: Bool { get }
}

protocol Flyable {
    var airSpeedVelocity: Double { get }
}

// Defining Protocol-Conforming Types

struct FlappyBird: Bird, Flyable {
    let name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double

    var airSpeedVelocity: Double {
        3 * flappyFrequency * flappyAmplitude
    }
}

struct Penguin: Bird {
    let name: String
}

struct SwiftBird: Bird, Flyable {
    var name: String { "Swift \(version)" }
    let version: Double
    private var speedFactor = 1000.0

    init(version: Double) {
        self.version = version
    }

    // Swift is FASTER with each version!
    var airSpeedVelocity: Double {
        version * speedFactor
    }
}

// Extending Protocols With Default Implementations

extension Bird {
    // Flyable birds can fly!
    var canFly: Bool { self is Flyable }
}

// Enums Can Play, Too

enum UnladenSwallow: Bird, Flyable {
    case african
    case european
    case unknown

    var name: String {
        switch self {
        case .african:
            return "African"
        case .european:
            return "European"
        case .unknown:
            return "What do you mean? African or European?"
        }
    }

    var airSpeedVelocity: Double {
        switch self {
        case .african:
            return 10
        case .european:
            return 9.9
        case .unknown:
            fatalError("You are thrown from the bridge of death!")
        }
    }
}

// Overriding Default Behavior

extension UnladenSwallow {
    var canFly: Bool {
        self != .unknown
    }
}

UnladenSwallow.unknown.canFly         // false
UnladenSwallow.african.canFly         // true
Penguin(name: "King Penguin").canFly  // false
