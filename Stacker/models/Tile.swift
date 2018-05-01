//
//  Tile.swift
//  Stacker
//
//  Created by Bruce Ricketts on 4/23/18.
//  Copyright © 2018 Bruce Ricketts. All rights reserved.
//

import Foundation
import Swiftz

struct Tile: Monoid, Equatable {
    static var mempty = Tile(value: 0)
    let value: Int
    
    func op(_ other: Tile) -> Tile {
        return Tile(value: value + other.value)
    }
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.value == rhs.value
    }
}
