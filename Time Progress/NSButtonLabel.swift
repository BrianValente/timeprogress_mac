//
//  NSCursorLabel.swift
//  Time Progress
//
//  Created by Brian Valente on 11/20/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Cocoa

class NSButtonLabel: NSTextField {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: NSCursor.pointingHand)
    }
    
}
