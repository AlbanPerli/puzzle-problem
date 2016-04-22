//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//

///
/// Iterative deepening depth first search Depth First Search, however it 
/// will stop expanding the next unexpanded node if that node is beyond its
/// threshold point, such that the maximum depth of the search tree is limited
/// to the specified `threshold`. When there are no more nodes in its frontier 
/// it will revert to its fallback frontier and perform a depth first
/// search on nodes it expands from its fallback; thus iterative deepening.
/// - Complexity:
///     - **Time:**  O(b<sup>d</sup>)
///     - **Space:** O(bt)
///
class IterativeDeepeningDepthFirstSearch: IterativeDeepeningSearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Iterative Deepening Depth First Search"
    static var code: String = "IDS"
    var goalState: State
    var frontier: Frontier

    // MARK: Implement IterativeDeepeningSearchMethod
    var threshold: Int
    var fallbackFrontier: FifoFrontier = FifoFrontier()
    var nodeThresholdComparatorBlock: (Node) -> Int
    
    ///
    /// Initaliser for a Iterative Deepening Depth First Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter threshold: Do not traverse nodes whose path costs are greater
    ///                        than the threshold
    ///
    init(goalState: State, threshold: Int) {
        self.goalState = goalState
        // Depth First Search uses LIFO Frontier (wrapped in a fallback supported
        // frontier)
        self.frontier = LifoFrontier()
        // Implement comparator block
        self.nodeThresholdComparatorBlock = { node in
            // IDS compares against a node's path cost (i.e., it's depth in the
            // context of the n by m puzzle solver)
            return node.pathCost
        }
        // Intialise the current threshold
        self.threshold = threshold
    }
}