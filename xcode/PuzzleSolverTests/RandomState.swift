//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           25/03/2016
//

///
/// Generates a random state
/// - Parameter rows: The number of rows this state will have
/// - Parameter cols: The number of columns this state will have
/// - Parameter isSolvable: Whether or not the state generated is solvable or not.
///                         If `false` is provided here, then only insolvable states
///                         will be generated. Default is `true`.
/// - Returns: A new random state
///
func randomState(rows: Int, cols: Int? = nil, isSolvable: Bool = true) -> State {
    let cols = cols ?? rows
    let width = cols
    let height = rows
    let isOdd = width % 2 != 0
    // Generate a sequence of random numbers width * height long
    func generateState() -> State {
        let highestValue = width * height
        var data: [Int] = Array(count: highestValue, repeatedValue: -1)
        // Generate random sequence of numbers from [0..highest]
        data.enumerate().forEach { (index: Int, element: Int) -> () in
            let highestValue = UInt32(highestValue)
            var num = Int(cs_arc4random_uniform(highestValue))
            // Must be unique
            while data.contains(num) {
                num = Int(cs_arc4random_uniform(highestValue))
            }
            data[index] = num
        }
        return State(sequence: data, height: height, width: width)
    }
    var state = generateState()
    while (isSolvable && !state.isSolvable) || (!isSolvable && state.isSolvable) {
        state = generateState()
    }
    return state
}
