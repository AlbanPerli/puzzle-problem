//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           21/04/2016
//

///
/// Defines a search method that iteratively traverses a graph for its target node.
/// When a node's value exceeds the threshold (as determined by a value returned from
/// the `nodeThresholdComparatorBlock`), then the node is not added to the standard,
/// concrete frontier implemented by whatever search algorithm implements the protocol,
/// rather it is added to a FifoFrontier (`fallbackFrontier`) that will be considered
/// once the frontier is empty. Consider a frontier below with a threshold of `4`
/// ```
/// [ 1 , 2 , 3 , 4 ]
/// ```
/// Any new values greater than 4 are added to the `fallbackFrontier` instead. Once
/// the frontier above is popped of all its nodes, then the `fallbackFrontier`'s values
/// are added to the frontier (all those that are still within the threshold of course)
/// and the `threshold` value is doubled. This simulates a new iterative search without
/// the recursive search.
///
protocol IterativeDeepeningSearchMethod: SearchMethod {
    ///
    /// The threshold value to not expand nodes when evaluated to be greater
    /// than this value
    ///
    var threshold: Int { get set }

    ///
    /// Fallback frontier is the frontier used for the *next* iterative search when
    /// the actual frontier is about to be empty. Adds new nodes in FIFO order.
    ///
    var fallbackFrontier: FifoFrontier { get set }

    ///
    /// Block to calculate the value that is compared against a threshold
    ///
    var nodeThresholdComparatorBlock: (Node) -> Int { get set }
}

extension IterativeDeepeningSearchMethod {

    // MARK: Override search method's pushing and popping extension

    func pushToFrontier(nodes: [Node]) {
        // Just wrap in for loop
        for node in nodes {
            pushToFrontier(node)
        }
    }

    func pushToFrontier(node: Node) {
        // If the node we want to push exceeds the threshold we currently have?
        if self.nodeThresholdComparatorBlock(node) > self.threshold {
            // Then we will push to our fallback - essentially add this node to the
            // end of the queue and we will pop it only if we are completely out of
            // nodes that are out of the threshold range
            self.fallbackFrontier.push(node)
        } else {
            // We can push this node to the concrete frontier as it is within the
            // threshold; essentially act as a normal frontier
            self.frontier.push(node)
        }
    }

    func popFrontier() -> Node? {
        // We have some nodes in our frontier?
        var poppedNode: Node?
        if !self.frontier.isEmpty {
            poppedNode = self.frontier.pop()
        }
        // Second if to see if we just made the entire frontier empty by popping
        // above in nodeToPop
        if self.frontier.isEmpty {
            // Since we are now out of nodes, we have to **iteratively** traverse
            // nodes in the fallback frontier instead (i.e., nodes which were too
            // much beyond the threshold before but are now okay to test.
            // Therefore append the fallback frontier's collection to the
            // collection of frontier and double the threshold to support new nodes
            // for iterative deepening.

            // Double the threshold with each iteration
            self.threshold *= 2

            // Get the nodes which are in the fallback that do not exceed threshold
            let nextIterationNodes = self.fallbackFrontier.collection.filter {
                self.nodeThresholdComparatorBlock($0) < self.threshold
            }

            // Add in all nodes in the fallback
            self.frontier.collection
                .appendContentsOf(nextIterationNodes)
            // Remove all nodes from the fallback part of this iteration
            // We do this by reassigning the collection to the same collection
            // filtered by not containing nodes in nextIterationNodes
            self.fallbackFrontier.collection =
                self.fallbackFrontier.collection.filter {
                    !nextIterationNodes.contains($0)
                }

            // Pop if were never able to pop before (i.e., popped node is still nil)
            if poppedNode == nil {
                poppedNode = self.frontier.pop()
            }
        }
        return poppedNode!
    }
    
}