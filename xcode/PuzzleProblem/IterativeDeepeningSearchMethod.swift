//
//  IterativeDeepeningSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 21/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

protocol IterativeDeepeningSearchMethod: SearchMethod {
    ///
    /// Block to calculate the value that is compared against a threshold
    ///
    var nodeThresholdCheck: (Node) -> Int { get set }

    ///
    /// The threshold value to not expand nodes when evaluated to be greater than this value
    ///
    var threshold: Int { get set }

    ///
    /// Fallback frontier is the frontier used for the *next* iterative search when
    /// the actual frontier is about to be empty. Adds new nodes in FIFO order.
    ///
    var fallbackFrontier: FifoFrontier { get set }
}

extension IterativeDeepeningSearchMethod {
    // Override the expand node and only expand if this node doesn't exceed the threshold
    mutating func shouldTryToExpandNode(node: Node) -> Bool {
        // Value to compare against threshold is implemented by nodeThresholdCheck:
        let valueToCompare = nodeThresholdCheck(node)
        // This node's path cost is lower than my threshold?
        // print("Path cost \(node.pathCost) < Threshold \(self.threshold)")
        // print("Frontier count: \(self.frontier.collection.count); fallback count: \(self.fallbackFrontier.collection.count)")
        if valueToCompare < self.threshold {
            return true
        } else {
            // This node's path cost is higher than the threshold. We need to insert
            // this node at the right place in the frontier's collection. To do this
            // we need to find the node with the smallest path cost
            // get a 5
            // 1 2 3 4 5
            // 5 1 2 3 4
            // 5 5 5 5 5 but threshold is 4
            //           so increase threshold to 8
            // 8 8 8 8 5
            // 8 8 8 8 8 increase threshold to 10
            // and so on...
            self.fallbackFrontier.push(node)
            // We are about to run out of nodes?
            if self.frontier.collection.count == 1 {
                // Double the allowed threshold
                self.threshold *= 2
                // No more left in frontier? Fallback to fallback frontier
                self.frontier.push(self.fallbackFrontier.collection)
                // Empty fallback frontier's collection
                self.fallbackFrontier.collection.removeAll()
            }

            // Don't explore this node yet -- do it later
            return false
        }
    }
}
