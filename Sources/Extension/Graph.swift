struct Graph {
    let nodes: [String: GraphNode]
    let input: GraphNode
    let output: GraphNode

    init(data: String, inputId: String = "you", outputId: String = "out") {
        var input: GraphNode?
        var output: GraphNode?
        var nodes: [String: GraphNode] = [:]
        for line in data.split(separator: "\n") {
            let lineComponents = line.split(separator: ":")

            guard lineComponents.count == 2 else { fatalError("Split (:) must have 2 values. Has now: \(lineComponents.count). Line: \(line)") }
            let id = String(lineComponents[0])            

            let node: GraphNode
            if let existingNode = nodes[id] {
                node = existingNode
            } else {
                node = .init(id: id, parent: nil)
                nodes[id] = node
            }
            if id == inputId && input == nil {
                input = node
            }
            if id == outputId && output == nil {
                output = node
            }

            let childIds = lineComponents[1].split(separator: " ").map { String($0) }
            for childId in childIds {
                let childNode: GraphNode
                if let existingNode = nodes[childId] {
                    childNode = existingNode
                    existingNode.parents.insert(node)
                } else {
                    childNode = .init(id: childId, parent: node)
                    nodes[childId] = childNode
                }

                if childId == outputId && output == nil {
                    output = childNode
                }
                if childId == inputId && input == nil {
                    input = childNode
                }
                node.children.insert(childNode)
            }
        }

        guard let resolvedInput = input, let resolvedOutput = output else { fatalError() }
        
        self.input = resolvedInput
        self.output = resolvedOutput
        self.nodes = nodes
    }
}