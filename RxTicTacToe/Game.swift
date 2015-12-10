//
//  Game.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation

struct Player {
    let name: String
    let marker: Marker
}

struct Game {
    
    let board: Board
    let players: (Player, Player)
    
    init(players: (Player, Player), board: Board = Board()) {
        self.players = players
        self.board = board
    }

}