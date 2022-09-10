//
//  GameViewController.swift
//  Terrain-Gen-4 macOS
//
//  Created by 144895 on 06/09/2022.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    var GV: SCNView {
        return self.view as! SCNView
    }
    
    lazy var window: NSWindow = self.view.window!
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    var keyCurrentlyDown: Bool = false
    var shiftDown = false
//    var controlDown = false
    var GC: GameController!
    
    override func viewDidLoad() {
        GV.rendersContinuously = true
        GV.preferredFramesPerSecond = 30
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown], handler: myKeyDownEvent)
        NSEvent.addLocalMonitorForEvents(matching: [.keyUp], handler: myKeyUpEvent)
        
        NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged], handler: mySpecialKeyEvent)
        
//        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
//            let margin : CGFloat = 10
//            if self.mouseLocation.y - self.window.frame.midY >  margin {
//                print("x: \(self.mouseLocation.x - self.window.frame.midX) y:\(self.mouseLocation.y - self.window.frame.midY)")
//                CGWarpMouseCursorPosition(CGPoint(x:self.window.frame.midX,y:self.window.frame.midY))
//            }
//            if self.mouseLocation.y - self.window.frame.midY < -1 * margin {
//                print("x: \(self.mouseLocation.x - self.window.frame.midX) y:\(self.mouseLocation.y - self.window.frame.midY)")
//                CGWarpMouseCursorPosition(CGPoint(x:self.window.frame.midX,y:self.window.frame.midY))
//
//            }
//            if self.mouseLocation.x - self.window.frame.midX > margin {
//                print("x: \(self.mouseLocation.x - self.window.frame.midX) y:\(self.mouseLocation.y - self.window.frame.midY)")
//                CGWarpMouseCursorPosition(CGPoint(x:self.window.frame.midX,y:self.window.frame.midY))
//            }
//            if self.mouseLocation.x - self.window.frame.midX < -1 * margin {
//                print("x: \(self.mouseLocation.x - self.window.frame.midX) y:\(self.mouseLocation.y - self.window.frame.midY)")
//                CGWarpMouseCursorPosition(CGPoint(x:self.window.frame.midX,y:self.window.frame.midY))
//            }
//            return $0
//        }
        
        self.GC = GameController(sceneRenderer: GV)
        
        // Allow the user to manipulate the camera
        self.GV.allowsCameraControl = false
        
        // Show statistics such as fps and timing information
        self.GV.showsStatistics = true
        
        // Configure the view
        self.GV.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = GV.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        self.GV.gestureRecognizers = gestureRecognizers
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        window.acceptsMouseMovedEvents = true
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // Highlight the clicked nodes
        let p = gestureRecognizer.location(in: GV)
        GC.highlightNodes(atPoint: p)
    }
    func mySpecialKeyEvent(event:NSEvent) -> NSEvent? {
        switch event.keyCode {
        case 60: // right shifts
            shiftDown = !shiftDown
            if shiftDown { GC.cameraSpeed *= 2 } else { GC.cameraSpeed /= 2  }
        case 56:
            if GC.cameraDirection.z == -1 {
                GC.cameraDirection = SCNVector3(x: 0,y: 0,z: 0)
            } else {
            GC.cameraDirection = SCNVector3(x: 0,y: 0,z: -1)
            }
//        case 59: //control
//            controlDown = !controlDown
        default:
            print(event.keyCode)
            return event
        }
        return nil
    }
    func myKeyDownEvent(event: NSEvent) -> NSEvent? {
        if !keyCurrentlyDown {
            keyCurrentlyDown = true
            switch event.keyCode {
            case 13: // w
                GC.cameraDirection = SCNVector3(x: -sin(GC.cameraEulerAngels.z),y: cos(GC.cameraEulerAngels.z),z: 0)
            case 0: // a
                GC.cameraDirection = SCNVector3(x: -sin(GC.cameraEulerAngels.z + CGFloat.pi / 2),y: cos(GC.cameraEulerAngels.z + CGFloat.pi / 2),z: 0)
            case 1: // s
                GC.cameraDirection = SCNVector3(x: sin(GC.cameraEulerAngels.z),y: -cos(GC.cameraEulerAngels.z),z: 0)
            case 2: // d
                GC.cameraDirection = SCNVector3(x: -sin(GC.cameraEulerAngels.z - CGFloat.pi / 2),y: cos(GC.cameraEulerAngels.z - CGFloat.pi / 2),z: 0)
            case 49: // spacebar
                GC.cameraDirection = SCNVector3(x: 0,y: 0,z: 1)
            case 123: // arrow left
                GC.cameraEulerDirections = SCNVector3(x: 0,y: 0,z: 1)
            case 124: // arrow right
                GC.cameraEulerDirections = SCNVector3(x: 0,y: 0,z: -1)
            case 125: // arrow down
                GC.cameraEulerDirections = SCNVector3(x: -1,y: 0,z: 0)
            case 126: // arrow up
                GC.cameraEulerDirections = SCNVector3(x: 1,y: 0,z: 0)
            default:
                print(event.keyCode)
                return event
            }
        }
        return nil
    }
    func myKeyUpEvent(event: NSEvent) -> NSEvent {
        keyCurrentlyDown = false
        GC.cameraDirection = SCNVector3(x: 0,y: 0,z: 0)
        GC.cameraEulerDirections = SCNVector3(x: 0,y: 0,z: 0)
        return event
    }
}
