//
//  Camera.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import simd

class Camera: Node {
    var viewMatrix: matrix_float4x4 {
        return modelMatrix
    }
    
    var fovDegrees: Float = 65
    var aspect: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 100
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4(projectionFov: fovDegrees.radians(), aspect: aspect, nearZ: nearZ, farZ: farZ)
    }
}
