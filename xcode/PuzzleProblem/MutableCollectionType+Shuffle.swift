//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//


// Extend the `MutableCollectionType` to support shuffle
extension MutableCollectionType where Index == Int {
    ///
    /// Shuffle the elements of `self` in-place.
    /// - Author: [Nate Cook](http://stackoverflow.com/a/24029847)
    ///
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(cs_arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

// Extend the `CollectionType` to support shuffle
extension CollectionType {
    ///
    /// Return a copy of `self` with its elements shuffled
    /// - Returns: A copy of `self` with its elements shuffled
    /// - Author: [Nate Cook](http://stackoverflow.com/a/24029847)
    ///
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}