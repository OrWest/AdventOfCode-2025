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
    let machines: [Machine<Int>] = getMachines()
    let solutions = machines.enumerated().map { 
      print("Machine \($0.offset + 1)/\(machines.count)")
      return solveButtonPressCount(machine: $0.element) 
    }
    return solutions.reduce(0, +)
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

  private func solveButtonPressCount(machine: Machine<Int>) -> Int {
    let process = Process()

    process.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
    process.arguments = ["Sources/python/day10_solve_z3.py"]

    process.environment = [
        "Z3_LIBRARY_PATH": "full/path/to/dir/with/libz3.dylib"
    ]

    let inputPipe = Pipe()
    let outputPipe = Pipe()
    process.standardInput = inputPipe
    process.standardOutput = outputPipe
    process.standardError = outputPipe

    var input = ""
    for button in machine.joltageButtons {
        input += button.sorted().map(String.init).joined(separator: ",") + "\n"
    }
    input += "---\n"
    input += machine.joltages.map(String.init).joined(separator: ",") + "\n"

    inputPipe.fileHandleForWriting.write(input.data(using: .utf8)!)
    inputPipe.fileHandleForWriting.closeFile()

    do {
        try process.run()
    } catch {
        print("Error python:", error)
        return -1
    }

    process.waitUntilExit()

    let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

    print("Python output:", output)

    return Int(output) ?? -1
  }
}
