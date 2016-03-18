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
struct State: Equatable {
    ///
    /// Defines possible errors when a state is incorrectly accessed
    ///
    enum InvalidAccessError: ErrorType {
        case NegativeAccess
        case OutOfBounds
    }

    ///
    /// Returns the width of the state
    ///
    var width: Int {
        // If there is no height, then there is no width
        if self.height == 0 {
            return 0
        }
        return self.matrix[0].count
    }

    ///
    /// Returns the height of the state
    ///
    var height:Int {
        return self.matrix.count
    }

    ///
    /// Returns the position of the blank tile in the current state
    ///
    var blankTilePosition: Position? {
        for (rowIdx, row) in self.matrix.enumerate() {
            for (colIdx, _) in row.enumerate() {
                let pos: Position = (rowIdx, colIdx)
                if let element = self[pos] where element == kEmptyTile {
                    return pos
                }
            }
        }
        return nil
    }

    ///
    /// Calculates possible actions to move the blank tile toward the goal state
    ///
    /// - Remarks: When the blank tile can move in all directions, the tile will
    ///            attempt to move `Up`, then `Left`, then `Down`, then `Right`
    ///
    var possibleActions: [Action] {
        var results: [Action] = []
        // Get the position of the blank tile
        if let position = self.blankTilePosition {
            let firstRow = position.row == 0
            let lastRow  = position.row == self.height - 1
            let firstCol = position.col == 0
            let lastCol  = position.col == self.width - 1
            // Not the first row? Then we can move up
            if !firstRow {
                results.append(Action.move(position, inDirection: .Up))
            }
            // Not the first column? Then we can move left
            if !firstCol {
                results.append(Action.move(position, inDirection: .Left))
            }
            // Not the last row? Then we can move down
            if !lastRow {
                results.append(Action.move(position, inDirection: .Down))
            }
            // Not the last column? Then we can move right
            if !lastCol {
                results.append(Action.move(position, inDirection: .Right))
            }
        }
        return results
    }

    ///
    /// The action which lead to this state
    ///
    let leadingAction: Action?

    ///
    /// The internal data structure
    ///
    private let matrix: Matrix
    
    ///
    /// Initialise the state model with a provided matrix structure
    /// - Parameter matrix: An representation of the state
    ///
    init(matrix: Matrix) {
        self.matrix = matrix
        self.leadingAction = nil
    }

    ///
    /// Initialise the state model with a provided matrix structure
    /// - Parameter matrix: An representation of the state
    /// - Parameter action: An action which lead to this state
    ///
    init(matrix: Matrix, fromAction action: Action) {
        self.matrix = matrix
        self.leadingAction = action
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
    /// Allows for subscript array specifying `Position` tuple, i.e.:
    ///
    /// ```
    /// state[pos]
    /// ```
    ///
    /// - Parameter position: The position to access
    /// - Returns: An optional integer representing the element at the position.
    ///            If `nil`, then there is no element at the provided position.
    ///
    subscript (pos: Position) -> Int? {
        return self[pos.row, pos.col]
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
        let swapAction: Position = Action.move(position, inDirection: direction).position
        // If the element at the updated row and column is the empty tile
        // then it is a valid move
        return self[swapAction.row, swapAction.col] == kEmptyTile
    }

    ///
    /// Swaps an element in the state model from one position to the next
    ///
    /// - Parameter firstPosition: The first element's pos in the pair to swap
    /// - Parameter secondPosition: The second element's pos in the pair to swap
    /// - Returns a new `Matrix` representing the state after the swap
    ///
    private func swapElementAt(firstPosition: Position, with secondPosition: Position) -> Matrix {
        // Create new matrix for new state post swap
        var newMatrix = self.matrix
        // Swap second element for first element using the swap function
        swap(&newMatrix[firstPosition.row][firstPosition.col],
             &newMatrix[secondPosition.row][secondPosition.col])
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
    func performAction(action: Action) -> State? {
        let position = action.position
        let direction = action.direction
        if !isValidMove(position, direction: direction) {
            return nil
        }
        // The swap position is the current position moved in the new direction
        let action = Action.move(position, inDirection: direction)
        // Swap the two elements at position and newPosition
        let newMatrix = swapElementAt(position, with: action.position)
        return State(matrix: newMatrix, fromAction: action)
    }
}

///
/// Implement `Equatable` protocol for `State` which compares each comparator's
/// internal matrix
///
func ==(lhs: State, rhs: State) -> Bool {
    for (rowIdx, row) in lhs.matrix.enumerate() {
        for (colIdx, _) in row.enumerate() {
            if lhs[rowIdx, colIdx] != rhs[rowIdx, colIdx] {
                return false
            }
        }
    }
    return true
}