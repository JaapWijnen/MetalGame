//
//  MCScene.swift
//  Fissa
//
//  Created by Jaap Wijnen on 17-10-17.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class MCScene: Scene {
    
    var chunk: Chunk!
    
    
    var forwardKey: Bool = false
    var backwardKey: Bool = false
    var leftKey: Bool = false
    var rightKey: Bool = false
    var upKey: Bool = false
    var downKey: Bool = false
    var mouseDeltaX: Float = 0.0
    var mouseDeltaY: Float = 0.0
    
    let movementSpeed: Float = 2.0
    
    override init(withMTKView mtkView: MTKView) {
        super.init(withMTKView: mtkView)
        chunk = Chunk(name: "chunk", device: device, imageName: "rocks.jpg")
        chunk.position = vector_float3(0,0,0)

        camera.position.z = -3
        
        rootNode.add(childNode: chunk)
    }
    
    override func update(deltaTime: Float) {
        if leftKey {
            camera.position.x += cos(-camera.rotation.y) * deltaTime * movementSpeed
            camera.position.z += sin(-camera.rotation.y) * deltaTime * movementSpeed
        }
        if rightKey {
            camera.position.x -= cos(-camera.rotation.y) * deltaTime * movementSpeed
            camera.position.z -= sin(-camera.rotation.y) * deltaTime * movementSpeed
        }
        if backwardKey {
            camera.position.x -= sin(camera.rotation.y) * deltaTime * movementSpeed
            camera.position.z -= cos(camera.rotation.y) * deltaTime * movementSpeed
        }
        if forwardKey {
            camera.position.x += sin(camera.rotation.y) * deltaTime * movementSpeed
            camera.position.z += cos(camera.rotation.y) * deltaTime * movementSpeed
        }
        if upKey {
            camera.position.y += deltaTime * movementSpeed
        }
        if downKey {
            camera.position.y -= deltaTime * movementSpeed
        }
        camera.rotation.y -= mouseDeltaX * deltaTime * movementSpeed * 0.1
        mouseDeltaX = 0
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        if keyCode == 0 || keyCode == 123 { // A / left
            leftKey = true
        }
        if keyCode == 2 || keyCode == 124 { // D / right
            rightKey = true
        }
        if keyCode == 1 || keyCode == 125 { // S / down
            backwardKey = true
        }
        if keyCode == 13 || keyCode == 126 { // W / up
            forwardKey = true
        }
        if keyCode == 12 { // Q
            upKey = true
        }
        if keyCode == 14 { // E
            downKey = true
        }
    }
    
    override func keyUp(with event: NSEvent) {
        let keyCode = event.keyCode
        if keyCode == 0 || keyCode == 123 { // left
            leftKey = false
        }
        if keyCode == 2 || keyCode == 124 { // right
            rightKey = false
        }
        if keyCode == 1 || keyCode == 125 { // down
            backwardKey = false
        }
        if keyCode == 13 || keyCode == 126 { // up
            forwardKey = false
        }
        if keyCode == 12 { // Q
            upKey = false
        }
        if keyCode == 14 { // E
            downKey = false
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        mouseDeltaX = Float(event.deltaX)
        mouseDeltaY = Float(event.deltaY)
    }
    
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
}

