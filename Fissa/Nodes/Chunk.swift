//
//  Chunk.swift
//  Fissa
//
//  Created by Jaap Wijnen on 17-10-17.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import MetalKit

class Chunk: Primitive {
    override func buildVertices(device: MTLDevice, subdivs: UInt16?, offset: Float?) {
        let geometry = [
            [
                [true, true, true],
                [true, true, true],
                [true, true, true]
            ],[
                [true, true, true],
                [true, false, false],
                [false, false, true]
            ],[
                [true, true, false],
                [true, false, false],
                [false, false, false]
            ]
        ]
        
        vertices = []
        indices = []
        var index: UInt16 = 0
        let quads = greedyMesh(volume: geometry, dims: [3,3,3])
        for quad in quads {
            let q0 = quad[0].map { Float($0) }
            let q1 = quad[1].map { Float($0) }
            let q2 = quad[2].map { Float($0) }
            let q3 = quad[3].map { Float($0) }
            
            
            let pos0 = float3(q0[0],q0[1],q0[2])
            let pos1 = float3(q1[0],q1[1],q1[2])
            let pos2 = float3(q2[0],q2[1],q2[2])
            let pos3 = float3(q3[0],q3[1],q3[2])
            
            Swift.print("\(pos0), \(pos1), \(pos2), \(pos3)")

            
            let v0 = Vertex(position: pos0,   // 0
                            color:    float4(1, 0, 0, 1),
                            texture:  float2(0, 0),
                            normal: float3(0, 0, 0))
            
            let v1 = Vertex(position: pos1,  // 1
                            color:    float4(0, 1, 0, 1),
                            texture:  float2(0, 1),
                            normal: float3(0, 0, 0))
            
            let v2 = Vertex(position: pos2,   // 2
                            color:    float4(0, 0, 1, 1),
                            texture:  float2(1, 1),
                            normal: float3(0, 0, 0))
            
            let v3 = Vertex(position: pos3,    // 3
                            color:    float4(1, 0, 1, 1),
                            texture:  float2(1, 0),
                            normal: float3(0, 0, 0))
            
            //0, 1, 2,     0, 2, 3
            vertices.append(v0)
            vertices.append(v1)
            vertices.append(v2)
            vertices.append(v3)
            
            indices.append(index)
            indices.append(index + 1)
            indices.append(index + 2)
            indices.append(index)
            indices.append(index + 2)
            indices.append(index + 3)
            index += 4
        }
        
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<Float>.stride, options: [])
    }
    
    func greedyMesh(volume: [[[Bool]]], dims: [Int]) -> [[[Int]]] {
        assert(dims.count == 3)
        var quads: [[[Int]]] = []
        
        for d in 0..<3 {
            print("d: \(d)")
            let u = (d + 1) % 3
            let v = (d + 2) % 3
            var x = [0, 0, 0]
            var q = [0, 0, 0]
            var mask = [[Bool]](repeating: [Bool](repeating: false, count: dims[u]), count: dims[v])
            q[d] = 1
            x[d] = -1
            while x[d] < dims[d] {
                print(" layer: \(x[d] + 1)")
                // Compute mask
                x[v] = 0
                while x[v] < dims[v] {
                    x[u] = 0
                    while x[u] < dims[u] {
                        let bool1 = 0 <= x[d] ? volume[x[0]][x[1]][x[2]] : false
                        let bool2 = x[d] < dims[d] - 1 ? volume[x[0] + q[0]][x[1] + q[1]][x[2] + q[2]] : false
                        
                        mask[x[v]][x[u]] = (bool1 != bool2)
                        x[u] += 1
                    }
                    x[v] += 1
                }
                x[d] += 1
                
                print(" mask: \(mask)")
                
                // Generate mesh from mask
                for j in 0..<dims[v] {
                    var i = 0
                    while i < dims[u] {
                        if mask[j][i] {
                            print("  quad")
                            // Compute width
                            var w = 1
                            while i + w < dims[u] && mask[j][i + w] { w += 1 }
                            print("    width: \(w)")
                            
                            // Compute height
                            var done = false
                            var h = 1
                            while j + h < dims[v] {
                                for k in 0..<w {
                                    if !mask[j + h][i + k] {
                                        done = true
                                        break
                                    }
                                }
                                if done { break }
                                h += 1
                            }
                            print("    height: \(h)")
                            
                            // Add quad
                            x[u] = i
                            x[v] = j
                            var du = [0, 0, 0]
                            du[u] = w
                            var dv = [0, 0, 0]
                            dv[v] = h
                            let quad = [
                                [x[0],                 x[1],                 x[2]                 ],
                                [x[0] + du[0],         x[1] + du[1],         x[2] + du[2]         ],
                                [x[0] + du[0] + dv[0], x[1] + du[1] + dv[1], x[2] + du[2] + dv[2] ],
                                [x[0] + dv[0],         x[1] + dv[1],         x[2] + dv[2]         ]
                            ]
                            quads.append(quad)
                            
                            // Zero out mask
                            for l in 0..<h {
                                for k in 0..<w {
                                    mask[j + l][i + k] = false
                                }
                            }
                            // Increment counters and continue
                            i += w
                        } else {
                            i += 1
                        }
                    }
                }
                
            }
            
        }
        
        return quads
    }

}
