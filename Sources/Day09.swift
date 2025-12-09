import Foundation

struct Day09: AdventDay {
  var data: String

  var cluster: [Point] {
    data.split(separator: "\n").map { line in
      let pointValues = line.split(separator: ",").compactMap { Int($0) }
      guard pointValues.count == 2 else {
        fatalError("Line cannot be parsed to point: \(line). Expected format: x,y")
      }
      return Point(pointValues[0], pointValues[1])
    }
  }

  func part1() -> Any {
    let cluster = self.cluster
    // var plot = preparePlot(points: cluster)
    //printPlot(plot)

    var pairsAndArea: [(pair: (Point, Point), area: Int)] = []
    for i: Int in 0..<cluster.count - 1 {
      for j in (i + 1)..<cluster.count {
        let p1 = cluster[i]
        let p2 = cluster[j]
        let squarXSide = abs(p1.x - p2.x) + 1
        let squarYSide = abs(p1.y - p2.y) + 1
        let area = Int(squarXSide * squarYSide)


        pairsAndArea.append(((p1, p2), area))
      }
    }

    pairsAndArea.sort(by: { $0.area > $1.area })
    print(pairsAndArea.map { String(Int($0.area)) })
    let pairWithBiggestArea = pairsAndArea.first!
    // drawSquar(furthestPair, plot: &plot)
    // printPlot(plot)

    print("\(pairWithBiggestArea.pair), area: \(pairWithBiggestArea.area)")
    return pairWithBiggestArea.area
  }

  func part2() -> Any {
    return -1
  }

  private func preparePlot(points: [Point]) -> [[String]] {
    var maxX = 0
    var maxY = 0
    for point in points {
      if maxX < point.x {
        maxX = point.x
      }
      if maxY < point.y {
        maxY = point.y
      }
    }

    let emptyRow = [String](repeating: ".", count: maxX + 1)
    var plot = [[String]].init(repeating: emptyRow, count: maxY + 1)
    points.forEach { plot[$0.y][$0.x] = "*" }

    return plot
  }

  private func printPlot(_ plot: [[String]]) {    
    print(plot.map { $0.joined()  }.joined(separator: "\n"))
  }

  private func drawSquar(_ pair: (Point, Point), plot: inout [[String]]) {
    for i in min(pair.0.y, pair.1.y)..<max(pair.0.y, pair.1.y) {
      for j in min(pair.0.x, pair.1.x)..<max(pair.0.x, pair.1.x) {
        plot[i][j] = "?"
      }
    }
  }
}