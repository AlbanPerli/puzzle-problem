//
//  HeuristicOnlyEvaluationFunction.swift
//  PuzzleProblem
//
//  Created by Alex on 29/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A heuristic-only evaluation function only uses the heuristic in determining distance
/// to goal state, that is:
///
/// ```
/// f(n) = h(n)
/// ```
///
struct HeuristicOnlyEvaluation: EvaluationFunction {
    var heuristicFunction: HeuristicFunction
    init(heuristicFunction: HeuristicFunction) {
        self.heuristicFunction = heuristicFunction
    }
    func calculateDistanceToGoal(node: Node) -> Int {
        return node.state.performHeuristic(self.heuristicFunction) ?? 0
    }
}
