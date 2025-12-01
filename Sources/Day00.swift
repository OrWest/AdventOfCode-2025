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

    /// Convert L10 into 10 to left
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

  func part1() -> Int {
    var zeroStopCount = 0
    var dialValue = 50
    for move in dialMoves {
      let distance = move.distance
      let diraction = move.diraction
      // print("Move dial to \(diraction) to \(distance)")
      // print("\(dialValue) \(diraction == .left ? "-" : "+") \(distance)", terminator: "")
      switch diraction {
        case .right:
          dialValue += distance
        case .left:
          dialValue -= distance
      }
      // print(" = \(dialValue)", terminator: "")
      if dialValue > 99 {
        dialValue = dialValue % 100
      } else if dialValue < -99 {
        dialValue = dialValue % 100
      }
      if dialValue < 0 {
        dialValue += 100
      }
      // print("(\(dialValue))")

      if dialValue == 0 {
        zeroStopCount += 1
      }
    }

    return zeroStopCount
  }

  func part2() -> Int {
    return -1
  }
}
