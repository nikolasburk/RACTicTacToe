//
//  GridView.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation
import UIKit

typealias GridViewCell = UIImageView

let gridSize = (3, 3)


class GridView : UIView {

    var gridViewCells: [GridViewCell] = []
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let cells = createCells(frame)
        self.gridViewCells = cells
        print("created \(self.gridViewCells.count) cells")
        addCellsToView(self.gridViewCells)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addCellsToView(cells: [GridViewCell]) {
        for cell in cells {
            self.addSubview(cell)
        }
    }

}


func createCells(frame: CGRect, numCells: Int = 9, var cells: [GridViewCell] = []) -> [GridViewCell] {
    if cells.count == numCells {
        return cells
    }
    let scaleFactor: CGFloat = 3
    let cellSize = frame.scaleSize(withXFactor: scaleFactor, yFactor: scaleFactor)
    let origin = determineOrigin(withIndex: cells.count, size: cellSize)
    let targetFrame = CGRectMake(origin.x, origin.y, cellSize.width, cellSize.height)
    let newCell = GridViewCell(frame: targetFrame)
    newCell.image = UIImage(named: "cross")
    cells.append(newCell)
    return createCells(frame, numCells: 9, cells: cells)
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