//
//  SearchVisitor.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct DepthFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth First Search"
    static var code: String = "DFS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
    }

}