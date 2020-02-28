// https://www.raywenderlich.com/6742901-protocol-oriented-programming-tutorial-in-swift-5-1-getting-started

import Foundation

// Hatching the Egg

protocol Bird: CustomStringConvertible {
    var name: String { get }
    var canFly: Bool { get }
}

extension CustomStringConvertible where Self: Bird {
    var description: String {
        canFly ? "I can fly" : "Guess I'll just sit here :["
    }
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

// Extending Protocols

// CustomStringConvertible protocol confirmation is added to Bird
UnladenSwallow.african

// Effects on the Swift Standard Library

let numbers = [10, 20, 30, 40, 50, 60]
let slice = numbers[1...3]
let reversedSlice = slice.reversed()

let answer = reversedSlice.map { $0 * 10 }
print(answer)

// Off To the Races

class Motorcycle {
    var name: String
    var speed: Double

    init(name: String) {
        self.name = name
        speed = 200.0
    }
}

// Bringing it all together

// To unify these disparate types, you need a common protocol for racing. You can manage this without even touching the original model definitions thanks to a fancy idea called retroactive modeling.

protocol Racer {
    var speed: Double { get }
}

extension FlappyBird: Racer {
    var speed: Double {
        airSpeedVelocity
    }
}

extension SwiftBird: Racer {
    var speed: Double {
        airSpeedVelocity
    }
}

extension Penguin: Racer {
    var speed: Double {
        42
    }
}

extension UnladenSwallow: Racer {
    var speed: Double {
        canFly ? airSpeedVelocity : 0.0
    }
}

extension Motorcycle: Racer {}

let racers: [Racer] =
[UnladenSwallow.african,
 UnladenSwallow.european,
 UnladenSwallow.unknown,
 Penguin(name: "King Penguin"),
 SwiftBird(version: 5.1),
 FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
 Motorcycle(name: "Giacomo")]

// Top Speed

func topSpeed0(of racers: [Racer]) -> Double {
    racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed0(of: racers)

// Making it more generic

func topSpeed<RacersType: Sequence>(of racers: RacersType) -> Double
    where RacersType.Iterator.Element == Racer {
        racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed(of: racers[1...3])

// Making it more swifty

extension Sequence where Iterator.Element == Racer {
    func topSpeed() -> Double {
        self.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
    }
}
racers.topSpeed()
racers[1...3].topSpeed()

// Protocol Comparators

protocol Score: Comparable {
    var value: Int { get }
}

struct RacingScore: Score {
    let value: Int

    static func <(lhs: RacingScore, rhs: RacingScore) -> Bool {
        lhs.value < rhs.value
    }
}

RacingScore(value: 150) >= RacingScore(value: 130)

// Mutating Functions

protocol Cheat {
    mutating func boost(_ power: Double)
}

extension SwiftBird: Cheat {
    mutating func boost(_ power: Double) {
        speedFactor += power
    }
}

var swiftBird = SwiftBird(version: 5.0)
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5015
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5030
