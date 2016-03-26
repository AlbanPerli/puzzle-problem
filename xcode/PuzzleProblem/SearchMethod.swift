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
    /// Initialiser with a goal state
    /// - Parameter goalState: The goal state to traverse to
    ///
    init(goalState: State)
    ///
    /// The traverse method accepts a node to traverse and returns back a set
    /// of actions needed to take the node provided into the goal state
    ///
    /// - Parameter node: The node to traverse
    /// - Returns: An optional set of actions required to traverse the search
    ///            node to the `goalState`. If `nil` is returned, then there
    ///            is no solution
    ///
    func traverse(node: Node) -> [Action]?
}

// MARK: Provide default behaviour to the Traversable protocol

extension SearchMethod {
    func isGoalState(node: Node) -> Bool {
        // If there is a state in this node
        if let nodeState: State = node.state {
            // Then the states must match
            return self.goalState == nodeState
        } else {
            return false
        }
    }
    func traverse(node: Node) -> [Action]? {
        // Make a copy of frontier (frontier is a struct, so we aren't
        // just copying a pointer here)
        var frontier: Frontier = self.frontier
        var explored: Set<Node> = []
        frontier.push(node)
        while (!frontier.isEmpty) {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = frontier.pop()!
            // We are exploring this node
            explored.insert(currentNode)
            // Check if this node is the goal
            if self.isGoalState(currentNode) {
                return currentNode.actionsToThisNode
            } else {
                // Only add the children to the frontier given they are not
                // in the union of frontier + explored
                let childrenToAdd = currentNode.children.filter {
                    !(frontier.contains($0) || explored.contains($0))
                }
                frontier.push(childrenToAdd)
            }
        }
        return nil
    }
    
}
