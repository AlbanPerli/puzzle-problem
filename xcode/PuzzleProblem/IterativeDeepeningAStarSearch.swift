//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           5/04/2016
//

///
/// An Iterative Deepening A Star Search is essentially an A Star search however
/// it will not expand nodes whose evaluation function results in a value greater than
/// the threshold. If threshold is exceeded and no nodes remain in the frontier, then
/// nodes in the fallback frontier will be used *iteratively* until a solution 
/// is found.
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(b<sup>mb</sup>)
///
class IterativeDeepeningAStarSearch: IterativeDeepeningSearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Iterative Deepening A Star Search"
    static var code: String = "IDAS"
    var goalState: State
    var frontier: Frontier
    
    // MARK: Implement IterativeDeepeningSearchMethod
    var threshold: Int
    var fallbackFrontier: FifoFrontier = FifoFrontier()
    var nodeThresholdComparatorBlock: (Node) -> Int

    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter heuristicFunction: The heuristic used in the evaluation function
    /// - Parameter threshold: Do not traverse nodes who evaluate to a value greater
    ///                        than the threshold unless threshold exceeds this value
    ///
    init(goalState: State, heuristicFunction: HeuristicFunction, threshold: Int) {
        self.goalState = goalState
        self.threshold = threshold
        // A Star uses a heuristic frontier with a heuristic and path cost
        // evaluation function, that is f(n) = g(n) + h(n)
        let evaluationFunction =
            HeuristicAndPathCostEvaluation(heuristicFunction: heuristicFunction)
        // Depth First Search uses Evaluated Frontier (wrapped in a fallback supported
        // frontier)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
        self.nodeThresholdComparatorBlock = { node in
            // IDS compares against a node's path cost (i.e., it's depth in the
            // context of the n by m puzzle solver)
            return node.pathCost
        }
    }
}