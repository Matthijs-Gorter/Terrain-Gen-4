//
//  GameBrain.swift
//  Terrain-Gen-4 
//
//  Created by 144895 on 06/09/2022.
//

import SceneKit

func CreateChunkMesh(dx:Int,dy:Int) -> SCNGeometry {
    var vertices : Array<SCNVector3> = []
    var elements : Array<SCNGeometryElement> = []
    var indices : Array<UInt16> = []
    
    let perlinNoise = Perlin2D(seed: "helloworld")
    
    let size = 256
    for iy in 0..<size {
        for ix in 0..<size {
//            vertices.append(SCNVector3(x: CGFloat(dx+ix), y: CGFloat(dy+iy), z: 25 - 50 * perlinNoise.noise(x: CGFloat(dx+ix) / 100, y: CGFloat(dy+iy) / 100)))
            vertices.append(SCNVector3(x: CGFloat(dx+ix), y: CGFloat(dy+iy),
                                       z: 50 - 100 * pow(perlinNoise.octaveNoise(x: CGFloat(dx+ix) / 100, y: CGFloat(dy+iy) / 100, octaves: 8, persistence: 0.4), 2)))
        }
    }
    
    for irow in 0..<size-1 {
        for i in irow*size + 1...irow*size + size - 1 {
            for  isTopTriangle in [true , false] {
                let triangleVerticesIndex = [
                    UInt16(i - 1 + (isTopTriangle ? size : 0)),
                    UInt16(i),
                    UInt16(i+size + (isTopTriangle ? 0 : -1 ))
                ]
                indices.append(contentsOf: triangleVerticesIndex)
            }
        }
    }
    elements.append(SCNGeometryElement(indices: indices, primitiveType: .triangles))
    return SCNGeometry(sources: [SCNGeometrySource(vertices: vertices)], elements: elements)
}
