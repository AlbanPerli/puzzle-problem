//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// Defines a data type that can traverse nodes
///
protocol SearchMethod: class {
    ///
    /// The code of this search method used to run the search method
    ///
    static var code: String { get set }
    ///
    /// The name of this search method
    ///
    static var name: String { get set }
    ///
    /// The frontier which stores next traversable items
    ///
    var frontier: Frontier { get set }
    ///
    /// Desired goal state
    ///
    var goalState: State { get set }
    ///
    /// The traverse method accepts a node to traverse and returns back the goal node
    ///
    /// - Parameter node: The node to traverse
    /// - Returns: The goal node
    ///
    func traverse(node: Node) -> Node?
    ///
    /// Pop's the search method's frontier
    /// - Returns: The next node to traverse
    ///
    func popFrontier() -> Node?

    ///
    /// Pushes a single node to the search method's frontier
    /// - Parameter node: The node to push
    ///
    func pushToFrontier(node: Node)

    ///
    /// Pushes nodes to the search method's frontier
    /// - Parameter node: The node to push
    ///
    func pushToFrontier(node: [Node])
}

// MARK: Provide default behaviour to the SearchMethod protocol

extension SearchMethod {
    func isGoalState(node: Node) -> Bool {
        return node.state == goalState
    }

    func traverse(node: Node) -> Node? {
        // Clear the existing frontier we have as this is a new search
        self.frontier.collection.removeAll()
        // Maintain a dictionary of hash values to test where the node has come
        // from for repeated state checking; that is, check if the node is on a
        // path with a repeated state below. The root node has not come from
        // anything, thus nil
        var cameFrom: Dictionary<Int, Int?> = [node.hashValue: nil]
        // Push the first node on
        self.frontier.push(node)
        // While the search method condition is true
        while !frontier.isEmpty {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = self.popFrontier()!
            // Goal test
            if self.isGoalState(currentNode) {
                SearchMethodObservationCenter.sharedCenter
                    .notifyObservers(currentNode, isSolved: true)
                return currentNode
            } else {
                // Only add the children whos hash values are not stored as keys
                // in the nodes that this node has come from
                let childrenToAdd = currentNode.children.filter {
                    !(cameFrom.keys.contains($0.hashValue))
                }
                // Update prvious states for the children we are about to add
                for child in childrenToAdd {
                    cameFrom.updateValue(child.hashValue,
                                         forKey: currentNode.hashValue)
                }
                // Notify change
                SearchMethodObservationCenter.sharedCenter
                    .notifyObservers(currentNode, isSolved: false)
                // Push new children
                self.pushToFrontier(childrenToAdd)
            }
        }
        return nil
    }

    // MARK: Pushing and poping from frontier

    // These are overrided for IterativeDeepeningSearchMethod's - they don't always
    // push and pop from the same frontier (i.e., may push to the fallback frontier
    // if the node value exceed's the threshold.
    // See IterativeDeepeningSearchMethod.swift for more details

    func popFrontier() -> Node? {
        return self.frontier.pop()
    }

    func pushToFrontier(node: Node) {
        self.frontier.push(node)
    }

    func pushToFrontier(nodes: [Node]) {
        self.frontier.push(nodes)
    }
}

