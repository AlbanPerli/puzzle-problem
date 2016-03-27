//
//  FifoFrontier.swift
//  PuzzleProblem
//
//  Created by Alex on 20/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A first-in-first-out frontier ensures that each node that the node that has
/// been in the frontier longest is removed first
///
struct FifoFrontier: Frontier {
    var collection: [Node] = []

    mutating func pop() -> Node? {
        // Dequeue element at start of array
        return self.isEmpty ? nil : self.collection.removeFirst()
    }

    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        // Enqueue collection to the end of the queue
        self.collection.appendContentsOf(nodes)
    }
}
