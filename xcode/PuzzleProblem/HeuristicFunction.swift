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
    var goalSequence: State { get set }
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

// MARK: Add extension to validate sequence
extension HeuristicFunction {
    ///
    /// Validates the provided sequence with the goal state
    /// - Parameter sequence: The sequence to compare
    /// - Returns: Returns true only if state matches
    /// - Remarks: Throws a `fatalError` if the two states cannot be compared
    ///
    func isSameSequence(sequence: [Int]) -> Bool {
        if sequence.count != self.goalSequence.count {
            fatalError("Sequence is not the same length goal sequence")
        }
        // If the two sequences are the same then no need
        return sequence == goalSequence
    }
}