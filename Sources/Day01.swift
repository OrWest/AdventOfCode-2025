import Algorithms

struct Day01: AdventDay {
  // Input file content
  var data: String

  // Splits input data into its component parts and convert from string.
  var idRanges: [ClosedRange<UInt>] {
    data.split(separator: ",").compactMap { rangeIds -> ClosedRange<UInt>? in
        let startAndEndIds = rangeIds.split(separator: "-")
        guard startAndEndIds.count == 2, 
            let startIdString = startAndEndIds.first,
            let startId = UInt(String(startIdString)),
            let endIdString = startAndEndIds.last,
            let endId = UInt(String(endIdString)) 
        else { 
            print("Wrong range template: \(rangeIds)")
            return nil
        }
        return startId...endId
      } 
  }

  func part1() -> UInt {
    var invalidIds: [UInt] = []

    let ranges = idRanges
    for range in ranges {
      for id in range {
        let idString = String(id)
        guard idString.count % 2 == 0 else {
          // Cannot split by half - valid id. So skipping
          continue
        }
        let partSize = idString.count / 2
        let leftPart = idString.prefix(partSize)
        let rightPart = idString.suffix(partSize)

        if leftPart == rightPart {
          invalidIds.append(id)
        }
      }
    }
    return invalidIds.reduce(0, { $0 + $1 })
  }

  func part2() -> UInt {
    var invalidIds: [UInt] = []

    for range in idRanges {
      for id in range {
        let idString = String(id)
        let allDeviders = 2...max(idString.count, 2)
        let possibleDeviders = allDeviders.filter { idString.count % $0 == 0 }

        for devider in possibleDeviders {
          let chunks = idString.evenlyChunked(in: devider)
          guard chunks.count > 1, let first = chunks.first else { continue }

          var allEqual = true
          for chunk in chunks.dropFirst() {
            if first != chunk {
              allEqual = false
              break
            }
          }

          if allEqual {
            // print("\(id) invalid. \(first) repeated")
            invalidIds.append(id)
            break
          }
        }
      }
    }
    return invalidIds.reduce(0, { $0 + $1 })
  }
}
