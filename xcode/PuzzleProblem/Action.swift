//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// An abstraction of a single `position` moved in a given `direction`
///
struct Action: Equatable, CustomStringConvertible {
    // MARK: Implement CustomStringConvertible
    var description: String {
        return "Moving {\(self.position.row), \(self.position.col)} \(self.direction)"
    }

    // MARK: Implement action methods

    ///
    /// The position this action affects
    ///
    let position: Position

    ///
    /// The direction that will be applied to the `position`
    ///
    let direction: Direction

    ///
    /// The inverse of performing this action
    ///
    var inverse: Action {
        // How much to move the provided row or column by
        var row = self.position.row
        var col = self.position.col
        let dir = self.direction

        // Use the directive to determine which element we are looking at
        switch dir {
        case .Up:
            row -= 1
        case .Down:
            row += 1
        case .Left:
            col -= 1
        case .Right:
            col += 1
        }
        
        return Action(movingPosition: (row, col), inDirection: dir.inverse)
    }

    ///
    /// Creates a new instance of an Action
    /// - Parameter movingPosition: Which position to move
    /// - Parameter inDirection: Which direction to move in
    ///
    init(movingPosition position: Position, inDirection direction: Direction) {
        self.direction = direction
        self.position = position
    }
}

// MARK: - Implement Equatable
func ==(lhs: Action, rhs: Action) -> Bool {
    return lhs.position == rhs.position && lhs.direction == rhs.direction
}