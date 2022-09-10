//
//  GameViewController.swift
//  Terrain-Gen-4 iOS
//
//  Created by 144895 on 06/09/2022.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var GV: SCNView {
        return self.view as! SCNView
    }
    
    var GC: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GC = GameController(sceneRenderer: GV)
        
        // Allow the user to manipulate the camera
        self.GV.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        self.GV.showsStatistics = true
        
        // Configure the view
        self.GV.backgroundColor = UIColor.black
        
        // Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        var gestureRecognizers = GV.gestureRecognizers ?? []
        gestureRecognizers.insert(tapGesture, at: 0)
        self.GV.gestureRecognizers = gestureRecognizers
    }
    
    @objc
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        // Highlight the tapped nodes
        let p = gestureRecognizer.location(in: GV)
        GC.highlightNodes(atPoint: p)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
