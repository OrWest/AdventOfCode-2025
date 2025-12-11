import Algorithms

struct Day11: AdventDay {
  var data: String

  func part1() -> Any {
    let graph = Graph(data: data)

    return discoverGraphPathes(graph)
  }

  func part2() -> Any {
    let graph = Graph(data: data, inputId: "svr")
    let svr_fftCount = discover(node: graph.input, outputId: "fft")
    let dacGraph = Graph(data: data, inputId: "dac")
    let dacCount = discover(node: dacGraph.input, outputId: dacGraph.output.id)
    let fftGraph = Graph(data: data, inputId: "fft")
    let fftCount = discover(node: fftGraph.input, outputId: "dac")
    return svr_fftCount * fftCount * dacCount
  }

  private func discoverGraphPathes(_ graph: Graph) -> Int {
    let pathCount = discover(node: graph.input, outputId: graph.output.id)
    return pathCount
  }

  private func discover(node: GraphNode, outputId: String) -> Int {
    guard node.id != outputId else { 
      node.pathToExitCount = 1
      return 1
    }

    // Caches value
    guard node.pathToExitCount == nil else { 
      return node.pathToExitCount!
    }

    var childrenResults: Int = 0
    for nextNode in node.children {
      let childPathCount = discover(node: nextNode, outputId: outputId)
      //print("\(node.id) -> \(child.id) \(childPathes.count)")
      childrenResults += childPathCount
    }

    node.pathToExitCount = childrenResults

    return childrenResults
  }
}