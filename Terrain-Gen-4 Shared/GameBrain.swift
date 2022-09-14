//
//  GameBrain.swift
//  Terrain-Gen-4 
//
//  Created by 144895 on 06/09/2022.
//

import SceneKit

struct Biome {
    let name: String
    var indices : Dictionary<SCNColor, Array<UInt16>>
}

func CreateChunkMesh(dx:Int,dy:Int) -> SCNGeometry {
    var vertices : Array<SCNVector3> = []
    var elements : Array<SCNGeometryElement> = []
    var biome = Biome(name: "Mountain", indices: [SCNColor.white:[],SCNColor.systemTeal:[],SCNColor.systemYellow:[],SCNColor.systemGreen:[],SCNColor.systemGray:[],SCNColor.gray:[]])
//    var indices : Dictionary<SCNColor, Array<UInt16>> = [SCNColor.white:[],SCNColor.systemTeal:[],SCNColor.systemYellow:[],SCNColor.systemGreen:[],SCNColor.systemGray:[],SCNColor.gray:[]]
//    var indices :Dictionary<SCNColor, Array<UInt16>> = [SCNColor.white:[]]

    
    let perlinNoise = Perlin2D(seed: "helloworld")
    
    let size = 128
    //    vertices[SCNColor.systemGreen] = []
    //    vertices[SCNColor.systemGray] = []
    
    let cos30  = cos(CGFloat.pi/6)
    for iy in 0..<size {
        for ix in 0..<size {
            //            vertices.append(SCNVector3(x: CGFloat(dx+ix), y: CGFloat(dy+iy), z: 25 - 50 * perlinNoise.noise(x: CGFloat(dx+ix) / 100, y: CGFloat(dy+iy) / 100)))
            let x : CGFloat = CGFloat(ix) + 0.5 * CGFloat(iy % 2)
            let y : CGFloat = CGFloat(iy) * cos30
            let height = pow(perlinNoise.octaveNoise(x: CGFloat(dx)+x / 100.0, y: (CGFloat(dy)+y+1.0) / 100.0, octaves: 8, persistence: 0.4), 2)
            let vertice = SCNVector3(x: CGFloat(dx)+x, y: CGFloat(dy)+y, z: 100 * (max(height,0.3) - 0.3)/0.7)
//            let vertice = SCNVector3(x: CGFloat(dx)+x, y: CGFloat(dy)+y, z: 0.0)

            vertices.append(vertice)
        }
    }
//    let scatter = 0.05
    for irow in 0..<size-1 {
        for i in irow*size + 1...irow*size + size - 1 {
            for  isTopTriangle in [true , false] {
                //                let x : CGFloat = Double(irow) + 0.5 * Double(irow % 2)
                //                let y : CGFloat = CGFloat(i) * cos30
                //                let height = pow(perlinNoise.octaveNoise(x: CGFloat(dx)+x / 100, y: (CGFloat(dy)+y+1.0) / 100, octaves: 8, persistence: 0.4), 2)
                //                let vertice1 = SCNVector3(x: CGFloat(dx)+x, y: CGFloat(dy)+y, z: 50 - 100 * min(height,0.3))
                //                vertices[SCNColor.systemMint].append(vertice1)
                var triangleVerticesIndex : Array<UInt16> = []
                // 1    2   3   4   5   6   7   8
                // |  / |  / |  / |  / |  / |  /
                // 9    10  11  12  13  14  15  16
                // |  / |  / |  / |  / |  / |  /
                // 17   18  19  20  21  22  23  24
                // |  / |  / |  / |  / |  / |  /
                // 25   26  27  28  29  30  31  32
                
                if irow % 2 == 0 {
                    triangleVerticesIndex = [
                        UInt16(i - 1 + (isTopTriangle ? size : 0)),
                        UInt16(i),
                        UInt16(i+size + (isTopTriangle ? 0 : -1 ))
                    ]
                } else {
                    triangleVerticesIndex = [
                        UInt16(i - 1 + (isTopTriangle ? size : 0)),
                        UInt16(i + (isTopTriangle ? -1 : 0 )),
                        UInt16(i+size)
                    ]
                }
//                elements.append(SCNGeometryElement(indices: triangleVerticesIndex, primitiveType:.triangles))
                let scatter = 0.05
                let maxm = max(vertices[i].z, vertices[i - 1 + (isTopTriangle ? size : 0)].z, vertices[i+size + (isTopTriangle ? 0 : -1 )].z)
                switch min(vertices[i].z, vertices[i - 1 + (isTopTriangle ? size : 0)].z, vertices[i+size + (isTopTriangle ? 0 : -1 )].z) / maxm + CGFloat.random(in: -scatter...scatter){
                case 0.95...(1 + scatter):
                    if maxm > CGFloat.random(in: 17.5...18.5) {
                        biome.indices[SCNColor.white]!.append(contentsOf: triangleVerticesIndex)
                    } else if maxm > CGFloat.random(in: 11.5...12.5) {
                        biome.indices[SCNColor.systemGray]!.append(contentsOf: triangleVerticesIndex)
                    } else {
                        biome.indices[SCNColor.systemGreen]!.append(contentsOf: triangleVerticesIndex)

                    }
                case 0.8...0.95:
                    biome.indices[SCNColor.gray]!.append(contentsOf: triangleVerticesIndex)
                case 0.6...0.8:
                    biome.indices[SCNColor.systemGray]!.append(contentsOf: triangleVerticesIndex)
                case 0.2...0.6:
                    biome.indices[SCNColor.systemGreen]!.append(contentsOf: triangleVerticesIndex)
                case -scatter...0.2:
                    biome.indices[SCNColor.systemYellow]!.append(contentsOf: triangleVerticesIndex)
                default:
                    biome.indices[SCNColor.systemTeal]!.append(contentsOf: triangleVerticesIndex)
                }
            }
        }
    }
    var mats : Array<SCNMaterial> = []
    for indice in biome.indices {
        elements.append(SCNGeometryElement(indices: indice.value, primitiveType: .triangles))
        var mat = SCNMaterial()
        mat.diffuse.contents = indice.key
        mats.append(mat)
    }
 
    var source: SCNGeometrySource = SCNGeometrySource(vertices: vertices)
    
    var geo = SCNGeometry(sources: [source], elements: elements)
    geo.materials = mats
    return geo
}
