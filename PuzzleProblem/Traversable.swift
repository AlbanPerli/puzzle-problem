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
protocol Traversable {
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

extension Traversable {
    func isGoalState(node: Node) -> Bool {
        // If there is a state in this node
        if let nodeState: State = node.state {
            // Then the states must match
            return self.goalState == nodeState
        } else {
            return false
        }
    }
}