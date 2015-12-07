//
//  GridView.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 07/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation
import UIKit

class GridView : UIView {
        
    var cells: [UIView] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("init")
    }
    
}
