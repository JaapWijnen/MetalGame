//
//  SubCube.swift
//  Fissa
//
//  Created by Jaap Wijnen on 09/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class SubCube: Primitive {
    override func buildVertices(device: MTLDevice, subdivs: UInt16?, offset: Float?) {
        let subdivs: UInt16 = subdivs != nil ? subdivs! : UInt16(0)
        let offset = offset != nil ? offset! : Float(0)
        let quadIndexBufferSize = subdivs * subdivs * 6 * UInt16(MemoryLayout<UInt16>.stride)
        let cubeIndexBufferSize = quadIndexBufferSize * 6
        let quadVertexBufferSize = (subdivs + 1) * (subdivs + 1) * UInt16(MemoryLayout<Vertex>.stride)
        let cubeVertexBufferSize = 6 * quadVertexBufferSize
        
        let quad = Quad(name: "testQuad", device: device, imageName: "rocks.jpg", subs: subdivs, offset: 1)
        quad.rotateY(radians: Float(90).radians(), subdivs: subdivs)
        
        //buffer.contents().copyBytes(from: vector2, count: vector2.count * MemoryLayout<Float>.stride)
        
        vertexBuffer = device.makeBuffer(length: Int(cubeVertexBufferSize), options: [])
        var vertexBufferPointer = vertexBuffer?.contents()
        vertexBufferPointer?.copyBytes(from: (quad.vertexBuffer?.contents())!, count: Int(quadVertexBufferSize))
        
        indexBuffer = device.makeBuffer(length: Int(cubeIndexBufferSize), options: [])
        var indexBufferPointer = indexBuffer?.contents()
        indexBufferPointer?.copyBytes(from: (quad.indexBuffer?.contents())!, count: Int(quadIndexBufferSize))
        //vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        //indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<Float>.stride, options: [])
    }
}
