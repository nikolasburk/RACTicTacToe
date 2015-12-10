//
//  NSTimer+Extensions.swift
//  RxTicTacToe
//
//  Created by Nikolas Burk on 09/12/15.
//  Copyright © 2015 Nikolas Burk. All rights reserved.
//

import Foundation


// taken from https://gist.github.com/natecook1000/b0285b518576b22c4dc8 (Nate Cook)
extension NSTimer {
    
    // - Returns: The newly-created `NSTimer` instance.
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    // - Returns: The newly-created `NSTimer` instance.
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}
