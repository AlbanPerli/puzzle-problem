//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//

///
/// Depth Limited Seach is essentially Depth First Search, however it will stop expanding
/// the next unexpanded node if that node is beyond its threshold point, such that the maximum
/// depth of the search tree is limited to the specified `threshold`, or `t`
/// - Complexity:
///     - **Time:**  O(b<sup>t</sup>)
///     - **Space:** O(bt)
///
struct DepthLimitedSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth Limited Search"
    static var code: String = "DLS"
    var goalState: State
    var frontier: Frontier
    
    // Override the expand node and only expand if this node doesn't exceed the threshold
    func shouldTryToExpandNode(node: Node) -> Bool {
        return node.pathCost < self.threshold
    }
    
    ///
    /// The depth at which to give up exploring
    ///
    let threshold: Int
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter threshold: Do not traverse nodes whose path costs are greater than the
    ///                        threshold
    ///
    init(goalState: State, threshold: Int) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
        self.threshold = threshold
    }
}