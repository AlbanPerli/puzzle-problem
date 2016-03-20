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
    mutating func push(node: Node) {
        // Enqueue element at start of array
        self.collection.insert(node, atIndex: 0)
    }

    mutating func pop() -> Node? {
        // Dequeue element at end of array
        return self.collection.popLast()
    }

    func peek() -> Node? {
        return self.collection.last
    }
}
