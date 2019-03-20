//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport
import SceneKit
import ARKit

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer, ARSCNViewDelegate  {
    
    var sceneView: ARSCNView!
    let node = SCNNode()
    var speedSliderL0B0 = UISlider()
    var speedSliderL0B1 = UISlider()
    var speedSliderL0B2 = UISlider()
    var speedSliderL1B0 = UISlider()
    var speedSliderL1B1 = UISlider()
    var speedSliderL1B2 = UISlider()
    var speedSliderL2B0 = UISlider()
    var speedSliderL2B1 = UISlider()
    var speedSliderL2B2 = UISlider()
    var sliders = [UISlider]()
    
    let I_0: Float = {
        let intermediateResult: Float = Float(pow(0.05, 2.0)) + Float(pow(0.1, 2)) + Float(pow(0.15, 2)) + Float(pow(0.02, 2))
        return 3 * intermediateResult + (6 * pow(0.02, 2))
    }()
    
    let session = ARSession()
    
    //    let node3 = SCNNode()
    let colors = [UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.0), UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0), UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.0)]
    var bulbs = [SCNNode]()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // sceneView.debugOptions = [.showWorldOrigin]
        print(speedSliderL0B0)
        sliders = [speedSliderL0B0, speedSliderL0B1, speedSliderL0B2, speedSliderL1B0, speedSliderL1B1, speedSliderL1B2, speedSliderL2B0, speedSliderL2B1, speedSliderL2B2]
        print(sliders[0])
        sceneView = ARSCNView(frame: self.view.bounds)
        sceneView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        for i in 0...8 {
            var xPosition = CGFloat(0)
            let yPosition = CGFloat(100)
            var width = CGFloat(0)
            let height = CGFloat(20)
            
            switch i / 3 {
            case 0:
                xPosition = 10
                width = 0.8 * 3.0 * (sceneView.frame.width - 100.0) / 6.0
            case 1:
                xPosition = 3 * sceneView.frame.width / 12.0
                width = 0.8 * 2.0 * (sceneView.frame.width - 100.0) / 6.0
            case 2:
                xPosition = 5 * sceneView.frame.width / 12.0 - 10
                width = 0.8 * (sceneView.frame.width - 100.0) / 6.0
            default:
                return
            }
            sliders[i].frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        }
        
        self.view.addSubview(sceneView)
        // Set the view's delegate
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        updateUI()
        let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
        node.removeAction(forKey: "rotate")
        node.runAction(SCNAction.repeatForever(action), forKey: "rotate")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        for slider in sliders {
            slider.addTarget(self, action: #selector(moveBuble(_:)), for: UIControl.Event.valueChanged)
            slider.addTarget(self, action: #selector(changeSpeed(_:)), for: UIControl.Event.valueChanged)
            slider.setValue(0.5, animated: false)
        }
        
        for i in 0...8 {
            sliders[i].tag = i
        }
        
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func updateUI() {
        
        for slider in sliders {
            self.view.addSubview(slider)
        }
        sceneView.autoenablesDefaultLighting = true
        drawXMassTree()
        node.position = SCNVector3(0, 0, -1)
        sceneView.scene.rootNode.addChildNode(node)
        setSliders()
        
    }
    
    func drawXMassTree() {
        
        for i in 0...2 {
            drawLevel(i)
        }
        
        
    }
    
    func drawLevel(_ level: Int) {
        
        var height = Double(0.0)
        var yPosition = Float(0.0)
        
        if level == 0 {
            height = 0.3
            yPosition = 0
        } else if level == 1{
            height = 0.2
            yPosition = 0.3
        } else if level == 2 {
            height = 0.1
            yPosition = 0.5
        }
        
        let xBublePosition = Float(height/2)
        drawBulbs(atX: xBublePosition, atY: yPosition)
        
        for i in 0...2 {
            let branch = drawBranch(size: height)
            let node0 = SCNNode(geometry: branch)
            
            node0.position = SCNVector3(0, yPosition, 0)
            if i % 3 == 1 {
                node0.transform = SCNMatrix4MakeRotation(-2 * .pi / 3, 0, 1, 0)
                node0.position.y = yPosition
            }
            
            if i % 3 == 2 {
                node0.transform = SCNMatrix4MakeRotation(2 * .pi / 3, 0, 1, 0)
                node0.position.y = yPosition
            }
            node.addChildNode(node0)
        }
    }
    
    func drawBranch(size: Double) -> SCNShape {
        
        let scale = size
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: size))
        for x in stride(from: 0.0, to: 1.0, by: 0.05) {
            let y = 1/(x + 0.618) - 0.618
            path.addLine(to: CGPoint(x: x * scale, y: y * scale))
        }
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let branch = SCNShape(path: path, extrusionDepth: 0.001)
        branch.firstMaterial?.diffuse.contents = UIColor(red:0.22, green:1.00, blue:0.08, alpha:1.0)
        
        return branch
    }
    
    func drawBulbs(atX xPosition: Float, atY yPosition: Float) {
        
        for i in 0...2 {
            let bulb = drawBulb(i)
            let node0 = SCNNode(geometry: bulb)
            bulbs.append(node0)
            node.addChildNode(node0)
            
            node0.position = SCNVector3(xPosition, yPosition - 0.02, 0)
            
            if i % 3 == 1 { node0.position = rotate(vector: node0.position, by: 120) }
            if i % 3 == 2 { node0.position = rotate(vector: node0.position, by: -120) }
        }
    }
    
    func drawBulb(_ i: Int) -> SCNSphere{
        
        let bulb = SCNSphere(radius: 0.02)
        let material3 = SCNMaterial()
        material3.diffuse.contents = colors[i]
        bulb.materials = [material3]
        
        return bulb
    }
    
    func setSliders() {
        
        let vector00 = SCNVector3(0.8 * 75,0,0)
        let vector01 = rotate(vector: vector00, by: 120)
        let vector02 = rotate(vector: vector00, by: -120)
        speedSliderL0B0.transform = CGAffineTransform(translationX: CGFloat(vector00.x), y: CGFloat(vector00.z))
        speedSliderL0B1.frame.origin = CGPoint(x: speedSliderL0B1.frame.origin.x + CGFloat(vector01.x), y: speedSliderL0B1.frame.origin.y + CGFloat(vector01.z))
        speedSliderL0B1.transform = CGAffineTransform(rotationAngle: 2 * .pi / 3 )
        speedSliderL0B2.frame.origin = CGPoint(x: speedSliderL0B2.frame.origin.x + CGFloat(vector02.x), y: speedSliderL0B2.frame.origin.y + CGFloat(vector02.z))
        speedSliderL0B2.transform = CGAffineTransform(rotationAngle: -2 * .pi / 3 )
        
        let vector10 = SCNVector3(0.8 * 50,0,0)
        let vector11 = rotate(vector: vector10, by: 120)
        let vector12 = rotate(vector: vector10, by: -120)
        speedSliderL1B0.transform = CGAffineTransform(translationX: CGFloat(vector10.x), y: CGFloat(vector10.z))
        speedSliderL1B1.frame.origin = CGPoint(x: speedSliderL1B1.frame.origin.x + CGFloat(vector11.x), y: speedSliderL1B1.frame.origin.y + CGFloat(vector11.z))
        speedSliderL1B1.transform = CGAffineTransform(rotationAngle: 2 * .pi / 3 )
        speedSliderL1B2.frame.origin = CGPoint(x: speedSliderL1B2.frame.origin.x + CGFloat(vector12.x), y: speedSliderL1B2.frame.origin.y + CGFloat(vector12.z))
        speedSliderL1B2.transform = CGAffineTransform(rotationAngle: -2 * .pi / 3 )
        
        let vector20 = SCNVector3(0.8 * 25,0,0)
        let vector21 = rotate(vector: vector20, by: 120)
        let vector22 = rotate(vector: vector20, by: -120)
        speedSliderL2B0.transform = CGAffineTransform(translationX: CGFloat(vector20.x), y: CGFloat(vector20.z))
        speedSliderL2B1.frame.origin = CGPoint(x: speedSliderL2B1.frame.origin.x + CGFloat(vector21.x), y: speedSliderL2B1.frame.origin.y + CGFloat(vector21.z))
        speedSliderL2B1.transform = CGAffineTransform(rotationAngle: 2 * .pi / 3 )
        speedSliderL2B2.frame.origin = CGPoint(x: speedSliderL2B2.frame.origin.x + CGFloat(vector22.x), y: speedSliderL2B2.frame.origin.y + CGFloat(vector22.z))
        speedSliderL2B2.transform = CGAffineTransform(rotationAngle: -2 * .pi / 3 )
    }
    
    func rotate(vector: SCNVector3, by angle: Double) -> SCNVector3 {
        
        var resultVector = SCNVector3()
        
        if angle == 120 {
            resultVector = SCNVector3(vector.x * (-0.5), vector.y, vector.x * sqrt(3)/2)
        } else if angle == -120 {
            resultVector = SCNVector3(vector.x * (-0.5), vector.y, -vector.x * sqrt(3)/2)
        }
        
        return resultVector
    }
    
    
    
    @objc func changeSpeed(_ sender: UISlider) {
        
        let I = calculateMomentOfInertia()
        let y = I_0/I
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(y), z: 0, duration: 1)
        node.removeAction(forKey: "rotate")
        node.runAction(SCNAction.repeatForever(action), forKey: "rotate")
        
    }
    
    func calculateMomentOfInertia() -> Float {
        let intermediateResult = pow(speedSliderL0B0.value * 0.3, 2) + pow(speedSliderL0B1.value * 0.3, 2) + pow(speedSliderL0B2.value * 0.3, 2)
            + pow(speedSliderL1B0.value * 0.2, 2) + pow(speedSliderL1B1.value * 0.2, 2) + pow(speedSliderL1B2.value * 0.2, 2)
            + pow(speedSliderL2B0.value * 0.1, 2) + pow(speedSliderL2B1.value * 0.1, 2) + pow(speedSliderL2B2.value * 0.1, 2)
        return intermediateResult + ( 6 * pow(0.02, 2) )
    }
    
    @objc func moveBuble(_ sender: UISlider) {
        
        var slider = UISlider()
        var radius: Float = 0.0
        var angle = 0.0
        switch sender.tag {
        case 0:
            slider = speedSliderL0B0
            radius = 0.3
        case 1:
            slider = speedSliderL0B1
            radius = 0.3
            angle = 120
        case 2:
            slider = speedSliderL0B2
            radius = 0.3
            angle = -120
        case 3:
            slider = speedSliderL1B0
            radius = 0.2
        case 4:
            slider = speedSliderL1B1
            radius = 0.2
            angle = 120
        case 5:
            slider = speedSliderL1B2
            radius = 0.2
            angle = -120
        case 6:
            slider = speedSliderL2B0
            radius = 0.1
        case 7:
            slider = speedSliderL2B1
            radius = 0.1
            angle = 120
        case 8:
            slider = speedSliderL2B2
            radius = 0.1
            angle = -120
        default:
            return
        }
        
        let node3XPosition = radius * sender.value
        if sender.tag % 3 != 0 {
            let newPosition = rotate(vector: SCNVector3(x: node3XPosition, y: 0, z: 0), by: angle)
            bulbs[sender.tag].position.x = newPosition.x
            bulbs[sender.tag].position.z = newPosition.z
        } else {
            bulbs[sender.tag].position.x = node3XPosition
        }
        
    }
    
    @objc func handleTap(_ selector: UITapGestureRecognizer) {
        guard
            let currentPosition = sceneView.pointOfView?.position,
            let currentFrame = sceneView.session.currentFrame
            else {
                return
        }
        
        let yAngle = currentFrame.camera.eulerAngles.y
        let translation = rotateByRadian(vector: SCNVector3(0, 0, -1), by: yAngle)
        node.position = SCNVector3(currentPosition.x + translation.x, currentPosition.y + translation.y, currentPosition.z + translation.z)
        
    }
    
    func rotateByRadian(vector: SCNVector3, by angle: Float) -> SCNVector3 {
        let lenght = sqrt( pow(vector.x, 2) + pow(vector.z, 2) )
        let resultVector = SCNVector3(x: lenght * -sin(angle), y: vector.y, z: lenght * -cos(angle))
        return resultVector
    }
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //
    //        //1. Get The Current Touch Point
    //        guard let currentTouchPoint = touches.first?.location(in: self.sceneView),
    //            //2. Get The Next Feature Point Etc
    //            let hitTest = sceneView.hitTest(currentTouchPoint, types: .featurePoint).first else { print("wrong"); return }
    //        //3. Convert To World Coordinates
    //        let worldTransform = hitTest.worldTransform
    //
    //        //4. Set The New Position
    //        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
    //
    //        //5. Apply To The Node
    //        node3.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
    //   c
    //    }
    //
    /*
     public func liveViewMessageConnectionOpened() {
     // Implement this method to be notified when the live view message connection is opened.
     // The connection will be opened when the process running Contents.swift starts running and listening for messages.
     }
     */
    
    /*
     public func liveViewMessageConnectionClosed() {
     // Implement this method to be notified when the live view message connection is closed.
     // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
     // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
     }
     */
    
    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
    }
}

//
//  ViewController.swift
//  XMasTree
//
//  Created by Zofia Drabek on 13/03/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//


