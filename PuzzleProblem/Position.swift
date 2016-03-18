//
//  Position.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A position tuple is just a tuple with `row` and `col`
///
typealias Position = (row: Int, col: Int)

///
/// Move the position in a given direction
/// - Parameter position: The direction to move in
/// - Parameter direction: The direction to move in
/// - Returns: A new position
///
func movePositionIn(position: Position, direction: Direction) -> Position {
    // How much to move the provided row or column by
    var row = position.row
    var col = position.col

    // Use the directive to determine which element we are looking at
    switch direction {
    case .Up:
        row -= 1
    case .Down:
        row += 1
    case .Left:
        col -= 1
    case .Right:
        col += 1
    }

    return (row, col)
}

///
/// Implement equatable protocol for Position
///
func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.col == rhs.col && lhs.row == rhs.row;
}
func !=(lhs: Position, rhs: Position) -> Bool {
    return !(lhs == rhs)
}