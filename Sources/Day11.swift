import Algorithms

struct Day11: AdventDay {
  var data: String

  func part1() -> Any {
    let graph = Graph(data: data)

    return discoverGraphPathes(graph)
  }

  func part2() -> Any {
    // let graph = Graph(data: data, inputId: "svr")
    let dacGraph = Graph(data: data, inputId: "dac")
    let fft_svrGraph = Graph(data: data, inputId: "fft", outputId: "svr")
    let svr_dacGraph = Graph(data: data, inputId: "svr", outputId: "dac")
    let dac_fftGraph = Graph(data: data, inputId: "dac", outputId: "fft")
    let dacCount = discoverGraphPathes(dacGraph)
    let fft_svrCount = discoverGraphPathes(fft_svrGraph, goBackward: true)
    let dac_fftCount = discoverGraphPathes(dac_fftGraph, goBackward: true)
    return -1
  }

  private func discoverGraphPathes(_ graph: Graph, goBackward: Bool = false) -> Int {
    let allPathes: [[GraphNode]]? = discover(node: graph.input, outputId: graph.output.id, goBackward: goBackward)

    return allPathes?.count ?? 0
  }

  private func discover(node: GraphNode, outputId: String, goBackward: Bool) -> [[GraphNode]]? {
    guard node.id != outputId else { return [[]] }

    var childrenResults: [[GraphNode]]?
    for nextNode in goBackward ? node.parents : node.children {
      guard let childPathes = discover(node: nextNode, outputId: outputId, goBackward: goBackward) else { continue }
      //print("\(node.id) -> \(child.id) \(childPathes.count)")
      let childResult = childPathes.map { [node] + $0 }
      if childrenResults != nil {
        childrenResults! += childResult
      } else {
        childrenResults = childResult
      }
    }

    return childrenResults
  }

  private func discover(node: GraphNode, outputId: String, allowedPathShouldContainsId: String?) -> [[GraphNode]]? {
    guard node.id != outputId else { return allowedPathShouldContainsId == nil ? [[]] : nil }
    var allowedPathShouldContainsId = allowedPathShouldContainsId
    if allowedPathShouldContainsId == node.id {
        allowedPathShouldContainsId = nil
    }

    var childrenResults: [[GraphNode]]?
    for child in node.children {
      guard let childPathes = discover(node: child, outputId: outputId, allowedPathShouldContainsId: allowedPathShouldContainsId) else { continue }
      //print("\(node.id) -> \(child.id) \(childPathes.count)")
      let childResult = childPathes.map { [node] + $0 }
      if var result = childrenResults {
        result += childResult
      } else {
        childrenResults = childResult
      }
    }

    return childrenResults
  }
}