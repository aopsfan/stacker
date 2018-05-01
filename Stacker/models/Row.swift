//
//  Row.swift
//  Stacker
//
//  Created by Bruce Ricketts on 4/23/18.
//  Copyright © 2018 Bruce Ricketts. All rights reserved.
//

import Foundation
import Swiftz

func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count { return false }
    for (l, r) in zip(lhs, rhs) {
        if l != r { return false }
    }
    return true
}

func compact<T>(_ array: [T?]) -> [T] {
    return array.reduce([]) { $1 == nil ? $0 : $0 + [$1!] }
}

private func foldl(_ tiles: [Tile?]) -> [Tile?] {
    let filtered = compact(tiles)
    
    let tileGroups: [[Tile]] = filtered.reduce([]) { result, tile in
        guard let last = result.last
            else { return [[tile]] }
        
        guard last.count < 2
            else { return result + [[tile]] }
        
        if last[0] == tile {
            return result.dropLast() + [(last + [tile])]
        } else {
            return result + [[tile]]
        }
    }
    
    let combinedTiles: [Tile] = tileGroups.map(mconcat(t:))
    let emptyTiles: [Tile?] = (tiles.count - combinedTiles.count).times { _ in return nil }
    return combinedTiles + emptyTiles
}

private func foldr(_ tiles: [Tile?]) -> [Tile?] {
    return foldl(tiles.reversed()).reversed()
}

struct Row: Equatable {
    typealias RowOperation = ([Tile?]) -> [Tile?]
    let tiles: [Tile?]
    
    var size: Int {
        return tiles.count
    }
    
    init(size: Int) {
        tiles = size.times { _ in return nil }
    }
    
    init(_ tiles: [Tile?]) {
        self.tiles = tiles
    }
    
    func at(index: Int) -> Tile? {
        return tiles[index]
    }
    
    static func place(_ row: Row, tile: Tile, at index: Int) -> Row {
        return Row(row.tiles.put(tile, at: index))
    }
    
    static func foldl(_ row: Row) -> Row {
        return fold(Stacker.foldl(_:), row)
    }
    
    static func foldr(_ row: Row) -> Row {
        return fold(Stacker.foldr(_:), row)
    }
    
    private static func fold(_ f: RowOperation, _ row: Row) -> Row {
        return Row(f(row.tiles))
    }
    
    // MARK - Equatable
    
    static func ==(lhs: Row, rhs: Row) -> Bool {
        return lhs.tiles == rhs.tiles
    }
}
