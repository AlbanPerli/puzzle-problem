//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

import Darwin

///
/// Generates a matrix from a sequence list provided
/// - Parameter seq: Sequence to generate
/// - Parameter width: Width of sequence
/// - Returns: A new `width` by `width` matrix
///
func generateMatrix(seq: [Int], width: Int) -> Matrix {
    var data = seq
    let matrix = (0...width-1).map { index -> [Int] in
        return (0...width-1).reduce([]) { (memo, value) -> [Int] in
            return memo + [data.popLast()!]
        }
    }
    return matrix
}

///
/// Validates an `n` by `n` state sequence generated using solvability proofs
/// - Parameter seq: Sequence to validate
/// - Parameter width: Width of sequence
/// - Remarks: Refer to [proof](http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html)
///
func validateSequence(seq: [Int], width: Int) -> Bool {
    let isOdd = width % 2 != 0
    let inversions = seq.enumerate().reduce(0) { (memo, value) -> Int in
        let startAt = value.index + 1
        let element = value.element
        var numInversionsForElement = 0
        for num in seq.suffixFrom(startAt) {
            if element > num && num != kEmptyTile {
                numInversionsForElement += 1
            }
        }
        return memo + numInversionsForElement
    }
    let evenInversions = inversions % 2 == 0
    var matrix = generateMatrix(seq, width: width)
    var stateFromSequence = State(matrix: matrix)
    var posOfBlank = stateFromSequence.blankTilePosition
    while posOfBlank == nil {
        matrix = generateMatrix(seq, width: width)
        stateFromSequence = State(matrix: matrix)
        posOfBlank = stateFromSequence.blankTilePosition
    }
    let rowFromBottom = (stateFromSequence.height - 1) - posOfBlank!.row
    let blankOnOddRowFromBottom = rowFromBottom % 2 != 0
    // ( (grid width odd ) && (#inversions even) )  ||
    // ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
    return ( isOdd && evenInversions ) || ( !isOdd && (blankOnOddRowFromBottom == evenInversions) )
}

///
/// Generates a random state that is no larger than the `width` provides
/// - Parameter width: The maximum allowable generated width
/// - Parameter isValid: Whether or not the state generated is valid. If `false` is provided
///                      here, then only invalid states will be generated. Default is `true`.
/// - Returns: A new random state that is always solvable in a shuffled order
/// - Remarks: The state is always an `n` by `n` state due to solvability
///            constraints
///
func randomState(width inputWidth: UInt32, isValid: Bool = true) -> State {
    let width = Int(arc4random_uniform(inputWidth) + 2) // at least 2x2
    let isOdd = width % 2 != 0
    // Generate a sequence of random numbers width^2 long
    func generateSequence() -> [Int] {
        let highest = width * width
        var data: [Int] = Array(count: highest, repeatedValue: -1)
        // Generate random sequence of numbers from [0..highest]
        data.enumerate().forEach { (index: Int, element: Int) -> () in
            let uintHighest = UInt32(highest)
            var num = Int(arc4random_uniform(uintHighest))
            while data.contains(num) {
                num = Int(arc4random_uniform(uintHighest))
            }
            data[index] = num
        }
        return data
    }
    var seq = generateSequence()
    while (isValid && !validateSequence(seq, width: width)) ||
          (!isValid && validateSequence(seq, width: width)) {
        seq = generateSequence()
    }
    return State(sequence: seq, height: width, width: width)
}

