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
        let node = node
        return nil
        // Cannot traverse through the empty tree (recursive teminator clause)
        if node.isEmpty {
            return nil
        }

        if self.isGoalState(node) {
            return node.actionsToThisNode
        }

        // Set up a traversal queue initialised with the current node
        var frontierQueue: [Node] = [node]
        // Set up an explored set
        var exploredSet: [Node] = []
        // Keep on traversing until the queue is empty
        while !frontierQueue.isEmpty {
            // If we can dequeue a non-empty node in the root of the tree
            if let currentRootNode = frontierQueue.dequeue()
                where !currentRootNode.isEmpty {
                    exploredSet.append(currentRootNode)
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
                            !frontierQueue.contains { node -> Bool in
                                return node.state == childNode.state
                            }
                            let childNotExplored =
                                !exploredSet.contains { node -> Bool in
                                    return node.state == childNode.state
                                }
                            if childNotExplored {
                                print("!explored - \(childNode.state)")
                                // Is the child the goal node?
                                if self.isGoalState(childNode) {
                                    print("BINGO", childNode.state)
                                    // Return the actions that lead to this node
                                    return childNode.actionsToThisNode
                                } else {
                                    // Otherwise add it to the frontier
                                    frontierQueue.append(childNode)
                                }
                            } else {
                                print(" explored - \(childNode.state)")
                            }
                        }
                    }
            }
        }

        // Out of block?
        return nil
    }
}