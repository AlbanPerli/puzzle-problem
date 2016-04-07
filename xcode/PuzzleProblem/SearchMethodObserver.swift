//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// Observes search methods that are currently traversing and notifies all subscribers
///
struct SearchMethodObserver {
    ///
    /// Singleton shared instance
    ///
    static var sharedObserver = SearchMethodObserver()
    ///
    /// List of subscribers that the observer notifies
    ///
    var subscribers: [SearchMethodSubscriber] = []
    ///
    /// Notifies all subscribers of a node traversal
    /// - Parameter node: The node that was just traversed
    /// - Parameter isSolved: Whether or not this node is the goal node
    ///
    func notify(node: Node, isSolved: Bool) {
        for sub in subscribers {
            sub.didTraverseNode(node, isSolved: isSolved)
        }
    }
}

///
/// A subscriber to a search method observer
/// - Remarks: Once implemented, must add `self` to the `sharedObserver`'s subscribers
///            array, i.e.:
/// ```
/// SharedMethodObserver.sharedObserver.subscribers.append(self)
/// ```
///
protocol SearchMethodSubscriber {
    ///
    /// Notification event when a node was just traversed
    /// - Parameter node: The node that was just traversed
    /// - Parameter isSolved: Whether or not this node is the goal node
    ///
    func didTraverseNode(node: Node, isSolved: Bool)
}
