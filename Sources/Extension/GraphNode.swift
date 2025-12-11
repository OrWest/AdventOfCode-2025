class GraphNode: Hashable {
    let id: String
    var children: Set<GraphNode>
    var parents: Set<GraphNode>

    init(id: String, parent: GraphNode?, childs: Set<GraphNode> = []) {
        self.id = id
        self.children = childs
        self.parents = parent.map { [$0] } ?? []
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
        lhs.id == rhs.id
    }
}