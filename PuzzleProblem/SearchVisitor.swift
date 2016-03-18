//
//  SearchVisitor.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation

protocol SearchVisitor {
    var goalState: State { get set }
    init(goalState: State)
    func traverse(node: Node)
}

extension SearchVisitor {
    func isGoalState(node: Node) -> Bool {
        if let nodeState: State = node.state {
            return self.goalState == nodeState
        } else {
            return false
        }
    }
}

struct DepthFirstTraversal: SearchVisitor {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }

    func traverse(node: Node) {
        // Cannot traverse through the empty tree (recursive teminator clause)
        if node.isEmpty {
            return
        }
        // Traverse through each child
        for childNode: Node in node.children {
            childNode.traverse(self)
        }
    }
}

struct BreadthFirstTraversal: SearchVisitor {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }
    
    func traverse(node: Node) {
        // Cannot traverse through the empty tree (recursive teminator clause)
        if node.isEmpty {
            return
        }
        
        // Set up a traversal queue initialised with the current node
        var traversalQueue: [Node] = [node]
        
        // Keep on traversing until the queue is empty
        while !traversalQueue.isEmpty {
            // If we can dequeue a non-empty node in the root of the tree
            if let currentRootNode = traversalQueue.dequeue()
                where !currentRootNode.isEmpty {
//                self.checkGoalState(currentRootNode)
            }
        }
    }
}