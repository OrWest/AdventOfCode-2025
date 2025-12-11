import Foundation

struct Day10: AdventDay {
  var data: String

// [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
// [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
// [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}

  func getMachines<T: BinaryInteger>() -> [Machine<T>] {
    data.split(separator: "\n").map {
      .init(line: $0)
    }
  }

  func part1() -> Any {
    let machines: [Machine<UInt16>] = getMachines()
    let fastestStepCounts: [Int] = machines.map { bruteforceFastestCombination(machine: $0) }    
    let sum = fastestStepCounts.reduce(0, +)
    return sum
  }

  func part2() -> Any {
    return -1
  }

  private func bruteforceFastestCombination<Binary: BinaryInteger>(machine: Machine<Binary>) -> Int {
    var successCombo: [[Binary]] = []
    for comboSize in 0..<machine.buttons.count {
      enumerateCombos(deep: comboSize, values: machine.buttons) { combo in
        let result = combo.reduce(0, ^)
        // print("\(result.binaryDescription) Combo: \(combo)")
        if result == machine.indicatorGoal {
          successCombo.append(combo)
          // print("Combo added!")
          //print("\(result.binaryDescription) Combo: \(combo)")
        }
      }
    }

    successCombo.sort { $0.count < $1.count }
    // print(successCombo)
    return successCombo.first?.count ?? 0
  }

  private func enumerateCombos<Binary>(deep: Int, values: [Binary], testBlock: ([Binary]) -> Void) {
    for (i, value) in values.enumerated() {
      if deep > 0 {
        enumerateCombos(deep: deep - 1, values: Array(values.dropFirst(i + 1))) { values in
          testBlock([value] + values)
        }
      } else {
        testBlock([value])
      }
    }
  }
}
