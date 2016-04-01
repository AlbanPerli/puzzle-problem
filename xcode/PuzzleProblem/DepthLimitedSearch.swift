//
//  DepthLimitedSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 1/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct DepthLimitedSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth Limited Search"
    static var code: String = "DLS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// The depth at which to give up exploring
    ///
    let depthCutoff: Int
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter depthCutoff: Do not traverse nodes whose path costs are greater than the
    ///                          depth cutoff
    ///
    init(goalState: State, depthCutoff: Int) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
        self.depthCutoff = depthCutoff
    }
 
    // Override the expand node and only expand if this node doesn't exceed the cutoff
    func shouldTryToExpandNode(node: Node) -> Bool {
        return node.pathCost < depthCutoff
    }
}