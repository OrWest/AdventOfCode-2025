import Algorithms

struct Day00: AdventDay {
  struct DialMovement {
    enum Diraction: String {
      case left
      case right

      init?(symbol: Substring) {
        switch symbol {
        case "L":
          self = .left
        case "R":
          self = .right
        default:
          return nil
        }
      }
    }

    let diraction: Diraction
    let distance: Int

    /// Convert L10 into "10 to left"
    init?(value: Substring) {
      guard value.count > 1 else { 
        return nil 
      }
      let diractionValue = value.prefix(1)
      let distanceValue = value.dropFirst(1)

      guard let diraction = Diraction(symbol: diractionValue), let distance = Int(distanceValue) else {
        return nil
      }
      self.diraction = diraction
      self.distance = distance
    }
  }

  struct MovementReport {
    let previousValue: Int
    let newValue: Int
    let newValueRaw: Int
  }

  // Input file content
  var data: String

  // Splits input data into its component parts and convert from string.
  var dialMoves: [DialMovement] {
    data.split(separator: "\n").compactMap { 
      let value = DialMovement.init(value: $0)
      if value == nil { print($0 + " value was not parsed")}
      return value
      } 
  }

  private func move(_ movement: DialMovement, dialValue: Int) -> MovementReport {
    let oldValue = dialValue
    var rawValue = dialValue
    switch movement.diraction {
        case .right:
          rawValue += movement.distance
        case .left:
          rawValue -= movement.distance
      }


    var newValue = rawValue
    if newValue > 99 {
      newValue = newValue % 100
    } else if newValue < -99 {
      newValue = newValue % 100
    }
    if newValue < 0 {
      newValue += 100
    }
    // print("Move dial to \(movement.diraction) to \(movement.distance)")
    // print("\(dialValue) \(movement.diraction == .left ? "-" : "+") \(movement.distance) = \(rawValue)(\(newValue))")

    return .init(previousValue: oldValue, newValue: newValue, newValueRaw: rawValue)
  }

  func part1() -> Int {
    var zeroStopCount = 0
    var dialValue = 50
    for movement in dialMoves {
      let report = move(movement, dialValue: dialValue)

      dialValue = report.newValue

      if dialValue == 0 {
        zeroStopCount += 1
      }
    }

    return zeroStopCount
  }

  func part2() -> Int {
    var zeroStopCount = 0
    var dialValue = 50
    for movement in dialMoves {
      let report = move(movement, dialValue: dialValue)

      dialValue = report.newValue
      zeroStopCount += abs(report.newValueRaw) / 100 // Crossed zero multiple times in one diraction
      zeroStopCount += report.newValueRaw == 0 ? 1 : 0 // Stay on zero
      zeroStopCount += report.newValueRaw * report.previousValue < 0 ? 1 : 0 // Crossed zero
    }

    return zeroStopCount
  }
}
