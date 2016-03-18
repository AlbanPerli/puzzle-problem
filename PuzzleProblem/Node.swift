//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

class Node: Equatable {
    private static let NilSentinel: Node = Node()
    
    var children: [Node]
    
    var state: State?
    var isEmpty: Bool {
        return self == Node.NilSentinel
    }
    
    private init() {
        // Black hole
        self.children = []
        
    }
    
    init(children: [Node], state: State) {
        self.children = children
        self.state = state
    }
    
    subscript (index: Int) -> Node? {
        return children[index]
    }
    
    func traverse(visitor: SearchVisitor) {
        
    }
    
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.state == rhs.state
}

