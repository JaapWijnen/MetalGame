//
//  Renderer.swift
//  Fissa
//
//  Created by Jaap Wijnen on 06/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    var samplerState: MTLSamplerState?
    var depthStencilState: MTLDepthStencilState?
    
    var scene: Scene?
    
    init(withMTKView mtkView: MTKView) {
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        super.init()
        self.device = mtkView.device!
        self.commandQueue = device.makeCommandQueue()
        
        buildSamplerState()
        buildDepthStencilState()
    }
    
    func buildSamplerState() {
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    
    func buildDepthStencilState() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        commandEncoder?.setDepthStencilState(depthStencilState)
        
        scene?.render(deltaTime: deltaTime, commandEncoder: commandEncoder!)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene?.sceneSizeWillChange(to: size)
    }
}
