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
    // printPlot(plot)

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
    // print(pairsAndArea.map { String(Int($0.area)) })
    let pairWithBiggestArea = pairsAndArea.first!
    // drawSquar(pairWithBiggestArea.pair, plot: &plot)
    // printPlot(plot)

    print("\(pairWithBiggestArea.pair), area: \(pairWithBiggestArea.area)")
    return pairWithBiggestArea.area
  }

  func part2() -> Any {
    let cluster = self.cluster
    var plot = preparePlot(points: cluster)
    // printPlot(plot)

    var pairsAndArea: [(pair: (Point, Point), area: Int)] = []
    for i: Int in 0..<cluster.count - 1 {
      for j in (i + 1)..<cluster.count {
        let p1 = cluster[i]
        let p2 = cluster[j]

        let pair = (p1, p2)
        guard !isLine(pair: pair), rectInsidePoligon(rectPoints: pair, poligonPoints: cluster) else { continue }

        let squarXSide = abs(p1.x - p2.x) + 1
        let squarYSide = abs(p1.y - p2.y) + 1
        let area = Int(squarXSide * squarYSide)

        pairsAndArea.append(((p1, p2), area))
      }
    }

    pairsAndArea.sort(by: { $0.area > $1.area })
    print(pairsAndArea.prefix(10).map { String(Int($0.area)) })
    let pairWithBiggestArea = pairsAndArea.first!
    drawSquar(pairWithBiggestArea.pair, plot: &plot)
    printPlot(plot)

    return pairWithBiggestArea.area
  }

  private func isLine(pair: (Point, Point)) -> Bool {
    pair.0.x == pair.1.x || pair.0.y == pair.1.y
  }

  private func rectInsidePoligon(rectPoints: (Point, Point), poligonPoints: [Point]) -> Bool {
    let lowerPoint = Point(min(rectPoints.0.x, rectPoints.1.x), min(rectPoints.0.y, rectPoints.1.y))
    let upperPoint = Point(max(rectPoints.0.x, rectPoints.1.x), max(rectPoints.0.y, rectPoints.1.y))

    let xRangeNoBorders = (lowerPoint.x + 1)..<upperPoint.x
    let yRangeNoBorders = (lowerPoint.y + 1)..<upperPoint.y

    guard !poligonPoints.contains(where: { point in
      xRangeNoBorders ~= point.x && yRangeNoBorders ~= point.y
    }) else { 
      return false 
    }

    let xRange = lowerPoint.x...upperPoint.x
    let yRange = lowerPoint.y...upperPoint.y
    let pointsCount = poligonPoints.count
    for i in 0..<pointsCount {
      let lineP1 = poligonPoints[i]
      let lineP2 = poligonPoints[(i + 1) % pointsCount]

      let isHorizontal = lineP1.y == lineP2.y

      if isHorizontal {
        guard yRangeNoBorders ~= lineP1.y else { continue }
        switch (lineP1.x, lineP2.x) {
          case (...xRange.lowerBound, ...xRange.lowerBound): // Was left and not crossed shape
            continue
          case (xRange.upperBound..., xRange.upperBound...): // Was right and not crossed shape
            continue
          default:
            return false // Crossed shape
        }
      } else {
        guard xRangeNoBorders ~= lineP1.x else { continue }
        switch (lineP1.y, lineP2.y) {
          case (...yRange.lowerBound, ...yRange.lowerBound): // Was top and not crossed shape
            continue
          case (yRange.upperBound..., yRange.upperBound...): // Was bottom and not crossed shape
            continue
          default:
            return false // Crossed shape
        }
      }
    }

    return true
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

    let emptyRow = [String](repeating: ".", count: maxX + 3)
    var plot = [[String]].init(repeating: emptyRow, count: maxY + 3)
    points.forEach { plot[$0.y][$0.x] = "*" }

    return plot
  }

  private func printPlot(_ plot: [[String]]) {    
    print(plot.map { $0.joined()  }.joined(separator: "\n"))
  }

  private func drawSquar(_ pair: (Point, Point), plot: inout [[String]]) {
    for i in min(pair.0.y, pair.1.y)...max(pair.0.y, pair.1.y) {
      for j in min(pair.0.x, pair.1.x)...max(pair.0.x, pair.1.x) {
        if (pair.0.x == j && pair.0.y == i) || (pair.1.x == j && pair.1.y == i) { continue }
        plot[i][j] = "0"
      }
    }
  }
}