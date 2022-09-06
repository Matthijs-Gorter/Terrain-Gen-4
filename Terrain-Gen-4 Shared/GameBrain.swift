//
//  GameBrain.swift
//  Terrain-Gen-4
//
//  Created by 144895 on 06/09/2022.
//

import SceneKit

func CreateMapMesh() -> SCNGeometry {
    var vertices : Array<SCNVector3> = []
    var elements : Array<SCNGeometryElement> = []
    var indices : Array<UInt16> = []
    
    let perlinNoise = Perlin2D(seed: "helloworld")

    // 0    1   2   3   4
    // 5    6   7   8   9
    // 10   11  12  13  14
    // 15   16  17  18  19
    
    let size = 256
    for iy in 0..<size {
        for ix in 0..<size {
            vertices.append(SCNVector3(x: CGFloat(ix), y: CGFloat(iy), z:
                                        25 - 50 * perlinNoise.noise(x: CGFloat(ix) / 100, y: CGFloat(iy) / 100)))
//            print(perlinNoise.noise(x: CGFloat(ix) / 100, y: CGFloat(iy) / 100))
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
