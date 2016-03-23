//
//  BreathFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct BreadthFirstSearch: SearchMethod, Traversable {
    // MARK: Implement SearchMethod
    var name: String = "Breadth First Search"
    var code: String = "BFS"

    // MARK: Impelement Traversable
    var goalState: State
    var frontier: Frontier
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a FIFO frontier
        self.frontier = FifoFrontier()
    }
}