//
//  Texturable.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        let origin = MTKTextureLoader.Origin.bottomLeft
        let textureLoaderOptions = [MTKTextureLoader.Option.origin: origin]
        
        print("Fissa")
        print(Bundle.main.url(forResource: "rocks", withExtension: "jpg"))
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch {
                print("texture not created")
            }
        }
        
        return texture
    }
}
