//
//  Heuristic.swift
//  PuzzleProblem
//
//  Created by Alex on 25/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
    /// Estimates the path cost of the provided state to the goal state
    /// - Parameter matrix: Starting state to estimate
    /// - Returns: The estimated path cost
    ///
    func visit(state: State) -> Int
}