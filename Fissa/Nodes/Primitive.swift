//
//  Primitive.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class Primitive: Node {
    
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var vertexFunctionName: String = "vertex_shader"
    var fragmentFunctionName: String = "fragment_color"
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride + MemoryLayout<float2>.stride
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
    
    var modelConstants = ModelConstants()
    
    // Texturable
    var texture: MTLTexture?
    
    init(name: String, device: MTLDevice, subs: UInt16?, offset: Float?) {
        super.init(name: name)
        buildVertices(device: device, subdivs: subs, offset: offset)
        pipelineState = buildPipelineState(device: device)
    }
    
    convenience init(name: String, device: MTLDevice) {
        self.init(name: name, device: device, subs: nil, offset: nil)
    }
    
    init(name: String, device: MTLDevice, imageName: String, subs: UInt16?, offset: Float?) {
        super.init(name: name)
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        buildVertices(device: device, subdivs: subs, offset: offset)
        pipelineState = buildPipelineState(device: device)
    }
    
    convenience init(name: String, device: MTLDevice, imageName: String) {
        self.init(name: name, device: device, imageName: imageName, subs: nil, offset: nil)
    }
    
    func buildVertices(device: MTLDevice, subdivs: UInt16?, offset: Float?) { }
}

extension Primitive: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let vertexBuffer = vertexBuffer,
            let indexBuffer = indexBuffer else { return }
        modelConstants.modelViewMatrix = modelViewMatrix
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indexBuffer.length / 4, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0) // HACKY maar niet MemoryLayout<UInt16>.stride? is maar 2 ipv 4
    }
}

extension Primitive: Texturable { }
