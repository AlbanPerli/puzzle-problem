//
//  AStarSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 30/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct AStarSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "A Star Search"
    static var code: String = "AS"
    var goalState: State
    var frontier: Frontier
    
    init(goalState: State, heuristicFunction: HeuristicFunction) {
        self.goalState = goalState
        // A Star uses a heuristic frontier with a heuristic and path cost
        // evaluation function, that is f(n) = g(n) + h(n)
        let evaluationFunction = HeuristicAndPathCostEvaluation(heuristicFunction: heuristicFunction)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
    }
}
