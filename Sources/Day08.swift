import Algorithms

struct Day08: AdventDay {
  var data: String

  var points: [Point3] {
    data.split(separator: "\n").map { line in
      let values = line.split(separator: ",").compactMap { Int($0) }
      guard values.count == 3 else {
        fatalError("Line \(line) is not formatted correctly: X,Y,Z")
      }
      return .init(values[0], values[1], values[2])
    }
  }

  func part1() -> Any {
    part1(roundsCount: 1000)
  }

  func part2() -> Any {
    part2(roundsCount: 1000)
  }

  func part1(roundsCount: Int) -> Any {
    let connectedPoints = connectClosestPoints(cluster: points, roundsCount: roundsCount)
    //print("Groups: \(connectedPoints.map { $0.count })")
    return connectedPoints.prefix(3).map { $0.count }.reduce(1, *)
  }

  func part2(roundsCount: Int) -> Any {
    let furthestPoints = furthest2Points(cluster: points)
    return furthestPoints.0.x * furthestPoints.1.x
  }

  private func connectClosestPoints(cluster: [Point3], roundsCount: Int? = 0) -> [Set<Point3>] {
    var groups: [Set<Point3>] = []

    var pairsWithDist: [(points: (Point3, Point3), distance: Double)] = []
    for i in 0..<cluster.count - 1 {
      for j in (i + 1)..<cluster.count {

        let p1 = cluster[i]
        let p2 = cluster[j]
        let dist = p1.distance(to: p2)

        pairsWithDist.append(((p1, p2), dist))
      }
    }

    pairsWithDist.sort(by: { $0.distance < $1.distance })
    if let roundsCount {
      pairsWithDist = Array(pairsWithDist.prefix(roundsCount))
    }

    for (pair, _) in pairsWithDist {
      // print(pair.0)
      // print(pair.1)
      // print(dist)

      let index0 = groups.firstIndex(where: { $0.contains(pair.0) })
      let index1 = groups.firstIndex(where: { $0.contains(pair.1) })

      switch (index0, index1) {
        case let (.some(i0), .some(i1)) where i0 == i1: 
          break // Already in the same array
        case let (.some(i0), .some(i1)):
          let group: Set<Point3>
          let group2: Set<Point3>
          if i0 > i1 {
            group = groups.remove(at: i0)
            group2 = groups.remove(at: i1)
          } else {
            group2 = groups.remove(at: i1)
            group = groups.remove(at: i0)
          }
          groups.append(group.union(group2))
          // print("Merged groups. \(group.count) + \(group2.count)")

        case let (.some(i0), .none):
          var group = groups[i0]
          group.insert(pair.1)
          groups[i0] = group
          // print("Added to group 1: \(group.count)")

        case let (.none, .some(i1)):
          var group = groups[i1]
          group.insert(pair.0)
          groups[i1] = group
          // print("Added to group 2: \(group.count)")

        case (.none, .none):
          groups.append(Set<Point3>(arrayLiteral: pair.0, pair.1))
          // print("New group")
      }
    }
    
    return groups.sorted { $0.count > $1.count }
  }

  private func furthest2Points(cluster: [Point3]) -> (Point3, Point3) {

    var pairsWithDist: [(points: (Point3, Point3), distance: Double)] = []
    for i in 0..<cluster.count - 1 {
      for j in (i + 1)..<cluster.count {

        let p1 = cluster[i]
        let p2 = cluster[j]
        let dist = p1.distance(to: p2)

        pairsWithDist.append(((p1, p2), dist))
      }
    }

    pairsWithDist.sort(by: { $0.distance < $1.distance })
    var groups: [Set<Point3>] = cluster.map { .init(arrayLiteral: $0) }

    var lastPair: (Point3, Point3) = pairsWithDist.first!.points
    while groups.count > 1 || pairsWithDist.isEmpty {
      let (pair, _) = pairsWithDist.removeFirst()
      let i0 = groups.firstIndex(where: { $0.contains(pair.0) })!
      let i1 = groups.firstIndex(where: { $0.contains(pair.1) })!

      guard i0 != i1 else { continue }

      let group: Set<Point3>
      let group2: Set<Point3>
      if i0 > i1 {
        group = groups.remove(at: i0)
        group2 = groups.remove(at: i1)
      } else {
        group2 = groups.remove(at: i1)
        group = groups.remove(at: i0)
      }
      groups.append(group.union(group2))
      lastPair = pair
    }

    return lastPair
  }
}