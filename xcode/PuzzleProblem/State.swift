//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           17/03/2016
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

// MARK: Define state class

///
/// Abstracts a current state of the search tree
///
class State: Equatable, Hashable, CustomDebugStringConvertible {
    // MARK: Implement Hashable

    var hashValue: Int {
        // Implement hash from sequence using bit shifting
        // See http://codereview.stackexchange.com/a/111573
        return self.sequence.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }


    // MARK: Implement CustomStringConvertible

    var debugDescription: String {
        return self.matrix.debugDescription
    }

    // MARK: Invalid access errors

    ///
    /// Defines possible errors when a state is incorrectly accessed
    ///
    enum InvalidAccessError: ErrorType {
        case NegativeAccess
        case OutOfBounds
    }

    // MARK: Properties

    ///
    /// Returns the width of the state
    ///
    let width: Int

    ///
    /// Returns the height of the state
    ///
    let height: Int

    ///
    /// Returns the position of the blank tile in the current state
    ///
    var blankTilePosition: Position? {
        return self.positionOf(kEmptyTile)
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
    /// Elements in the state represented as a sequence
    /// - Remarks: If we have a 3x3 state:
    ///
    /// ```
    /// 1 2 3
    /// 4 5 6
    /// 7 8 9
    /// ```
    ///
    /// This would be equivalent to
    ///
    /// ```
    /// [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
    /// ```
    ///
    let sequence: [Int]

    ///
    /// Property to compute if a state is valid
    /// - Remarks: Refer to the proof written by
    ///            [Kevin Gong](http://kevingong.com/Math/SixteenPuzzle.html)
    ///
    var isValid: Bool {
        // Immediately invalid if no width or height
        if self.height == 0 || self.width == 0 {
            return false
        }

        // Parity of n (width)
        let nIs = (
            even: self.width % 2 == 0,
            odd:  self.width % 2 != 0
        )

        // Calculate inversions
        let inversions = self.sequence.enumerate().reduce(0) { (memo, value) -> Int in
            let startAt = value.index + 1
            let element = value.element
            var numInversionsForElement = 0
            for num in self.sequence.suffixFrom(startAt) {
                if element > num && num != kEmptyTile {
                    numInversionsForElement += 1
                }
            }
            return memo + numInversionsForElement
        }

        // Parity of the inversions
        let inversionsIs = (
            even: inversions % 2 == 0,
            odd:  inversions % 2 != 0
        )

        // Position of blank tile
        guard let posOfBlankTile = self.blankTilePosition else {
            // Immediately invalid if no blank tile!
            return false
        }

        // Row of the blank tile (i)
        let rowOfBlankTile = posOfBlankTile.row

        // ...from bottom row (m - i)
        let rowFromBottom = (self.height - 1) - rowOfBlankTile
        
        // Parity of the blank row, i.e., parity of (m - i)
        // We consider the parity of 0 to be odd and must enforce this
        // as the swift compiler considers 0 to be even
        let blankOnRowThatIs = (
            even: rowFromBottom == 0 ? false : rowFromBottom % 2 == 0,
            odd:  rowFromBottom == 0 ? true  : rowFromBottom % 2 != 0
        )
        
        // THEOREM 1: If n is odd, then every legal configuration corresponds to a 
        //            sequence with an even number of inversions
        let theorm1 = nIs.odd && inversionsIs.even
        // THEOREM 2: If n is even, then every legal configuration with the hole in the
        //            i'th row, where m - i is even corresponds sequence with an even
        //            number of inversions
        let theorm2 = nIs.even && blankOnRowThatIs.even && inversionsIs.even
        // THEOREM 3: If n is even, then every legal configuration with the hole in the
        //            i'th row where m - i is odd corresponds sequence with an odd
        //            number of inversions.
        let theorm3 = nIs.even && blankOnRowThatIs.odd && inversionsIs.odd
        
        // One of the theorms must be true to hold as a valid state
        return theorm1 || theorm2 || theorm3
    }

    ///
    /// Matrix generated from sequence
    ///
    var matrix: Matrix {
        var matrix = Matrix()
        for row in 0...self.height - 1 {
            var rowData = [Int]()
            for col in 0...self.width - 1 {
                rowData.append(self[row,col]!)
            }
            matrix.append(rowData)
        }
        return matrix
    }

    // MARK: Initialisers

    ///
    /// Initialise the state model with a provided width, height and sequence of numbers
    /// - Parameter sequence: A sequence of numbers representing the state
    /// - Parameter height: The number of rows the state will have
    /// - Parameter width: The number of columns the state will have
    /// - Parameter action: An action which lead to this state, or `nil` if no
    ///                     leading action (default is `nil`)
    ///
    init(sequence: [Int], height: Int, width: Int, fromAction action: Action? = nil) {
        self.sequence = sequence
        self.height = height
        self.width = width
        self.leadingAction = action
    }

    ///
    /// Initialise the state model with a provided matrix structure
    /// - Parameter matrix: An representation of the state
    /// - Parameter action: An action which lead to this state, or `nil` if no
    ///                     leading action (default is `nil`)
    ///
    convenience init(matrix: Matrix, fromAction action: Action? = nil) {
        let height = matrix.count
        let width = height == 0 ? 0 : matrix[0].count
        self.init(sequence: matrix.flatMap({$0}),
                  height: height,
                  width: width,
                  fromAction: action)
    }

    // MARK: Utilities

    ///
    /// Converts position to index
    /// - Paramater: Position to convert
    /// - Returns: New index representing that position
    ///
    private func positionToIndex(position: Position) -> Int {
        return position.row * self.width + position.col
    }

    // MARK: Subscripts

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
    /// - Throws: `State.InvalidAccessError` when invalid coordinates are given
    /// - Returns: An integer of the value stored
    ///
    func elementAt(position: Position) throws -> Int {
        let row = position.row
        let col = position.col
        // Must be a positive access
        if row < 0 || col < 0 {
            throw State.InvalidAccessError.NegativeAccess
        }
        // Out of range?
        if row > self.height - 1 || col > self.width - 1 {
            throw State.InvalidAccessError.OutOfBounds
        }
        // Return value from the sequence using positionToIndex:
        return self.sequence[positionToIndex(position)]
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
            return try self.elementAt((row, col))
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
    /// - Returns a new sequence representing the state after the swap
    ///
    private func swapTileAt(firstPosition: Position, with secondPosition: Position) -> [Int] {
        // Two swaps to perform
        let swapIndices = (
            first: positionToIndex(firstPosition),
            second: positionToIndex(secondPosition)
        )
        // Swap second element for first element using the swap function
        var newSequence = self.sequence
        swap(&newSequence[swapIndices.first], &newSequence[swapIndices.second])
        return newSequence
    }

    ///
    /// Finds the position of the provided tile, or `nil` if the given
    /// tile number could not be found
    /// - Parameter tile: Value of the tile to find
    /// - Returns: The position of the tile, or `nil` if the tile could not be found
    ///
    func positionOf(tile: Int) -> Position? {
        // Find the empty tile index based off of the sequence
        if let index = self.sequence.indexOf(tile) {
            let row = index / self.width
            let col = index % self.width
            return (row, col)
        }
        return nil
    }
    
    ///
    /// Performs an action on the state, returning a new state after the action
    /// has been performed
    ///
    /// - Parameter action: The action to perform
    /// - Returns: A new state
    /// - Remarks: A `fatalError` is thrown if an invalid action is applied to the state
    ///
    func performAction(action: Action) -> State {
        // Ensure this is a valid move, otherwise throw fatal error
        if !self.isValidAction(action) {
            fatalError("Apply an invalid action \(action) to state \(self)")
        }
        // Use the inverse action to find which positions we are moving
        let newSequence = self.swapTileAt(action.position, with: action.inverse.position)
        return State(sequence: newSequence,
                     height: self.height,
                     width: self.width,
                     fromAction: action)
    }

    ///
    /// Performs an action on the state, returning a new state after the action
    /// has been performed
    ///
    /// - Parameter position: The position to move
    /// - Parameter direction: Direction to move the position
    /// - Remarks: A `fatalError` is thrown if an invalid action is applied to the state
    ///
    func performActionTo(position: Position, inDirection direction: Direction) -> State {
        let action = Action(movingPosition: position, inDirection: direction)
        return self.performAction(action)
    }
}

// MARK: Implement Equatable protocol

func ==(lhs: State, rhs: State) -> Bool {
    return lhs.sequence.elementsEqual(rhs.sequence)
}