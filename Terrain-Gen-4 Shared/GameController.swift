//
//  GameController.swift
//  Terrain-Gen-4 Shared
//
//  Created by 144895 on 06/09/2022.
//

import SceneKit

#if os(watchOS)
import WatchKit
#endif

#if os(macOS)
typealias SCNColor = NSColor
#else
typealias SCNColor = UIColor
#endif

class GameController: NSObject, SCNSceneRendererDelegate {
    
    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene()
        
        // chunk
        let chunkMesh = CreateChunkMesh(dx:0,dy:0)
        let chunkNode = SCNNode(geometry: chunkMesh)
        scene.rootNode.addChildNode(chunkNode)
        
        // light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = SCNColor(white: 0.33, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = SCNColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 25, 50)
        scene.rootNode.addChildNode(omniLightNode)
        sceneRenderer.scene = scene
        
        // cam
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 128, y: 128, z: 128)
        cameraNode.eulerAngles = SCNVector3(1,0,0)
        cameraNode.camera?.zNear = 0
        cameraNode.camera?.zFar = 1080
//        cameraNode.rotation.z = /
//        cameraNode.name = "cam"
//        cameraNode.camera?.zFar = 1000
//        cameraNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 2 * CGFloat.pi)
        
        super.init()
        
        sceneRenderer.pointOfView = cameraNode
//        sceneRenderer.pointOfView?.eulerAngles = SCNVector3(1.4,0,0)
        
        sceneRenderer.delegate = self
        
        sceneRenderer.scene = scene
    }
    
    func highlightNodes(atPoint point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        for result in hitResults {
            // get its material
            print(result.node.name as Any)
            guard let material = result.node.geometry?.firstMaterial else {
                return
            }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = SCNColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = SCNColor.red
            
            SCNTransaction.commit()
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Called before each frame is rendered
//        print(sceneRenderer.pointOfView?.eulerAngles ?? 0)
    }
}
