import Algorithms

struct Day07: AdventDay {
  private enum Symbols: String {
    case start = "S"
    case splitter = "^"
    case empty = "."

    init?(character: Character) {
      self.init(rawValue: String(character))
    }
  }

  var data: String

  private var rounds: [[Symbols]] {
    data.split(separator: "\n").map {
      $0.compactMap {
        guard let symbol = Symbols(character: $0) else {
          fatalError("Cannot parse \($0)")
        }
        return symbol
      }
    }
  }

  func part1() -> Any {
    let rounds: [[Day07.Symbols]] = rounds
    var splitCount = 0
    var currentRound = 1
    var activeBeams: Set<Int> = [rounds.first!.firstIndex(of: .start)!]
    while currentRound < rounds.count {
      var newActiveBeams: Set<Int> = []
      for beamIndex in activeBeams {
        let thisRoundPlace = rounds[currentRound][beamIndex]
        switch thisRoundPlace {
        case .empty:
          newActiveBeams.insert(beamIndex)
        case .splitter:
          let leftSplitIndex = beamIndex - 1
          if leftSplitIndex >= 0 {
            newActiveBeams.insert(leftSplitIndex)
          }
          let rightSplitIndex = beamIndex + 1
          if rightSplitIndex < rounds[currentRound].count {
            newActiveBeams.insert(rightSplitIndex)
          }
          splitCount += 1
        default:
          continue  
        }
      }

      activeBeams = newActiveBeams
      currentRound += 1
    }
    
    return splitCount
  }

  func part2() -> Any {
    let rounds: [[Day07.Symbols]] = rounds
    var currentRound = 1
    var activeBeams: [Int: Int] = [rounds.first!.firstIndex(of: .start)! : 1] // position and value (to merge)
    while currentRound < rounds.count {
      var newActiveBeams: [Int: Int] = [:]
      for beamInfo in activeBeams {
        let thisRoundPlace = rounds[currentRound][beamInfo.key]
        switch thisRoundPlace {
        case .empty:
          insertOrAppend(key: beamInfo.key, value: beamInfo.value, dict: &newActiveBeams)
        case .splitter:
          insertOrAppend(key: beamInfo.key - 1, value: beamInfo.value, dict: &newActiveBeams)
          insertOrAppend(key: beamInfo.key + 1, value: beamInfo.value, dict: &newActiveBeams)
        default:
          continue  
        }
      }

      printRound(i: currentRound, activeBeams: newActiveBeams, round: rounds[currentRound], lineSize: rounds[currentRound].count)
      activeBeams = newActiveBeams
      currentRound += 1
    }
    
    return activeBeams.values.reduce(0, +)
  }

  private func insertOrAppend(key: Int, value: Int, dict: inout [Int: Int]) {
    if let existingValue = dict[key] {
      dict[key] = value + existingValue
    } else {
      dict[key] = value
    }
  }

  private func printRound(i: Int, activeBeams: [Int: Int], round: [Day07.Symbols], lineSize: Int) {
    var line = ""
    for i in 0..<lineSize {
      if round[i] == .splitter {
        line += Symbols.splitter.rawValue
      } else {
      line += activeBeams[i] == nil ? "." : "|"
      }
    }
    var sum = activeBeams.values.reduce(0, +)
    let s = String(format: "%3d %@ %lu", arguments: [i, line, sum])
    print(s)
  }
}