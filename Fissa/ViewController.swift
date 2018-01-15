//
//  ViewController.swift
//  Fissa
//
//  Created by Jaap Wijnen on 06/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
    
    var metalView: MTKView!
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView = self.view as! MTKView
        metalView.device = MTLCreateSystemDefaultDevice()
        
        renderer = Renderer(withMTKView: metalView)
        let scene = SintScene(withMTKView: metalView)
        renderer.scene = scene
        
        renderer.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        
        metalView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: SceneDelegate {
    func transition(to scene: Scene) {
        scene.size = metalView.frame.size
        scene.sceneDelegate = self
        renderer.scene = scene
    }
}



