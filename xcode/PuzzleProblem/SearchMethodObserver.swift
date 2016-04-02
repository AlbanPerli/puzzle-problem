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
    static var sharedObserver = SearchMethodObserver()
    var subscribers: [SearchMethodSubscriber] = []
    func notify(node: Node, isSolved: Bool) {
        for sub in subscribers {
            sub.didTraverseNode(node, isSolved: isSolved)
        }
    }
}

protocol SearchMethodSubscriber {
    func didTraverseNode(node: Node, isSolved: Bool)
}
