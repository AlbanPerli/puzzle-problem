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
        var explored: FifoFrontier = FifoFrontier()
        frontier.push(node)
        while (!frontier.isEmpty) {
            // Force unwrap of optional as frontier isn't empty
            let currentNode = frontier.pop()!
            // We are exploring this node
            explored.push(currentNode)
            // Check if this node is the goal
            if self.isGoalState(currentNode) {
                return currentNode.actionsToThisNode
            } else {
                let children = currentNode.children
                for node in children {
                    if !(frontier.contains(node) || explored.contains(node)) {
                        frontier.push(node)
                    }
                }
            }
        }
        return nil
    }
}