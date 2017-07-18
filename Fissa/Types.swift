//
//  Types.swift
//  Fissa
//
//  Created by Jaap Wijnen on 06/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import simd

struct Vertex {
    var position: vector_float3
    var color: vector_float4
    var texture: vector_float2
    var normal: vector_float3
}

struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
    var materialColor = float4(1)
    var normalMatrix = matrix_identity_float3x3
    var specularIntensity: Float = 1
    var shininess: Float = 1
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}

struct Light {
    var color = float3(1)
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var direction = float3(0)
}
