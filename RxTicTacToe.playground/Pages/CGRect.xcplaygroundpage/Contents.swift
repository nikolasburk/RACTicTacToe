import UIKit


typealias GridViewCell = UIImageView

class GridView : UIView {
    
    var gridViewCells: [GridViewCell] = []
    
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let cells = createCells(frame)
        self.gridViewCells = cells
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

func createCells(frame: CGRect, numCells: Int = 9, var cells: [GridViewCell] = []) -> [GridViewCell] {
    if cells.count == numCells {
        return cells
    }
    let scaleFactor = frame.height/3
    let cellSize = frame.scaleSize(withXFactor: scaleFactor, yFactor: scaleFactor)
    let origin = determineOrigin(withIndex: cells.count, size: cellSize)
    let targetFrame = CGRectMake(origin.x, origin.y, cellSize.width, cellSize.height)
    let newCell = GridViewCell(frame: targetFrame)
    return cells.append(newCell)
}


extension CGRect {
    
    func scaleSize(withXFactor xFactor: CGFloat, yFactor: CGFloat) -> CGSize {
        return CGSize(width: self.size.width*xFactor, height: self.size.height*yFactor)
    }
    
}

let gridSize = (3, 3) // 3x3 cells
func determineOrigin(withIndex index: Int, size: CGSize) -> CGPoint {
    let row = index / gridSize.1 // determine target row
    let y = CGFloat(row)*size.height // calculate y
    let col = index % gridSize.0 // determine target column
    let x = CGFloat(col)*size.width
    return CGPoint(x: x, y: y)
}
