//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           30/03/2016
//

///
/// A Star Search is an *informed* search method that traverses nodes in a priority
/// queue ordered by its heuristic function and cost to the node, that is:
/// ```
/// f(n) = h(n) + g(n)
/// ```
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(b<sup>m</sup>)
///
class AStarSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "A* Search"
    static var code: String = "AS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a A* Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter heuristicFunction: The heuristic used in the evaluation function
    ///
    init(goalState: State, heuristicFunction: HeuristicFunction) {
        self.goalState = goalState
        // A Star uses a heuristic frontier with a heuristic and path cost
        // evaluation function, that is f(n) = g(n) + h(n)
        let evaluationFunction = HeuristicAndPathCostEvaluation(heuristicFunction: heuristicFunction)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
    }
    
}
