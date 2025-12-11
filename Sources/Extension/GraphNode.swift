class GraphNode: Hashable {
    let id: String
    var children: [GraphNode]
    var pathToExitCount: Int?

    init(id: String, childs: [GraphNode] = []) {
        self.id = id
        self.children = childs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
        lhs.id == rhs.id
    }
}