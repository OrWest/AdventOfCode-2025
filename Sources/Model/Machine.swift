import Foundation

class Machine {
    var indicators: Int = 0
    let indicatorSize: Int
    let indicatorGoal: Int
    let buttons: [[Int]]
    let joltages: [Int]

    /// Example: [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    init(line: String.SubSequence) {
        var indicatorSize = 0
        var indicatorGoal = 0
        var buttons: [[Int]] = []
        var joltages: [Int] = []
        for element in line.split(separator: " ") {
            switch element.first {
                case "[": // Indicator
                    indicatorSize = element.count - 2
                    indicatorGoal = element
                        .dropFirst()
                        .dropLast()
                        .reversed()
                        .enumerated()
                        .reduce(0) { result, enumerator in
                            guard enumerator.element == "#" else { return result }
                            return result + 1 << enumerator.offset
                         }

                case "(":
                    buttons.append(element
                        .dropFirst()
                        .dropLast()
                        .split(separator: ",")
                        .map {
                            guard let int = Int($0) else {
                                fatalError("Cannot parse element to [Int]. \(element)")
                            }
                            return int
                        }
                    )

                case "{":
                    joltages = element
                        .dropFirst()
                        .dropLast()
                        .split(separator: ",")
                        .map {
                            guard let int = Int($0) else {
                                fatalError("Cannot parse element to [Int]. \(element)")
                            }
                            return int
                        }
                default:
                    fatalError("Unexpected element: \(element)")
            }
        }

        guard !buttons.isEmpty, indicatorSize > 0, !joltages.isEmpty else {
            fatalError("Some part of Machine is missed!")
        }

        self.buttons = buttons
        self.indicatorGoal = indicatorGoal
        self.indicatorSize = indicatorSize
        self.joltages = joltages
    }
}