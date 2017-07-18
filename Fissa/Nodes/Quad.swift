//
//  Quad.swift
//  Fissa
//
//  Created by Jaap Wijnen on 09/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class Quad: Primitive {
    
    override func buildVertices(device: MTLDevice, subdivs: UInt16?, offset: Float?) {
        let subdivs: UInt16 = subdivs != nil ? subdivs! : UInt16(0)
        let offset = offset != nil ? offset! : Float(0)
        let col = float4(1, 1, 1, 1)
        let delta: Float = 1.0 / Float(subdivs)
        
        var vertices: [Vertex] = []
        var indices: [UInt16] = []
        
        for i in 0...subdivs {
            for j in 0...subdivs {
                let pos = float3(-1 + Float(i) * 2 * delta, -1 + Float(j) * 2 * delta, offset)
                let tex = float2(Float(i) * delta, Float(j) * delta)
                let vertex = Vertex(position: pos, color: col, texture: tex, normal: vector_float3(0, 0, 1))
                vertices.append(vertex)
            }
        }
        
        var index: UInt16 = 0
        
        for _ in 0..<subdivs {
            for _ in 0..<subdivs {
                indices.append(index)
                indices.append(index + subdivs + 2)
                indices.append(index + 1)
                
                indices.append(index)
                indices.append(index + subdivs + 1)
                indices.append(index + subdivs + 2)
                
                index += 1
            }
            index += 1
        }
        
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<Float>.stride, options: [])
    }
    
    func rotateY(radians: Float, subdivs: UInt16) {
        let totalVertices = Int((subdivs + 1) * (subdivs + 1))
        var vertexBufferPointer = UnsafeMutableRawBufferPointer(start: vertexBuffer?.contents(), count: totalVertices * MemoryLayout<Vertex>.stride)
        
        for i in 0..<totalVertices {
            var vertex = vertexBufferPointer.load(fromByteOffset: i * MemoryLayout<Vertex>.stride, as: Vertex.self)
            Swift.print(vertex.position)
            vertex.position.x = vertex.position.x * cos(radians) - vertex.position.z * sin(radians)
            vertex.position.z = vertex.position.x * sin(radians) + vertex.position.z * cos(radians)
            Swift.print(vertex.position)
        }
            
        /*for _ in 0..<totalVertices {
            Swift.print(vertexBufferPointer)
            
            var vertex = vertexBufferPointer?.load(as: Vertex.self)
            Swift.print("x: \(vertex?.position.x)")
            Swift.print("cos: \(cos(radians))")
            Swift.print("z: \(vertex?.position.z)")
            Swift.print("sin: \(sin(radians))")
            Swift.print("newX: \((vertex?.position.x)! * cos(radians) - (vertex?.position.z)! * sin(radians))")
            Swift.print("newZ: \((vertex?.position.x)! * sin(radians) + (vertex?.position.z)! * cos(radians))")
            Swift.print(vertex?.position)
            vertex!.position.x = (vertex?.position.x)! * cos(radians) - (vertex?.position.z)! * sin(radians)
            vertex!.position.z = (vertex?.position.x)! * sin(radians) + (vertex?.position.z)! * cos(radians)
            Swift.print(vertex?.position)
            vertexBufferPointer?.copyBytes(from: &vertex, count: MemoryLayout<Vertex>.stride)
            vertexBufferPointer = vertexBufferPointer?.advanced(by: MemoryLayout<Vertex>.stride)
        }*/
        
    }
}
