//
//  MatrixMath.swift
//  Fissa
//
//  Created by Jaap Wijnen on 07/06/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import simd

extension Float {
    public func radians() -> Float {
        return self / 180 * .pi
    }
}

extension vector_float3: Equatable {
    public static func == (lhs: vector_float3, rhs: vector_float3) -> Bool {
        return
            lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.z == rhs.z
    }
}

extension vector_float4: Equatable {
    public static func == (lhs: vector_float4, rhs: vector_float4) -> Bool {
        return
            lhs.w == rhs.w &&
                lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.z == rhs.z
    }
}

extension matrix_float4x4: Equatable {
    public static func == (lhs: matrix_float4x4, rhs: matrix_float4x4) -> Bool {
        return
            lhs.columns.0 == lhs.columns.0 &&
                lhs.columns.1 == lhs.columns.1 &&
                lhs.columns.2 == lhs.columns.2 &&
                lhs.columns.3 == lhs.columns.3
    }
}

extension vector_float3 {
    public var length: Float {
        get {
            return sqrt(x*x + y*y + z*z)
        }
    }
    
    public static func / (lhs: vector_float3, rhs: Float) -> vector_float3 {
        return float3(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
}

extension matrix_float4x4 {
    init(translationX x: Float, y: Float, z: Float) {
        columns = (
            float4( 1,  0,  0,  0),
            float4( 0,  1,  0,  0),
            float4( 0,  0,  1,  0),
            float4( x,  y,  z,  1)
        )
    }
    
    func translatedBy(x: Float, y: Float, z: Float) -> matrix_float4x4 {
        let translateMatrix = matrix_float4x4(translationX: x, y: y, z: z)
        return matrix_multiply(self, translateMatrix)
    }
    
    init(scaleX x: Float, y: Float, z: Float) {
        columns = (
            float4( x,  0,  0,  0),
            float4( 0,  y,  0,  0),
            float4( 0,  0,  z,  0),
            float4( 0,  0,  0,  1)
        )
    }
    
    func scaledBy(x: Float, y: Float, z: Float) -> matrix_float4x4 {
        let scaledMatrix = matrix_float4x4(scaleX: x, y: y, z: z)
        return matrix_multiply(self, scaledMatrix)
    }
    
    // angle should be in radians
    init(rotationAngle angle: Float, x: Float, y: Float, z: Float) {
        let c = cos(angle)
        let s = sin(angle)
        
        var column0 = float4(0)
        column0.x = x * x + (1 - x * x) * c
        column0.y = x * y * (1 - c) - z * s
        column0.z = x * z * (1 - c) + y * s
        column0.w = 0
        
        var column1 = float4(0)
        column1.x = x * y * (1 - c) + z * s
        column1.y = y * y + (1 - y * y) * c
        column1.z = y * z * (1 - c) - x * s
        column1.w = 0.0
        
        var column2 = float4(0)
        column2.x = x * z * (1 - c) - y * s
        column2.y = y * z * (1 - c) + x * s
        column2.z = z * z + (1 - z * z) * c
        column2.w = 0.0
        
        let column3 = float4(0, 0, 0, 1)
        
        columns = (
            column0, column1, column2, column3
        )
    }
    
    func rotatedBy(rotationAngle angle: Float,
                   x: Float, y: Float, z: Float) -> matrix_float4x4 {
        let rotationMatrix = matrix_float4x4(rotationAngle: angle,
                                             x: x, y: y, z: z)
        return matrix_multiply(self, rotationMatrix)
    }
    
    init(projectionFov fov: Float, aspect: Float, nearZ: Float, farZ: Float) {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = farZ / (nearZ - farZ)
        columns = (
            float4( x,  0,  0,  0),
            float4( 0,  y,  0,  0),
            float4( 0,  0,  z, -1),
            float4( 0,  0,  z * nearZ,  0)
        )
    }
    
    func upperLeft3x3() -> matrix_float3x3 {
        return (matrix_float3x3(columns: (
            float3(columns.0.x, columns.0.y, columns.0.z),
            float3(columns.1.x, columns.1.y, columns.1.z),
            float3(columns.2.x, columns.2.y, columns.2.z)
        )))
    }
    
    static func * (lhs: matrix_float4x4, rhs: matrix_float4x4) -> matrix_float4x4 {
        return matrix_multiply(lhs, rhs)
    }
}
