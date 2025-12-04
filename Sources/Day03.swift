import Foundation

struct Day03: AdventDay {
  struct Bank: CustomStringConvertible {
    let joltages: [UInt8]

    var description: String {
      joltages.reduce("") { $0 + String($1) }
    }
  }

  var data: String

  var banks: [Bank] {
    data.split(separator: "\n").map { line in
      let joltages = line.compactMap { numberString -> UInt8? in
        guard let number = UInt8(String(numberString)) else {
          print("Cannot parse \(numberString) in \"\(line)\"")
          return nil
        } 
        return number
      }
      return Bank(joltages: joltages)
    }
  }

  func part1() -> UInt64 {
    var outputJoltage: UInt64 = 0
    for bank in banks {
        outputJoltage += findBiggest(from: bank.joltages, size: 2)
    }
    return outputJoltage
  }

  func part2() -> UInt64 {
    var outputJoltage: UInt64 = 0
    for bank in banks {
        outputJoltage += findBiggest(from: bank.joltages, size: 12)
    }
    return outputJoltage
  }

  private func findBiggest(from numbers: [UInt8], size: Int) -> UInt64 {
    var biggestValue: UInt64 = 0
    var nextFirstIndex = 0
    for i in 0..<size {
      let range = nextFirstIndex...(numbers.count - size + i)
      let maxValueIndex = findMaxIndex(numbers: numbers[range].enumerated()) + nextFirstIndex
      let maxValue = numbers[maxValueIndex]
      guard maxValue > 0 else {
        print("\(numbers): Cannot find maxValue")
        break
      }

      biggestValue += UInt64(maxValue) * UInt64(pow(Double(10), Double(size - i - 1)))
      nextFirstIndex = maxValueIndex + 1
    }

    return biggestValue
  }

  private func findMaxIndex(numbers: EnumeratedSequence<ArraySlice<UInt8>>) -> Int {
    var maxValue: UInt8 = 0
    var maxIndex = 0
    for (index, number) in numbers {
      if number > maxValue {
        maxValue = number
        maxIndex = index
      }

      if number == 9 {
        break
      }
    }

    return maxIndex
  }
}