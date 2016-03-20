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
    mutating func push(node: Node) {
        // Push to the top of the stack
        self.collection.append(node)
    }

    mutating func pop() -> Node? {
        // Pop from the end of the stack
        return self.collection.popLast()
    }

    func peek() -> Node? {
        return self.collection.last
    }
}

