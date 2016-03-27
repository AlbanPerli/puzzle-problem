//
//  MisplacedTileHeuristic.swift
//  PuzzleProblem
//
//  Created by Alex on 25/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct MisplacedTileHeuristic: HeuristicFunction {
    ///
    /// Represent the goal state matrix as a sequence
    ///
    var goalSequence: [Int]
    var goalState: State
    init(goalState: State) {
        self.goalSequence = goalState.sequence
        self.goalState = goalState
    }
    func visit(state: State) -> Int {
        let sequence = state.sequence
        // Calculate the differences
        return sequence.enumerate().reduce(0) { (diff, iteratee) -> Int in
            // If the index at goalSequence isn't the current element, add one
            // to the differences granted the current element isn't the empty
            // tile element
            diff +
                (goalSequence[iteratee.index] != iteratee.element &&
                iteratee.element != kEmptyTile ? 1 : 0)
        }
    }
}
