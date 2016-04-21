//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// Depth First Search is an *uninformed* search method that traverses nodes in a LIFO
/// fashion, that is, it expands the deepest unexpanded node and keeps expanding descendents
/// of that node until a leaf node is encountered
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(bm)
///
class DepthFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth First Search"
    static var code: String = "DFS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
    }

}