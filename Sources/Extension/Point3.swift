import Foundation

public struct Point3: Hashable, Sendable {
    public let x: Int
    public let y: Int
    public let z: Int

    public static let zero = Point3(0, 0, 0)

    @inlinable
    public init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    @inlinable
    public static func + (_ lhs: Point3, _ rhs: Point3) -> Point3 {
        Point3(
            lhs.x + rhs.x,
            lhs.y + rhs.y,
            lhs.z + rhs.z
        )
    }

    @inlinable
    public static func += (_ lhs: inout Point3, _ rhs: Point3) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func - (_ lhs: Point3, _ rhs: Point3) -> Point3 {
        Point3(
            lhs.x - rhs.x,
            lhs.y - rhs.y,
            lhs.z - rhs.z
        )
    }

    @inlinable
    public static func -= (_ lhs: inout Point3, _ rhs: Point3) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func * (_ lhs: Point3, _ rhs: Int) -> Point3 {
        Point3(
            lhs.x * rhs,
            lhs.y * rhs,
            lhs.z * rhs
        )
    }

    @inlinable
    public func distance(to point: Point3) -> Double {
        (
            pow(Double(x - point.x), 2) +
            pow(Double(y - point.y), 2) + 
            pow(Double(z - point.z), 2)
        ).squareRoot()
    }
}

extension Point3: CustomStringConvertible {
    public var description: String {
        "x: \(x)\ny: \(y)\nz: \(z)"
    }
}