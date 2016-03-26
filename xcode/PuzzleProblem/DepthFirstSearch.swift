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

    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
    }
}