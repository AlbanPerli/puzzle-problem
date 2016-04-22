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
/// The euclidean heuristic calculates the straight-line distance of the node to its goal
/// node using the following formula:
/// ```
/// sqrt( ( col(current) - col(goal) )^2 + ( row(current) - row(goal) )^2 )
/// ```
///
struct EuclideanDistance: HeuristicFunction {
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }
    func calculate(node: Node) -> Float {
        return node.state.sequence.reduce(0) { (memo, tile) -> Float in
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
                x: Double(currPos.col - goalPos.col),
                y: Double(currPos.row - goalPos.row)
            )
            
            // Sum the powers of both and square-root the result
            let sumOfDiffsPower = sqrt( pow(delta.x, 2) + pow(delta.y, 2) )
            
            // Add this to the memo
            return memo + Float(sumOfDiffsPower)
        }
    }
}
