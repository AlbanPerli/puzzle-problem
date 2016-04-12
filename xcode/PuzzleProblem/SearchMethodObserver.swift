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
struct SearchMethodObservationCenter {
    ///
    /// Singleton shared instance
    ///
    static var sharedCenter = SearchMethodObservationCenter()
    ///
    /// List of subscribers that the observer notifies
    ///
    private var observers = [SearchMethodObserver]()
    ///
    /// Add a observer
    /// - Parameter observer: Subscriber to add
    ///
    mutating func addObserver(observer: SearchMethodObserver) {
        if !self.observers.contains({ ob -> Bool in observer === ob }) {
            self.observers.append(observer)
        }
    }
    ///
    /// Add a observer
    /// - Parameter observer: Subscriber to add
    ///
    mutating func removeObserver(observer: SearchMethodObserver) {
        guard let index = self.observers.indexOf({ ob -> Bool in
            observer === ob
        }) else {
            return
        }

        self.observers.removeAtIndex(index)
    }


    ///
    /// Notifies all subscribers of a node traversal
    /// - Parameter node: The node that was just traversed
    /// - Parameter isSolved: Whether or not this node is the goal node
    ///
    func notifyObservers(node: Node, isSolved: Bool) {
        for observer in observers {
            observer.didTraverseNode(node, isSolved: isSolved)
        }
    }
}

///
/// A observer to a search method
///
protocol SearchMethodObserver : class {
    ///
    /// Notification event when a node was just traversed
    /// - Parameter node: The node that was just traversed
    /// - Parameter isSolved: Whether or not this node is the goal node
    ///
    func didTraverseNode(node: Node, isSolved: Bool)
}
