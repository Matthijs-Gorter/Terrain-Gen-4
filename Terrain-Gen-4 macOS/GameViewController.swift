//
//  GameViewController.swift
//  Terrain-Gen-4 macOS
//
//  Created by 144895 on 06/09/2022.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    var gameView: SCNView {
        return self.view as! SCNView
    }
    
    lazy var window: NSWindow = self.view.window!
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            
//            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
//            let margin : CGFloat = 10
//            print(self.location.x - self.window.frame.width / 2,self.location.y - self.window.frame.height / 2)

//            CGWarpMouseCursorPosition(CGPoint(x:100,y:100))
            
//            if self.mouseLocation.y  >  self.window.frame.maxY {
//                CGWarpMouseCursorPosition(CGPoint(x: self.mouseLocation.x, y: (self.window.screen?.frame.maxY)! - self.window.frame.minY - margin))
////                print(CGPoint(x: self.mouseLocation.x, y: (self.window.screen?.frame.maxY)! - self.window.frame.minY - margin))
////                print(1)
//            }
//            if self.mouseLocation.y < self.window.frame.minY {
//                CGWarpMouseCursorPosition(CGPoint(x: self.mouseLocation.x, y: (self.window.screen?.frame.maxY)! - self.window.frame.maxY + margin))
////                print(CGPoint(x: self.mouseLocation.x, y: (self.window.screen?.frame.maxY)! - self.window.frame.maxY + margin))
////                print(2)
//            }
//            if self.mouseLocation.x > self.window.frame.maxX {
//                CGWarpMouseCursorPosition(CGPoint(x: self.window.frame.minX + margin, y: (self.window.screen?.frame.maxY)! - self.mouseLocation.y))
////                    print(CGPoint(x: self.window.frame.minX + margin, y: (self.window.screen?.frame.maxY)! - self.mouseLocation.y))
////                print(3)
//            }
//            if self.mouseLocation.x < self.window.frame.minX {
//                CGWarpMouseCursorPosition(CGPoint(x: self.window.frame.maxX - margin, y: (self.window.screen?.frame.maxY)! - self.mouseLocation.y))
////                    print(CGPoint(x: self.window.frame.maxX - margin, y: (self.window.screen?.frame.maxY)! - self.mouseLocation.y))
////                print(4)
//            }
            return $0
        }
//        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
//            print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
//        }
        
        self.gameController = GameController(sceneRenderer: gameView)
        
        // Allow the user to manipulate the camera
        self.gameView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        // Configure the view
        self.gameView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = gameView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        self.gameView.gestureRecognizers = gestureRecognizers
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        window.acceptsMouseMovedEvents = true
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // Highlight the clicked nodes
        let p = gestureRecognizer.location(in: gameView)
        gameController.highlightNodes(atPoint: p)
    }
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
    }
    
}
