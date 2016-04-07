//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//

///
/// Sorts a search by randomly inserting nodes to the frontier
///
struct BogosortSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Bogosort Search"
    static var code: String = "BOGO"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Bogosort Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a randomised frontier
        self.frontier = RandomisedFrontier()
    }
}
