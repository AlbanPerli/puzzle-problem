//
//  State.swift
//  assignment-1
//
//  Created by Alex on 17/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Underlying data structure is an two-dimentional array of integers
/// represented as a `row` in the first dimension and a `col` in the
/// second dimension
///
typealias Matrix = [[Int]]

///
/// The number of the empty tile element
///
let kEmptyTile: Int = 0

///
/// Abstracts a current state of the search tree
///
class State: Equatable {
    ///
    /// Defines possible errors when a state is incorrectly accessed
    ///
    enum InvalidAccessError: ErrorType {
        case NegativeAccess
        case OutOfBounds
    }

    ///
    /// The matrix containing the state
    ///
    private let matrix: Matrix
    
    ///
    /// Initialise the state model with a provided matrix structure
    /// - Parameter matrix: An representation of the state
    ///
    init(matrix: Matrix) {
        self.matrix = matrix
    }
    
    ///
    /// Finds and returns the element at the specified index
    ///
    /// - Remark:
    ///   Picture the state's elements as a 2D vector with rows on the
    ///   x plane and columns on the y plane, e.g.:
    ///
    ///   ```
    ///   1 2 3
    ///   4 5 6
    ///   7 8 9
    ///   ```
    ///   Thus, `elementAt(row: 2, col: 3)` returns `6`
    ///
    /// - Parameter position: The specified position to access
    /// - Returns: An integer of the value stored
    /// - Throws: `State.InvalidAccessError` when invalid coordinates are given
    ///
    func elementAt(position: Position) throws -> Int {
        let row = position.row
        let col = position.col
        // Must be a positive access
        if row < 0 || col < 0 {
            throw State.InvalidAccessError.NegativeAccess
        }
        // Out of bounds?
        if row > self.matrix.count - 1 || col > self.matrix[row].count - 1 {
            throw State.InvalidAccessError.OutOfBounds
        }
        // Return value from the matrix
        return self.matrix[row][col]
    }
    
    ///
    /// Allows for subscript array specifying row and column, i.e.:
    /// 
    /// ```
    /// state[row, col]
    /// ```
    ///
    /// - Parameter row: The row to look at when accessing an element
    /// - Parameter column: The column to look at when accessing an element
    /// - Returns: An optional integer representing the element at the position.
    ///            If `nil`, then there is no element at the provided position.
    ///
    subscript (row: Int, col: Int) -> Int? {
        do {
            return try self.elementAt(Position(row, col))
        } catch {
            return nil
        }
    }
    
    ///
    /// Allows for subscript array specifying position, i.e.:
    ///
    /// ```
    /// state[(row,col)]
    /// ```
    ///
    /// - Parameter position: The position in the state to return
    /// - Returns: An optional integer representing the element at the position.
    ///            If `nil`, then there is no element at the provided position.
    ///
    subscript (position: Position) -> Int? {
        do {
            return try self.elementAt(position)
        } catch {
            return nil
        }
    }
    
    ///
    /// Checks if the provided move in the given direction at the given position
    /// can be made
    ///
    /// - Parameter position: The specified position to access
    /// - Parameter direction: The specified direction to move
    /// - Returns: A boolean indicating if the move is valid
    ///
    func isValidMove(position: Position, direction: Direction) -> Bool {
        // Ask the position to move in the given direction
        let newPosition: Position = movePositionIn(position, direction: direction)
        // If the element at the updated row and column is the empty tile
        // then it is a valid move
        return self[newPosition.row, newPosition.col] == kEmptyTile
    }

    ///
    /// Swaps an element in the state model from one position to the next
    /// - Parameter firstPosition: The first element's pos in the pair to swap
    /// - Parameter secondPosition: The second element's pos in the pair to swap
    /// - Returns a new `Matrix` representing the state after the swap
    ///
    private func swapElementAt(firstPosition: Position, with secondPosition: Position) -> Matrix {
        // Create new matrix for new state post swap
        var newMatrix = matrix
        // Swap second element for first element using the swap function
        swap(&newMatrix[secondPosition.row][secondPosition.col],
             &newMatrix[firstPosition.row][firstPosition.col])
        return newMatrix
    }

    ///
    /// Performs an action on the state, returning a new state after the action
    /// has been performed
    /// 
    /// - Parameter position: The specified position to move
    /// - Parameter direction: The specified direction to move
    /// - Returns: A new state, or `nil` if the state could not be moved
    ///
    func performAction(position: Position, direction: Direction) -> State? {
        if !isValidMove(position, direction: direction) {
            return nil
        }
        // The swap position is the current position moved in the new direction
        let swapPosition = movePositionIn(position, direction: direction)
        // Swap the two elements at position and newPosition
        let newMatrix = swapElementAt(position, with: swapPosition)
        return State(matrix: newMatrix)
    }
}

///
/// Implement `Equatable` protocol for `State` which compares each comparator's
/// internal matrix
///
func ==(lhs: State, rhs: State) -> Bool {
    if lhs.matrix.count != rhs.matrix.count {
        return false
    }
    for (rowNumber, row) in lhs.matrix.enumerate() {
        for (colNumber, _) in row.enumerate() {
            let pos = Position(rowNumber, colNumber)
            return lhs[pos] == rhs[pos]
        }
    }
    return true
}