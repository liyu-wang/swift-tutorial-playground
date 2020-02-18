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
    let canFly = true

    var airSpeedVelocity: Double {
        3 * flappyFrequency * flappyAmplitude
    }
}

struct Penguin: Bird {
    let name: String
    let canFly = false
}

struct SwiftBird: Bird, Flyable {
    var name: String { "Swift \(version)" }
    let canFly = true
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
