//
//  COS30019 Introduction to AI
//  Assignment 1
//
//  Alex Cummuado 1744070
//

///
/// This constant defines the value of a single path cost
///
let kPathCost: Int = 1

///
/// The Node class
///
struct Node: Equatable {
    ///
    /// The path cost to get to this node
    ///
    let pathCost: Int

    ///
    /// The children this node has
    /// - Remarks: Expensive to determine this property, which is why it is
    ///            marked with a `lazy` initialiser
    ///
    lazy var children: [Node] = {
        if let unwrappedState = self.state {
            return unwrappedState.possibleActions.map { action -> Node in
                let nextState: State? = unwrappedState.performAction(action)
                return Node(parent: self, state: nextState)
            }
        } else {
            return []
        }
    }()

    ///
    /// The state stored by this node
    ///
    let state: State?

    ///
    /// The initialiser of a node
    ///
    init(parent: Node, state: State?) {
        self.pathCost = parent.pathCost + kPathCost
        self.state = state
    }

    ///
    /// Initialiser of a node without a parent
    ///
    init(initialState: State) {
        self.pathCost = 0
        self.state = initialState
    }
}

///
/// Implement the Equatable protocol for Node
///
func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.state == rhs.state
}
