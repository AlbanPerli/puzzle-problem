//
//  GreedyBestFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 29/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
struct GreedyBestFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Greedy Best First Search"
    static var code: String = "GBFS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Depth First Search
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
