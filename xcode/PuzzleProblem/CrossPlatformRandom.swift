//
//  CrossPlatformRandom.swift
//  PuzzleProblem
//
//  Created by Alex on 1/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// Import for the right platform
#if os(Linux)
    import Glibc
    import SwiftShims
#else
    import Darwin
#endif

///
/// Cross platform random number generator based off of arc4random
/// - Parameter upperBound: The highest value
/// - Returns: A random number between 0 and `upperBound` - 1
/// - Author: [Marcin Krzyżanowsk](http://blog.krzyzanowskim.com/2015/12/04/swift-package-manager-and-linux-compatible/)
///
func cs_arc4random_uniform(upperBound: UInt32) -> UInt32 {
    #if os(Linux)
        return _swift_stdlib_arc4random_uniform(upperBound)
    #else
        return arc4random_uniform(upperBound)
    #endif
}

