import Algorithms

struct Day05: AdventDay {
  var data: String

  var availableProductsIds: [Int] {
    data.split(separator: "\n\n")[1].split(separator: "\n").compactMap { Int($0) }
  }

  var freshProductIds: [ClosedRange<Int>] {
    data.split(separator: "\n\n")[0].split(separator: "\n").compactMap { rangeString -> ClosedRange<Int>? in
      let rangeIndexesString = rangeString.split(separator: "-")
      guard rangeIndexesString.count == 2, let first = Int(rangeIndexesString[0]), let second = Int(rangeIndexesString[1]) else {
        print("\(rangeString) doesn't have template: X-X")
        return nil
      }
      return first...second
     }
  }

  func part1() -> Any {
    var freshCount = 0
    let freshIds = freshProductIds
    for availableId in availableProductsIds {
      for freshRange in freshIds {
        if freshRange.contains(availableId) {
          freshCount += 1
          break
        }
      }
    }
    return freshCount
  }

  func part2() -> Any {
    var idsCount = 0
    var lastIncludedValue = 0
    let sortedRanges = freshProductIds.sorted { 
      $0.lowerBound < $1.lowerBound || ($0.lowerBound == $1.lowerBound && $0.upperBound > $1.upperBound)
    }
    for range in sortedRanges {
      if range.lowerBound > lastIncludedValue { // New range
        idsCount += range.count
      } else if range.upperBound <= lastIncludedValue { // Already handled range
        continue
      } else {
        idsCount += range.upperBound - lastIncludedValue
      }
      lastIncludedValue = range.upperBound
    }
    return idsCount
  }
}