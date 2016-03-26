//
//  BreathFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct BreadthFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Breadth First Search"
    static var code: String = "BFS"
    var goalState: State
    var frontier: Frontier

    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a FIFO frontier
        self.frontier = FifoFrontier()
    }
}