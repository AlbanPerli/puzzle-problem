//
//  SumOfDistancesHeuristic.swift
//  PuzzleProblem
//
//  Created by Alex on 25/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

//struct DistanceToGoalHeuristic: HeuristicFunction {
//    var goalSequence: State
//    init(goalState: State) {
//        self.goalSequence = goalState.sequence
//    }
//    func visit(state: State) -> Int {
//        let sequence = state.sequence
//        if isSameSequence(sequence) {
//            return 0
//        }
//        // Calculate the sum to distance to the goal state
//        return sequence.enumerate().reduce(0) { (diff, iteratee) -> Int in
//            // To find the distance, subtract the index of the element with the
//            // index of the iteraree, and ensure it's always positive
//            let distance =
//                iteratee.element == kEmptyTile ? 0 :
//                goalSequence.indexOf(iteratee.element)! - iteratee.index
//            return diff + (distance < 0 ? -distance : distance)
//        }
//    }
//}