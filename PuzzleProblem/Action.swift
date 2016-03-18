//
//  Action.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// An abstraction of a single `position` moved in a given `direction`
///
struct Action: CustomStringConvertible {
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
    /// Returns a new action when the given position is moved in the provided
    /// direction
    ///
    /// - Parameter position: Which position to move
    /// - Parameter inDirection: The direction to move this position in
    /// - Returns: A new action describing the action that can move this tile
    ///
    static func move(position: Position, inDirection dir: Direction) -> Action {
        // How much to move the provided row or column by
        var row = position.row
        var col = position.col

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