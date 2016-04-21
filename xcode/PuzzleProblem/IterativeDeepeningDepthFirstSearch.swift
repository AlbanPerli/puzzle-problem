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
class DepthLimitedSearch: IterativeDeepeningSearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth Limited Search"
    static var code: String = "DLS"
    var goalState: State
    var frontier: Frontier
    
    // MARK: Implement IterativeDeepeningSearchMethod
    var nodeThresholdComparatorValue: (Node) -> Int = { node in
        // Just compares against a node's path cost (i.e., it's depth in the context
        // of the n by m puzzle solver)
        return node.pathCost
    }
    var threshold: Int
    var fallbackFrontier = FifoFrontier()
    
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