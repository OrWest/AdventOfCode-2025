import Algorithms

struct Day10: AdventDay {
  var data: String

  var machines: [Machine] {
    data.split(separator: "\n").map {
      .init(line: $0)
    }
  }

  func part1() -> Any {
    let machines = machines
    return -1
  }

  func part2() -> Any {
    return -1
  }
}