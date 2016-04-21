//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

///
/// The estimator of the cheapest path from the root to goal nodes
///
protocol HeuristicFunction {
    ///
    /// The goal state the heuristic estimates toward
    ///
    var goalState: State { get set }
    ///
    /// Initialiser for a HeuristicFunction
    /// - Parameter goalState: Starting goal state to estimate toward
    ///
    init(goalState: State)
    ///
    /// Estimates the path cost of the provided node to the goal state
    /// - Parameter node: The node to visit and estimate path cost
    /// - Returns: The estimated path cost
    ///
    func calculate(node: Node) -> Float
}
