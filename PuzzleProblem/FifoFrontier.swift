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
        return self.collection.removeFirst()
    }
}
