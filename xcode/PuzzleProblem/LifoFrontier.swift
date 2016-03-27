//
//  LifoFrontier.swift
//  PuzzleProblem
//
//  Created by Alex on 20/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A last-in-first-out frontier ensures that each node that the most recently
/// added node is removed first
///
struct LifoFrontier: Frontier {
    var collection: [Node] = []

    func peek() -> Node? {
        return self.collection.last
    }
    
    mutating func pop() -> Node? {
        // Pop from the end of the stack
        return self.collection.popLast()
    }

    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        // We need to reverse the queue to ensure the nodes
        // are added such that the leftmost node is inserted toward the
        // end of the array
        self.collection.appendContentsOf(nodes.reverse())
    }
}

