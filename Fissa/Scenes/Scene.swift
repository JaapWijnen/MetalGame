//
//  Scene.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

protocol SceneDelegate {
    func transition(to scene: Scene)
}

class Scene {
    
    var name = "Untitled Scene"
    var device: MTLDevice
    var size: CGSize
    
    var rootNode = Node(name: "Rootnode")
    
    var camera = Camera(name: "MainCamera")
    
    var light = Light()
    
    var sceneConstants = SceneConstants()
    
    var sceneDelegate: SceneDelegate?
    
    init(withMTKView mtkView: MTKView) {
        device = mtkView.device!
        size = mtkView.frame.size
    }
    
    func update(deltaTime: Float) {
        
    }
    
    func render(deltaTime: Float, commandEncoder: MTLRenderCommandEncoder) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        
        rootNode.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
    }
    
    func sceneSizeWillChange(to size: CGSize) {
        camera.aspect = Float(size.width / size.height)
    }
    
    func keyDown(with event: NSEvent) {
        
    }
    
    func keyUp(with event: NSEvent) {
        
    }
    
    func mouseMoved(with event: NSEvent) {
        
    }
    
    func mouseDown(with event: NSEvent) {
        
    }
    
    func mouseUp(with event: NSEvent) {
        
    }
    
    func mouseDragged(with event: NSEvent) {
        
    }
}
