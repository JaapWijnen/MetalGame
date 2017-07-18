//
//  Node.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class Node {
    var name = "Untitled Node"
    var parent: Node?
    var children: [Node] = []
    
    var position = vector_float3(0)
    var scale = vector_float3(1)
    var rotation = vector_float3(0)
    
    var modelMatrix: matrix_float4x4 {
        get {
            
            var matrix = matrix_identity_float4x4
            matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
            matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
            matrix = matrix.rotatedBy(rotationAngle: rotation.z, x: 0, y: 0, z: 1)
            matrix = matrix.translatedBy(x: position.x, y: position.y, z: position.z)            
            matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
            return matrix
        }
    }
    /*
    var position: vector_float3
    var rotation: vector_float4
    var eulerAngles: vector_float3
    var orientation: Quaternion
    var scale: vector_float3
    var pivot: matrix_float4x4
    var transform: matrix_float4x4
    var worldTransform: matrix_float4x4
     */
    
    init(name: String) {
        self.name = name
    }
    
    func add(childNode: Node) {
        childNode.parent = self
        children.append(childNode)
    }
    
    func remove(childNode: Node) {
        if let index = children.index(of: childNode) {
            children.remove(at: index)
        }
    }
    
    func removeFromParentNode() {
        self.parent?.remove(childNode: self)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
        
        if let renderable = self as? Renderable {
            commandEncoder.pushDebugGroup(name)
            renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
            commandEncoder.popDebugGroup()
        }
    }
}

extension Node: Equatable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name &&
            lhs.position == rhs.position &&
            lhs.rotation == rhs.rotation &&
            lhs.scale == rhs.scale &&
            lhs.parent == rhs.parent &&
            lhs.children == rhs.children
    }
}
