//
//  StackerTests.swift
//  StackerTests
//
//  Created by Bruce Ricketts on 4/23/18.
//  Copyright © 2018 Bruce Ricketts. All rights reserved.
//

import XCTest
@testable import Stacker

class StackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardTransposeRight() {
        let row1 = Row([Tile(value: 1), Tile(value: 2), Tile(value: 3)])
        let row2 = Row([Tile(value: 4), Tile(value: 5), Tile(value: 6)])
        
        let board = Board([row1, row2])
        
        let transposeRow1 = Row([Tile(value: 4), Tile(value: 1)])
        let transposeRow2 = Row([Tile(value: 5), Tile(value: 2)])
        let transposeRow3 = Row([Tile(value: 6), Tile(value: 3)])
        let transposed = Board([transposeRow1, transposeRow2, transposeRow3])
        XCTAssertEqual(Board.transposeR(board), transposed)
    }
    
    func testBoardTransposeLeft() {
        let row1 = Row([Tile(value: 1), Tile(value: 2), Tile(value: 3)])
        let row2 = Row([Tile(value: 4), Tile(value: 5), Tile(value: 6)])
        
        let board = Board([row1, row2])
        
        let transposeRow1 = Row([Tile(value: 3), Tile(value: 6)])
        let transposeRow2 = Row([Tile(value: 2), Tile(value: 5)])
        let transposeRow3 = Row([Tile(value: 1), Tile(value: 4)])
        let transposed = Board([transposeRow1, transposeRow2, transposeRow3])
        XCTAssertEqual(Board.transposeL(board), transposed)
    }
    
    func testBoardFoldUp() {
        let row1 = Row([Tile(value: 1), nil,            Tile(value: 3)])
        let row2 = Row([Tile(value: 4), Tile(value: 5), Tile(value: 3)])
        let row3 = Row([Tile(value: 4), Tile(value: 5), Tile(value: 6)])
        
        let board = Board([row1, row2, row3])
        
        let foldedRow1 = Row([Tile(value: 1), Tile(value: 10), Tile(value: 6)])
        let foldedRow2 = Row([Tile(value: 8), nil,             Tile(value: 6)])
        let foldedRow3 = Row([nil,            nil,             nil])
        
        let foldedBoard = Board([foldedRow1, foldedRow2, foldedRow3])
        
        XCTAssertEqual(Board.foldu(board), foldedBoard)
    }
    
    func testTiles() {
        let position: Position = [0, 1]
        let board = Board(rows: 4, columns: 5)
        
        let newBoard = Board.place(board, tile: Tile(value: 23), at: position)
        XCTAssertNotNil(newBoard.tile(at: position))
    }
    
    func testFoldingRow() {
        let row = Row([nil, Tile(value: 1), Tile(value: 1), Tile(value: 1), Tile(value: 1), nil, Tile(value: 1), Tile(value: 2), nil, Tile(value: 1), Tile(value: 1), Tile(value: 2)])
        
        let expectedRow = Row([Tile(value: 2), Tile(value: 2), Tile(value: 1), Tile(value: 2), Tile(value: 2), Tile(value: 2), nil, nil, nil, nil, nil, nil])
        XCTAssertEqual(Row.foldl(row), expectedRow)
    }
    
}
