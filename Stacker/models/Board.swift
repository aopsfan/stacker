//
//  Board.swift
//  Stacker
//
//  Created by Bruce Ricketts on 4/23/18.
//  Copyright © 2018 Bruce Ricketts. All rights reserved.
//

import Foundation
import Swiftz

func map<A, B>(_ f: (A) -> (B), _ array: [A]) -> [B] {
    return array.map(f)
}

extension Int {
    func times<T>(_ f: (Int) -> (T)) -> [T] {
        return (0..<self).map(f)
    }
}

extension Array {
    func put(_ element: Element, at index: Int) -> [Element] {
        return enumerated().map { $0 == index ? element : $1 }
    }
}

struct Position: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Int...) {
        row = elements[0]
        column = elements[1]
    }
    
    let row: Int
    let column: Int
}

private func transpose(_ rows: [Row]) -> [Row] {
    return (0..<rows[0].size).map { index in
        return Row(rows.map { $0.at(index: index) })
    }
}

struct Board: Equatable {
    private let rows: [Row]
    
    static let transposeR = rows(_:)
        >>> { $0.reversed() }
        >>> transpose(_:)
        >>> Board.init(_:)
    
    static let transposeL = rows(_:)
        >>> transpose(_:)
        >>> { $0.reversed() }
        >>> Board.init(_:)
    
    static let foldl = rows(_:)
        >>> curry(map)(Row.foldl(_:))
        >>> Board.init(_:)
    
    static let foldr = rows(_:)
        >>> curry(map)(Row.foldr(_:))
        >>> Board.init(_:)
    
    static let foldu = Board.transposeL
        >>> Board.mapEachRow(Row.foldl(_:))
        >>> Board.transposeR

    static let foldd = Board.transposeR
        >>> Board.mapEachRow(Row.foldl(_:))
        >>> Board.transposeL
    
    init(rows: Int, columns: Int) {
        self.rows = rows.times { _ in return Row(size: columns) }
    }
    
    init(_ rows: [Row]) {
        self.rows = rows
    }
    
    func tile(at position: Position) -> Tile? {
        return rows[position.row].at(index: position.column)
    }
    
    static func mapEachRow(_ f: @escaping (Row) -> Row) -> (Board) -> Board {
        return rows(_:) >>> curry(map)(f) >>> Board.init(_:)
    }
    
    static func place(_ board: Board, tile: Tile, at position: Position) -> Board {
        let row = Row.place(board.rows[position.row],
                            tile: tile, at: position.column)
        return Board(board.rows.put(row, at: position.row))
    }
    
    private static func rows(_ board: Board) -> [Row] {
        return board.rows
    }
    
    // MARK - Equatable
    
    static func ==(lhs: Board, rhs: Board) -> Bool {
        return lhs.rows == rhs.rows
    }
    
}
