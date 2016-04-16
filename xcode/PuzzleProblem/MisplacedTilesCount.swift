//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

///
/// The misplaced tiles count heuristic calculates the distance of the goal by counting how
/// many misplaced tiles there are in the current state against the goal state
///
struct MisplacedTilesCount: HeuristicFunction {
    ///
    /// Represent the goal state matrix as a sequence
    ///
    var goalSequence: [Int]
    var goalState: State
    init(goalState: State) {
        self.goalSequence = goalState.sequence
        self.goalState = goalState
    }
    func visit(node: Node) -> Int {
        // Calculate the differences
        return node.state.sequence.enumerate().reduce(0) { (diff, iteratee) -> Int in
            // If the index at goalSequence isn't the current element, add one
            // to the differences granted the current element isn't the empty
            // tile element
            diff +
                (goalSequence[iteratee.index] != iteratee.element &&
                iteratee.element != kEmptyTile ? 1 : 0)
        }
    }
}
