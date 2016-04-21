//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

// Import C math funcs for the right platform
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

///
/// The manhattan heuristic calculates the sum of the distance of two points using the absolute
/// difference of their corrdinates, using the following formula:
/// ```
/// abs( ( col(current) - col(goal) ) ) + abs( row(current) - row(goal) ) )
/// ```
///
struct ManhattanDistance: HeuristicFunction {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }
    func calculate(node: Node) -> Float {
        return node.state.sequence.reduce(0) { memo, tile -> Float in
            // Do not consider the blank tile
            if tile == kEmptyTile {
                return memo
            }

            // Get the positions of the current tile on both the
            // current and goal states
            guard
                let goalPos = self.goalState.positionOf(tile),
                let currPos = node.state.positionOf(tile) else {
                    return memo + 0
            }
            
            // Calculate the difference of the cols (x) and rows (y)
            let delta = (
                x: currPos.col - goalPos.col,
                y: currPos.row - goalPos.row
            )
            
            // Absolute the differences
            let sumOfAbs = abs(delta.x) + abs(delta.y)
            
            // Add this to the memo
            return memo + Float(sumOfAbs)
        }
    }
}