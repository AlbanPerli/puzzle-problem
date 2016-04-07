//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
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