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
        while var parent = ansecstors.last?.parent {
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
    /// Determines whether the node is empty or not
    ///
    lazy var isEmpty: Bool = {
        return self.children.isEmpty
    }()

    ///
    /// Computes the actions that lead to this node's state
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
    /// Performs a heuristic function on this node to estimate its cost to the
    /// goal state provided in the `function`
    /// - Parameter function: The heuristic function to perform
    /// - Returns: The estimated path cost to get to the goal state
    ///
    func performHeuristic(function: HeuristicFunction) -> Int {
        return function.visit(self)
    }
}


// MARK: Implement the Equatable protocol for Node

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.state == rhs.state
}
