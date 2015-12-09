//
//  GridView.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


let gridSize = (3, 3)
typealias Position = (Int, Int)

class GridViewCell: UIImageView {

    let position: Position
    let tapHandler: Position -> ()
    
    init(frame: CGRect, position: Position, tapHandler: Position -> ()) {
        self.position = position
        self.tapHandler = tapHandler
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
//        print("tapped \(self.position))")
        self.tapHandler(self.position)
    }
    
    func tapGestureRecognizer() -> UITapGestureRecognizer? {
        if let gestureRecognizers = self.gestureRecognizers {
            if let tap = gestureRecognizers.first {
                if tap.isKindOfClass(UITapGestureRecognizer) {
                    return tap as? UITapGestureRecognizer
                }
            }
        }
        return nil
    }
    
}

class GridView : UIView {

    var gridViewCells: [GridViewCell] = []
    let tapHandler: Position -> ()
    
    
    // MARK: Initialization
    
    init(frame: CGRect, tapHandler: Position -> ()) {
        self.tapHandler = tapHandler
        super.init(frame: frame)
        let cells = createCells(self)
        self.gridViewCells = cells
        print("created \(self.gridViewCells.count) cells")
        addCellsToView(self.gridViewCells)

    }

    required init?(coder aDecoder: NSCoder) {
        self.tapHandler = { p in print ("\(p)")}
        super.init(coder: aDecoder)
    }

    
    // MARK: Cell handling
    
    func addCellsToView(cells: [GridViewCell]) {
        for cell in cells {
            self.addSubview(cell)
        }
    }

    func cellsTapGestureRecognizers() -> [UITapGestureRecognizer?] {
        return gridViewCells.map {cell in cell.tapGestureRecognizer()}
    }
}


func createCells(gridView: GridView, numCells: Int = 9, var cells: [GridViewCell] = []) -> [GridViewCell] {
    if cells.count == numCells {
        return cells
    }
    let frame = gridView.frame
    let scaleFactor: CGFloat = 3
    let cellSize = frame.scaleSize(withXFactor: scaleFactor, yFactor: scaleFactor)
    let origin = determineOrigin(withIndex: cells.count, size: cellSize)
    let targetFrame = CGRectMake(origin.x, origin.y, cellSize.width, cellSize.height)
    let newCell = GridViewCell(frame: targetFrame, position: positionFromIndex(cells.count), tapHandler: gridView.tapHandler)
    newCell.image = UIImage(named: "cross")
    
    newCell.userInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: newCell, action: "handleTap:")
    newCell.addGestureRecognizer(tap)
    
    cells.append(newCell)
    return createCells(gridView, numCells: 9, cells: cells)
}

func positionFromIndex(index: Int) -> (Int, Int) {
    let row = index / gridSize.1
    let col = index % gridSize.0
    return (row, col)
}


// MARK: Determine cell size

extension CGRect {
    
    func scaleSize(withXFactor xFactor: CGFloat, yFactor: CGFloat) -> CGSize {
        return CGSize(width: self.size.width/xFactor, height: self.size.height/yFactor)
    }

}

func determineOrigin(withIndex index: Int, size: CGSize) -> CGPoint {
    let row = index / gridSize.1 
    let y = CGFloat(row)*size.height
    let col = index % gridSize.0
    let x = CGFloat(col)*size.width
    return CGPoint(x: x, y: y)
}

