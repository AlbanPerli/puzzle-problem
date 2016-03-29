//
//  GreedyBestFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 29/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct GreedyBestFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Greedy Best First Search"
    static var code: String = "GBFS"
    var goalState: State
    var frontier: Frontier
    
    init(goalState: State, heuristicFunction: HeuristicFunction) {
        self.goalState = goalState
        // Breadth First Search uses a heuristic frontier with a heuristic-only
        // evaluation function, that is f(n) = h(n)
        let evaluationFunction = HeuristicOnlyEvaluation(heuristicFunction: heuristicFunction)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
    }
}
