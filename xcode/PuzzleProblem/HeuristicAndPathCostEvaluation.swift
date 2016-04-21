//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           29/03/2016
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
    func evaluate(node: Node) -> Float {
        return node.calculateDistanceToGoal {
            // f(n) = g(n) + h(n)
            Float($0.pathCost) + self.heuristicFunction.calculate(node)
        }
    }
}