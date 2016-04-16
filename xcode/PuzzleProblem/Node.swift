//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           17/03/2016
//

///
/// This constant defines the value of a single path cost
///
let kPathCost: Int = 1

///
/// The Node class
///
class Node: Equatable, CustomDebugStringConvertible, Hashable {
    // MARK: Implement Hashable
    var hashValue: Int {
        return self.state.hashValue ?? 0
    }

    // MARK: Implement CustomDebugStringConvertible
    var debugDescription: String {
        return "State: \(self.state.debugDescription ?? "nil") PC: \(self.pathCost)"
    }
    
    // MARK: Properties

    ///
    /// The state stored by this node
    ///
    let state: State

    ///
    /// The path cost to get to this node
    ///
    let pathCost: Int

    ///
    /// The parent of this node
    ///
    let parent: Node?

    // MARK: Lazy-computed properties

    ///
    /// The ansecstors this node has, inclusive of `self`
    /// - Remarks: Expensive to determine this property, which is why it is
    ///            marked with a `lazy` initialiser
    ///
    lazy var ansecstors: [Node] = {
        var ansecstors: [Node] = [self]
        // Unwrap the parent while it exists
        while let parent = ansecstors.last?.parent {
            ansecstors.append(parent)
        }
        return ansecstors
    }()
    
    ///
    /// The children this node has
    /// - Remarks: Expensive to determine this property, which is why it is
    ///            marked with a `lazy` initialiser
    ///
    lazy var children: [Node] = {
        return self.state.possibleActions.map { action -> Node in
            let nextState = self.state.performAction(action)
            return Node(parent: self, state: nextState)
        }
    }()

    ///
    /// Computes the actions that lead to this node's state
    /// - Remarks: Expensive to determine this property, which is why it is
    ///            marked with a `lazy` initialiser
    ///
    lazy var actionsToThisNode: [Action] = {
        var result: [Action] = []
        var ancestor: Node? = self.parent
        if let currentLeadingAction = self.state.leadingAction {
            result.append(currentLeadingAction)
        }
        // Keep backtracking up to my parent's parent, adding their actions
        // to get to their state
        while (ancestor != nil) {
            if let leadingAction = ancestor?.state.leadingAction {
                result.append(leadingAction)
            }
            ancestor = ancestor?.parent
        }
        return result.reverse()
    }()
    
    ///
    /// Determines whether the node is empty or not
    ///
    var isEmpty: Bool {
        return self.children.isEmpty
    }
    
    ///
    /// The distance to goal value, which is updated when the `calculateDistanceToGoal`
    /// function is called on the node.
    /// - Remarks: If the `calculateDistanceToGoal` function has not yet been called, the
    ///            value returned by this property will always be `nil`
    ///
    var distanceToGoal: Int?

    // MARK: Initialisers for nodes

    ///
    /// The initialiser of a node
    ///
    init(parent: Node, state: State) {
        self.pathCost = parent.pathCost + kPathCost
        self.state = state
        self.parent = parent
    }

    ///
    /// Initialiser of a node without a parent
    ///
    init(initialState: State) {
        self.pathCost = 0
        self.state = initialState
        self.parent = nil
    }
    
    ///
    /// Performs the evaluation function on the node using the `heuristicFunction` provided
    /// by the rules determined by the `calculationBlock`
    /// - Parameter heuristicFunction: The heuristic function used to perform the evaluation
    /// - Parameter calculationBlock: The way in which the evaluation is performed
    /// - Returns: The estimated path cost to get to the goal state
    ///
    func calculateDistanceToGoal(calculationBlock: (Node -> Int)) -> Int {
        if self.distanceToGoal == nil {
            self.distanceToGoal = calculationBlock(self)
        }
        return self.distanceToGoal!
    }
}


// MARK: Implement the Equatable protocol for Node

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.state == rhs.state
}
