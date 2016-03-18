//
//  BreathFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation

struct BreadthFirstTraversal: SearchMethod, Traversable {
    // MARK: Implement SearchMethod
    var name: String = "Breadth First Search"
    var code: String = "BFS"

    // MARK: Impelement Traversable
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }

    func traverse(node: Node) -> [Action]? {
        let node = node

        // Cannot traverse through the empty tree (recursive teminator clause)
        if node.isEmpty {
            return nil
        }

        // Set up a traversal queue initialised with the current node
        var frontierQueue: [Node] = [node]
        // Set up an explored set
        var exploredSet: Set<Node> = []

        // Keep on traversing until the queue is empty
        while !frontierQueue.isEmpty {
            // If we can dequeue a non-empty node in the root of the tree
            if let currentRootNode = frontierQueue.dequeue()
                where !currentRootNode.isEmpty {
                    exploredSet.insert(currentRootNode)
                    if let actions = currentRootNode.state?.possibleActions {
                        // Try every possible action on the current node
                        for action: Action in actions {
                            // Progress the state using the current action
                            let newState =
                                currentRootNode.state?.performAction(action)
                            // Create a new node using the new state and parent
                            let childNode =
                                Node(parent: currentRootNode, state: newState)
                            // Ensure we have not already searched this node
                            // or it is yet to be searched in frontier
                            let childNotInFrontier =
                                !frontierQueue.contains(childNode)
                            let childNotExplored =
                                !exploredSet.contains(childNode)
                            if childNotInFrontier || childNotExplored {
                                // Is the child the goal node?
                                if self.isGoalState(childNode) {
                                    // Return the actions that lead to this node
                                    return childNode.actionsToThisNode
                                } else {
                                    // Otherwise add it to the frontier
                                    frontierQueue.append(childNode)
                                }
                            }
                        }
                    }
            }
        }

        // Out of block?
        return nil
    }
}