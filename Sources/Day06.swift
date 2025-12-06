import Foundation

struct Day06: AdventDay {
  var data: String

  var rows: [[String]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { $0.isEmpty ? nil : String($0) }
    }
  }

  var symbols: [[Character]] {
    data.split(separator: "\n").map {
      $0.map { $0 }
    }
  }

  func part1() -> Any {
    var result = 0
    let rows = Array(self.rows.reversed())
    for j in 0..<rows[0].count {
      let sumOp = rows[0][j] == "+"
      var columnResult = sumOp ? 0 : 1
      for column: ReversedCollection<[[String]]>.Element in rows.dropFirst() {
        guard let value = Int(column[j]) else {
          print("Cannot parse to Int: \(column[j])")
          continue
        }
        if sumOp {
          columnResult += value
        } else {
          columnResult *= value
        }
      }
      result += columnResult
    }
    return result
  }


  func part2() -> Any {
    var result = 0
    var currentOperation: Character = .init(" ")
    var operatorElements: [Int] = []
    for j in 0..<self.symbols[0].count {
      let operatorSymbol = symbols.last![j]
      if operatorSymbol != " " {
        if currentOperation == "+" {
          result += operatorElements.reduce(0, +)
        } else if currentOperation == "*" {
          result += operatorElements.reduce(1, *)
        }
        operatorElements.removeAll()
        currentOperation = operatorSymbol 
      }

      var elementSymbolValues: [Int] = []
      for i in 0..<self.symbols.count - 1 { // rows count without last "operator" line
        let symbol = symbols[i][j]
        guard symbol.isNumber, let number = Int(String(symbol)) else { continue }
        elementSymbolValues.insert(number, at: 0)
      }

      let value = elementSymbolValues.enumerated().reduce(0, { 
        $0 + $1.element * Int(pow(10.0, Double($1.offset)))
      })
      if value > 0 {
        operatorElements.append(value)
      }
    }

    if currentOperation == "+" {
      result += operatorElements.reduce(0, +)
    } else if currentOperation == "*" {
      result += operatorElements.reduce(1, *)
    }
    return result
  }
}