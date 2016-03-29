//
//  SumOfDistancesHeuristic.swift
//  PuzzleProblem
//
//  Created by Alex on 25/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct DistanceToGoalHeuristic: HeuristicFunction {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }
    func visit(node: Node) -> Int {
        let state = node.state
        return state.sequence.reduce(0) { diff, tile -> Int in
            // Do not consider the blank tile
            if tile == kEmptyTile {
                return diff
            }
            
            // Get the positions of the current tile on both the
            // current and goal states
            guard
                let goalPos = self.goalState.positionOf(tile),
                let currPos = state.positionOf(tile) else {
                    return diff + 0
            }
            
            // Work out the differences in the both goal and current
            // tile positions
            let colDiff = goalPos.col - currPos.col
            let rowDiff = goalPos.row - currPos.row
            
            // Absolute them
            let absColDiff = colDiff < 0 ? -colDiff : colDiff
            let absRowDiff = rowDiff < 0 ? -rowDiff : rowDiff
            
            // Return the current difference add the sum of the row and
            // column differences
            return diff + (absColDiff + absRowDiff)
        }
    }
}