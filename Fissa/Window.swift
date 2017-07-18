//
//  Window.swift
//  Fissa
//
//  Created by Jaap Wijnen on 08/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import Cocoa

class Window: NSWindow {
    
    var viewController: ViewController {
        return contentViewController as! ViewController
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        acceptsMouseMovedEvents = true
    }
    
    override func keyDown(with event: NSEvent) {
        viewController.renderer.scene?.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        viewController.renderer.scene?.keyUp(with: event)
    }
    
    override func mouseMoved(with event: NSEvent) {
        viewController.renderer.scene?.mouseMoved(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        viewController.renderer.scene?.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        viewController.renderer.scene?.mouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        viewController.renderer.scene?.mouseDragged(with: event)
    }
}
