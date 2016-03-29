//
//  HeuristicAndPathCostEvaluation.swift
//  PuzzleProblem
//
//  Created by Alex on 29/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A heuristic and path cost evaluation function uses sum of the heuristic function result
/// and the cost (so far) to reach the node in determining distance to goal state, that is:
///
/// ```
/// f(n) = g(n) + h(n)
/// ```
///
struct HeuristicAndPathCostEvaluation: EvaluationFunction {
    var heuristicFunction: HeuristicFunction
    init(heuristicFunction: HeuristicFunction) {
        self.heuristicFunction = heuristicFunction
    }
    func calculateDistanceToGoal(node: Node) -> Int {
        return node.pathCost + node.state.performHeuristic(self.heuristicFunction)
    }
}