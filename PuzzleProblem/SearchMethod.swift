//
//  SearchMethod.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A search method protocol ensures each implementation of SearchMethod
/// provides a `searchCode` and `name`
///
protocol SearchMethod {
    ///
    /// The code of this search method used to run the search method
    ///
    var code: String { get set }
    ///
    /// The name of this search method
    ///
    var name: String { get set }
}
