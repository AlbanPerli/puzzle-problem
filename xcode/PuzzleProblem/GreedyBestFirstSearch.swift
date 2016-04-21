//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           29/03/2016
//

///
/// Greedy Best First Search is an *informed* search method that traverses nodes in a
/// priority queue ordered by its heuristic function. It evaluates nodes using only the
/// heuristic function, that is:
/// ```
/// f(n) = h(n)
/// ```
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(b<sup>m</sup>)
///
class GreedyBestFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Greedy Best First Search"
    static var code: String = "GBFS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a GBFS
    /// - Parameter goalState: The search's goal state
    /// - Parameter heuristicFunction: The heuristic used in the evaluation function
    ///
    init(goalState: State, heuristicFunction: HeuristicFunction) {
        self.goalState = goalState
        // Greedy Best First Search uses a heuristic frontier with a heuristic-only
        // evaluation function, that is f(n) = h(n)
        let evaluationFunction = HeuristicOnlyEvaluation(heuristicFunction: heuristicFunction)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
    }
}
