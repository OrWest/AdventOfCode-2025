import Algorithms

struct Day04: AdventDay {

  struct RollsMap: CustomStringConvertible {
    static let emptyChar: Character = "."
    static let rollChar: Character = "@"
    static let removedChar: Character = "x"

    private(set) var matrix: [[Character?]]
    
    init(data: String) {
      matrix = data.split(separator: "\n").map {
        $0.map { $0 == Self.emptyChar ? nil : $0 }
      }
    }

    func aroundChars(x: Int, y: Int, padding: Int = 1) -> [Character] {
      var chars: [Character] = []

      let yRange = max(0, y - padding)...min(y + padding, matrix.count - 1)
      for i in yRange {
        let row = matrix[i]
        let xRange = max(0, x - padding)...min(x + padding, row.count - 1)
        for j in xRange {
          let char = row[j]
          guard (x, y) != (j, i), let value = char else { continue }
          chars.append(value)
        }
      }

      return chars
    }

    mutating func update(x: Int, y: Int, value: Character?) {
      matrix[y][x] = value
    }

    mutating func removeAll(value: Character) -> Int { 
      var removedCount = 0
      for (i, row) in matrix.enumerated() {
        for (j, char) in row.enumerated() {
          if char == value {
            matrix[i][j] = nil
            removedCount += 1
          }
        }
      }

      return removedCount
    }

    var description: String {
      var value = ""
      for row in matrix {
        for char in row {
          value.append(char ?? Self.emptyChar)
        }
        value += "\n"
      }

      return value
    }
  }

  var data: String

  func part1() -> Any {
    var eligibleRollToPickCount = 0
    var map = RollsMap(data: data)
    for (i, row) in map.matrix.enumerated() {
      for (j, char) in row.enumerated() {
        guard let _ = char else { continue }

        let aroundChars = map.aroundChars(x: j, y: i)
        if aroundChars.count < 4 {
          eligibleRollToPickCount += 1
          map.update(x: j, y: i, value: RollsMap.removedChar)
        }
      }
    }

    return eligibleRollToPickCount
  }

  func part2() -> Any {
    var pickedUpRollsCount = 0
    
    var map = RollsMap(data: data)
    repeat {
      for (i, row) in map.matrix.enumerated() {
        for (j, char) in row.enumerated() {
          guard let value = char, value == RollsMap.rollChar else { continue }

          let aroundChars = map.aroundChars(x: j, y: i)
          if aroundChars.count < 4 {
            pickedUpRollsCount += 1
            map.update(x: j, y: i, value: RollsMap.removedChar)
          }
        }
      }

    } while map.removeAll(value: RollsMap.removedChar) > 0

    return pickedUpRollsCount
  }
}