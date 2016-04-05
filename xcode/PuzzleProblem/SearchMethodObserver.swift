//
//  SearchMethodObserver.swift
//  PuzzleProblem
//
//  Created by Alex on 2/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
