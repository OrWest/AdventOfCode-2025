import Foundation

public struct Point: Hashable, Sendable {
    public let x: Int
    public let y: Int

    public static let zero = Point(0, 0)

    @inlinable
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    @inlinable
    public static func + (_ lhs: Point, _ rhs: Point) -> Point {
        Point(
            lhs.x + rhs.x,
            lhs.y + rhs.y
        )
    }

    @inlinable
    public static func += (_ lhs: inout Point, _ rhs: Point) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func - (_ lhs: Point, _ rhs: Point) -> Point {
        Point(
            lhs.x - rhs.x,
            lhs.y - rhs.y
        )
    }

    @inlinable
    public static func -= (_ lhs: inout Point, _ rhs: Point) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func * (_ lhs: Point, _ rhs: Int) -> Point {
        Point(
            lhs.x * rhs,
            lhs.y * rhs
        )
    }

    @inlinable
    public func distance(to point: Point) -> Double {
        (
            pow(Double(x - point.x), 2) +
            pow(Double(y - point.y), 2)
        ).squareRoot()
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        "(\(x),\(y))"
    }
}