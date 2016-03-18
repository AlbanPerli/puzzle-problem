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
/// Implement equatable protocol for Position
///
func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.col == rhs.col && lhs.row == rhs.row;
}
func !=(lhs: Position, rhs: Position) -> Bool {
    return !(lhs == rhs)
}