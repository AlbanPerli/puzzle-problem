//
//  Traversable.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
    /// The traverse method accepts a node to traverse and returns back a set
    /// of actions needed to take the node provided into the goal state
    ///
    /// - Parameter node: The node to traverse
    /// - Returns: A tuple containing: `actions`, an optional set of actions 
    ///            required to traverse the node to the `goalState` or `nil`
    ///            where there are no solutions and `nodesTraversed` being a set
    ///            of nodes that have been traversed to get to the `goalState`.
    ///
    func traverse(node: Node) -> (actions: [Action]?, nodesTraversed: [Node])
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
    func traverse(node: Node) -> (actions: [Action]?, nodesTraversed: [Node]) {
        // Make a copy of frontier (frontier is a struct, so we aren't
        // just copying a pointer here)
        var frontier: Frontier = self.frontier
        // Maintain a dictionary of hash values to test where the node has come from
        // The root node has not come from anything, thus nil
        var nodesCameFrom: Dictionary<Int, Int?> = [node.hashValue: nil]
        var nodesTraversed: [Node] = []
        // Maintain a list of the nodes we have traversed
        frontier.push(node)
        // While the search method condition is true
        while !frontier.isEmpty {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = frontier.pop()!
            // Add to the list of nodes traversed this popped node
            nodesTraversed.append(currentNode)
            // Check if this node is the goal
            if self.isGoalState(currentNode) {
                SearchMethodObserver.sharedObserver.notify(currentNode, isSolved: true)
                return (currentNode.actionsToThisNode, nodesTraversed)
            } else if self.shouldTryToExpandNode(currentNode) {
                // Only add the children whos hash values are not stored as keys
                // in the nodes that this node has come from
                let childrenToAdd = currentNode.children.filter {
                    !(nodesCameFrom.keys.contains($0.hashValue))
                }
                // Update the nodesComeFrom for all the children we are about to add
                for child in childrenToAdd {
                    nodesCameFrom.updateValue(child.hashValue, forKey: currentNode.hashValue)
                }
                SearchMethodObserver.sharedObserver.notify(currentNode, isSolved: false)
                frontier.push(childrenToAdd)
            }
        }
        return (nil, nodesTraversed)
    }
}
