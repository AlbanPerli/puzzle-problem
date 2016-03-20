//
//  BreathFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation

struct BreadthFirstSearch: SearchMethod, Traversable {
    // MARK: Implement SearchMethod
    var name: String = "Breadth First Search"
    var code: String = "BFS"

    // MARK: Impelement Traversable
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }

    func traverse(node: Node) -> [Action]? {
        var frontier: FifoFrontier = FifoFrontier()
        var explored: Set<Node> = []
        frontier.push(node)
        while (!frontier.isEmpty) {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = frontier.pop()!
            print("exploring \(currentNode.state!)")
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