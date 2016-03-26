//
//  main.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Returns textual description of all search methods available
///
func searchMethodDescriptions() -> String {
    let validMethods = [
        BreadthFirstSearch.code: BreadthFirstSearch.name,
        DepthFirstSearch.code: DepthFirstSearch.name
    ]
    let err = validMethods.reduce("") { memo, method -> String in
        memo + "  \(method.0)  run search using \(method.1)\n"
    }
    return err
}

///
/// Errors that can be caused on launch
///
enum LaunchError: ErrorType {
    case NotEnoughArgumentsProvided
    case InvalidMethodProvided
    case FileUnreadable
    case NoSizeLine
    case NoDataLines
    case UnexpectedCharacterInDataLine
    case DataLineSizeMismatch
    
    ///
    /// Textual description of each error
    ///
    var message: String {
        switch self {
        case .NotEnoughArgumentsProvided:
            return "Invalid arguments. Use `help` for more info."
        case .InvalidMethodProvided:
            return "Invalid search method provided. Expects one of\n\(searchMethodDescriptions())"
        case .FileUnreadable:
            return "File provided was unreadable"
        case .NoDataLines:
            return "Not enough data lines in file. Expects at least one after size line"
        case .NoSizeLine:
            return "Size line was missing or invalid. Expects first line to be in format NxM"
        case .UnexpectedCharacterInDataLine:
            return "Unexpected character in data line. Expects data line to be in format n n n n..."
        case .DataLineSizeMismatch:
            return "Expects data line size to match size of N*M"
        }
    }
}


///
/// Parse the provided `method` and return a search method
/// - Parameter method: A textual representation of a method's code
/// - Parameter rootState: The root state to initalise the method with
/// - Returns: A new `SearchMethod`, or `nil` if the `method` provided was invalid
///
func parseMethod(method: String, rootState: State) throws -> SearchMethod? {
    // Generate the goal state from the provided root state
    // Essentially, order the sequence from 1->n with 0 being at the end
    let goalStateSequence = rootState.sequence.sort()
    let goalState = State(sequence: goalStateSequence, height: rootState.height, width: rootState.width)
    // Match the state against the code provided
    switch method.uppercaseString {
    case DepthFirstSearch.code:
        return DepthFirstSearch(goalState: goalState)
    case BreadthFirstSearch.code:
        return BreadthFirstSearch(goalState: goalState)
    default:
        throw LaunchError.InvalidMethodProvided
    }
}

///
/// Parse the provided file to return `State`s read from the file
/// - Parameter path: The path of the file to parse
/// - Returns: The contents of the file parsed into multiple `State`s, or `nil` if the file
///            was invalid
///
func parseFile(path: String) throws -> [State]? {
    // Read the file
    guard let contents = FileParser.readFile(path) else {
        throw LaunchError.FileUnreadable
    }
    // Support Windows carriage–returns
    let splitBy = Character(contents.characters.contains("\r\n") ? "\r\n" : "\n")
    let lines = contents.characters.split(splitBy)
    let dataLines = lines.suffixFrom(1)
    // Need at least one data line
    if dataLines.count == 0 {
        throw LaunchError.NoDataLines
    }
    guard
        let size = lines.first?.split("x"),
        let width = Int(String(size[0])),
        let height = Int(String(size[1]))
    else {
        throw LaunchError.NoSizeLine
    }
    var result: [State] = []
    for line in lines {
        let sequence = line.split(" ").map { Int(String($0)) }
        if sequence.contains({ $0 == nil }) {
            throw LaunchError.UnexpectedCharacterInDataLine
        }
        if sequence.count != height * width {
            throw LaunchError.DataLineSizeMismatch
        }
        result.append(State(sequence: sequence.flatMap { $0 }, height: height, width: width))
    }
    return result
}

///
/// Entry point of the solver
///
func run() throws {
    let parameters = Process.arguments.suffixFrom(1)
    
    // Ask for help?
    if parameters.count == 0 || ["help", "h", "--help", "-help", "-h"].contains(parameters[1]) {
        print("Puzzle problem search solver\n")
        print("Usage:")
        print("  search file method")
        print("  search help\n")
        print("File:")
        print("  Expects a file whose first line describes the size of the root state(s)")
        print("  and the lines thereafter contain the shuffled sequence to solve of those")
        print("  state(s). Example:\n")
        print("    3x4")
        print("    0 1 2 3 4 5 6 7 8 9 10 11 12")
        print("    12 11 10 9 8 7 6 5 4 3 2 1 0\n\n")
        print("Methods:")
        print(searchMethodDescriptions())
        return
    }
    
    // Ensure for exactly two parameters
    if parameters.count != 2 {
        throw LaunchError.NotEnoughArgumentsProvided
    }
    
    do {
        // Try parse provided file
        let file = parameters[1]
        let rootStates = try parseFile(file)!
        
        // Validate search method
        var methods: [SearchMethod] = []
        for state in rootStates {
            let method = try parseMethod(parameters[2], rootState: state)!
            methods.append(method)
        }
    } catch let error as LaunchError {
        throw error
    }
}

do {
    try run()
} catch let error as LaunchError {
    print(error.message)
}
