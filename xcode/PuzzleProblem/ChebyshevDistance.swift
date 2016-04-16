//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           16/04/2016
//

// Import C math funcs for the right platform
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

///
/// The manhattan heuristic calculates the max of the distance of two points using the absolute
/// difference of their corrdinates, using the following formula:
/// ```
/// max( abs( ( col(current) - col(goal) ) ), abs( row(current) - row(goal) ) )
/// ```
///
struct ChebyshevDistance: HeuristicFunction {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }
    func visit(node: Node) -> Int {
        return node.state.sequence.reduce(0) { (memo, tile) -> Int in
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
            
            // Return the max of the differences
            let maxOfTwoDeltas = max(delta.x, delta.y)
            
            // Add this to the memo
            return memo + maxOfTwoDeltas
        }
    }
}
