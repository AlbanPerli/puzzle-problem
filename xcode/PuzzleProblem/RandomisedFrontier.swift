//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//

///
/// A randomised frontier pushes a collection of nodes in a randomised order
///
struct RandomisedFrontier: Frontier {
    var collection: [Node] = []
    
    mutating func pop() -> Node? {
        // Dequeue element at start of array
        return self.isEmpty ? nil : self.collection.removeFirst()
    }
    
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        // Enqueue collection to the end of the queue in a shuffled order
        self.collection.appendContentsOf(nodes.shuffle())
    }
}