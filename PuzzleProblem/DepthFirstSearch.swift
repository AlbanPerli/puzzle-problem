//
//  SearchVisitor.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct DepthFirstSearch: SearchMethod, Traversable {
    // MARK: Implement SearchMethod
    var name: String = "Depth First Search"
    var code: String = "DFS"

    // MARK: Impelement Traversable
    var goalState: State
    var frontier: Frontier
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
    }
}