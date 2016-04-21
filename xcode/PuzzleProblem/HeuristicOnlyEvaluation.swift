//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           29/03/2016
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
    func evaluate(node: Node) -> Float {
        return node.calculateDistanceToGoal {
            // f(n) = h(n)
            self.heuristicFunction.calculate($0)
        }
    }
}
