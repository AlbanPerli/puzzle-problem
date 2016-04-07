//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           20/03/2016
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
        return self.isEmpty ? nil : self.collection.popLast()
    }

    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        // We need to reverse the queue to ensure the nodes
        // are added such that the leftmost node is inserted toward the
        // end of the array
        self.collection.appendContentsOf(nodes.reverse())
    }
}

