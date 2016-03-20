//
//  State.swift
//  assignment-1
//
//  Created by Alex on 17/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// MARK: Define typealiases and constants

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

// MARK: Define state struct

///
/// Abstracts a current state of the search tree
///
struct State: Equatable, CustomDebugStringConvertible {
    // MARK: Implement CustomStringConvertible
    var debugDescription: String {
        var result = ""
        for (rowIdx, row) in self.matrix.enumerate() {
            for (colIdx, _) in row.enumerate() {
                let value: Int = (self[rowIdx,colIdx] ?? -1)
                result += "\(value) "
            }
        }
        return result.substringToIndex(result.endIndex.predecessor())
    }

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
                results.append(Action(movingPosition: position, inDirection: .Up))
            }
            // Not the first column? Then we can move left
            if !firstCol {
                results.append(Action(movingPosition: position, inDirection: .Left))
            }
            // Not the last row? Then we can move down
            if !lastRow {
                results.append(Action(movingPosition: position, inDirection: .Down))
            }
            // Not the last column? Then we can move right
            if !lastCol {
                results.append(Action(movingPosition: position, inDirection: .Right))
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

    // MARK: Define subscript and state access methods

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

    // MARK: Define action-related inputs to the state
    
    ///
    /// Checks if the provided action can be made
    ///
    /// - Parameter action: The specified action to make
    /// - Returns: A boolean indicating if the action is valid
    ///
    func isValidAction(action: Action) -> Bool {
        // The two tiles we are moving
        let movingTiles = (self[action.position], self[action.inverse.position])
        // Only valid if all tiles exist in movingTiles and at least one of the
        // tiles are the blank tile
        return  (movingTiles.0 != nil && movingTiles.1 != nil) &&
                (movingTiles.0 == kEmptyTile || movingTiles.1 == kEmptyTile)
    }

    ///
    /// Swaps a tile in the state model from one position to the next
    ///
    /// - Parameter firstPosition: The first element's pos in the pair to swap
    /// - Parameter secondPosition: The second element's pos in the pair to swap
    /// - Returns a new `Matrix` representing the state after the swap
    ///
    private func swapTileAt(firstPosition: Position, with secondPosition: Position) -> Matrix {
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
    /// - Parameter action: The action to perform
    /// - Returns: A new state, or `nil` if the state could not be moved due to
    //             an invalid action
    ///
    func performAction(action: Action) -> State? {
        // Ensure this is a valid move, otherwise return nil
        if !self.isValidAction(action) {
            return nil
        }
        // Use the inverse action to find which positions we are moving
        let newMatrix = self.swapTileAt(action.position, with: action.inverse.position)
        return State(matrix: newMatrix, fromAction: action)
    }
}

// MARK: Implement Equatable protocol

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