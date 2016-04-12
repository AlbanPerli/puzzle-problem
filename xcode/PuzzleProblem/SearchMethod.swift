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
protocol SearchMethod {
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
    var frontier: Frontier { get }
    ///
    /// Desired goal state
    ///
    var goalState: State { get set }
    ///
    /// The should try expand node method returns whether or not the node provided
    /// should be expanded.
    /// - Parameter node: The node to try and expand
    /// - Returns: Whether or not the node should be expanded
    ///
    func shouldTryToExpandNode(node: Node) -> Bool
    ///
    /// The traverse method accepts a node to traverse and returns back the goal node
    ///
    /// - Parameter node: The node to traverse
    /// - Returns: The goal node
    ///
    func traverse(node: Node) -> Node?
}

// MARK: Provide default behaviour to the SearchMethod protocol

extension SearchMethod {
    func isGoalState(node: Node) -> Bool {
        return node.state == goalState
    }
    func shouldTryToExpandNode(node: Node) -> Bool {
        // Usually we always expand nodes, except if overriden with a special condition
        return true
    }
    func traverse(node: Node) -> Node? {
        // Make a copy of frontier (frontier is a struct, so we aren't
        // just copying a pointer here)
        var frontier: Frontier = self.frontier
        // Use hashmap of expanded states such that the same state is not expanded
        var expandedStates = Set<Int>()
        // Maintain a dictionary of hash values to test where the node has come from
        // The root node has not come from anything, thus nil
        var cameFrom: Dictionary<Int, Int?> = [node.hashValue: nil]
        // Push the first node on
        frontier.push(node)
        // While the search method condition is true
        while !frontier.isEmpty {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = frontier.pop()!
            if expandedStates.contains(currentNode.state.hashValue) {
                continue
            } else if self.isGoalState(currentNode) {
                SearchMethodObservationCenter.sharedCenter.notifyObservers(currentNode, isSolved: true)
                return currentNode
            } else if self.shouldTryToExpandNode(currentNode) {
                // Insert hash into expanded states
                expandedStates.insert(currentNode.state.hashValue)
                // Only add the children whos hash values are not stored as keys
                // in the nodes that this node has come from
                let childrenToAdd = currentNode.children.filter {
                    !(cameFrom.keys.contains($0.hashValue))
                }
                // Update the nodesComeFrom for all the children we are about to add
                for child in childrenToAdd {
                    cameFrom.updateValue(child.hashValue, forKey: currentNode.hashValue)
                }
                // Notify change
                SearchMethodObservationCenter.sharedCenter.notifyObservers(currentNode, isSolved: false)
                // Push new children
                frontier.push(childrenToAdd)
            }
        }
        return nil
    }
}

