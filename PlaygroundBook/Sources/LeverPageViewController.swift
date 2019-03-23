//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport
import SpriteKit

public class LeverPageViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer  {

    var skScene: SKScene!
    var skView: SKView!
    var leverNode: SKSpriteNode!
    var weight0Node: SKSpriteNode!
    var weight1Node: SKSpriteNode!
    var pivotNode: SKSpriteNode!
    var checkButton: UIButton!
    var massLeftLabel = SKLabelNode()
    var massRightLabel = SKLabelNode()
    var heavierSide: String!
    var balance: Bool!
    
    
    override public func viewDidLoad() {
        
        skSetUp()
        drawLever()
    }
    

    func skSetUp() {
        
        
        
        skScene = SKScene(size: view.bounds.size)
        skView = SKView(frame:.zero)
        skScene.backgroundColor = .white
        self.view.addSubview(skView)
        skScene.scaleMode = .aspectFill
        skView.ignoresSiblingOrder = true
        skView.presentScene(skScene)
        skView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: self.view.topAnchor),
            skView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        
        
        checkButton = UIButton(frame: .zero)
        
        checkButton.backgroundColor = UIColor(red:0.91, green:0.38, blue:0.38, alpha:1.0)
        checkButton.layer.cornerRadius = 20
        checkButton.clipsToBounds = true
        checkButton.addTarget(self, action: #selector(rotateLever), for: .touchDown)
        checkButton.setTitle("CHECK", for: .normal)
        checkButton.setTitleColor(.white, for: .normal)
        skView.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.centerXAnchor.constraint(equalTo: skView.centerXAnchor),
            checkButton.centerYAnchor.constraint(equalTo: skView.bottomAnchor, constant: -100),
            checkButton.widthAnchor.constraint(equalToConstant: 100),
            checkButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func drawLever() {
        
        
        
        let leverImage = UIImage(named: "lever")
        let leverTexture = SKTexture(image: leverImage!)
        leverNode = SKSpriteNode(texture: leverTexture, size: CGSize(width: self.view.frame.width * 0.7, height: 10))
        leverNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leverNode.position = CGPoint(x: skScene.frame.width / 2, y: skScene.frame.height / 2)
        skScene.addChild(leverNode)
        
        
        let weightImage = UIImage(named: "weight")
        let weightTexture = SKTexture(image: weightImage!)
        weight0Node = SKSpriteNode(texture: weightTexture, size: CGSize(width: skScene.size.width * 0.1, height: skScene.size.height * 0.1))
        weight0Node.anchorPoint = CGPoint(x: 0.5, y: 0.92)
        //        weight0Node.position = CGPoint(x: skScene.frame.width / 4, y: skScene.frame.height / 2)
        skScene.addChild(weight0Node)
        
        
        weight1Node = SKSpriteNode(texture: weightTexture, size: CGSize(width: skScene.size.width * 0.1, height: skScene.size.height * 0.1))
        weight1Node.anchorPoint = CGPoint(x: 0.5, y: 0.92)
        //        weight1Node.position = CGPoint(x: 3 * skScene.frame.width / 4, y: skScene.frame.height / 2)
        skScene.addChild(weight1Node)
        
        positionWeigths(leftMass: 1, leftPosition: 1, rightMass: 2, rightPosition: 4)
        
        let pivotImage = UIImage(named: "pivot")
        let pivotTexture = SKTexture(image: pivotImage!)
        pivotNode = SKSpriteNode(texture: pivotTexture, size: CGSize(width: skScene.size.width * 0.02, height: skScene.size.height * 0.1))
        pivotNode.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        pivotNode.position = CGPoint(x: skScene.frame.width / 2, y: skScene.frame.height / 2)
        skScene.addChild(pivotNode)
        
        
        
        
    }
    
    @objc func rotateLever() {
        leverNode.run(SKAction.rotate(byAngle: -.pi/10, duration: 3)) {
            self.leverNode.run(SKAction.rotate(byAngle: .pi/10, duration: 3)) {
                self.leverNode.run(SKAction.rotate(byAngle: .pi/10, duration: 3)) {
                    self.leverNode.run(SKAction.rotate(byAngle: -.pi/10, duration: 3))
                }
            }
            
        }
        
        weight1Node.run(moveWeight(startAngle: 0, endAngle: -.pi/10, for: weight1Node, clockwise: false)) {
            self.weight1Node.run(self.moveWeight(startAngle: -.pi/10, endAngle: 0, for: self.weight1Node, clockwise: true)) {
                self.weight1Node.run(self.moveWeight(startAngle: 0, endAngle: .pi/10, for: self.weight1Node, clockwise: true)) {
                    self.weight1Node.run(self.moveWeight(startAngle: .pi/10, endAngle: 0, for: self.weight1Node, clockwise: false))
                    
                }
            }
            
        }
        
        weight0Node.run(moveWeight(startAngle: .pi, endAngle: .pi - .pi/10, for: weight0Node, clockwise: false)) {
            self.weight0Node.run(self.moveWeight(startAngle: .pi - .pi/10, endAngle: .pi, for: self.weight0Node, clockwise: true)) {
                self.weight0Node.run(self.moveWeight(startAngle: .pi, endAngle: .pi + .pi/10, for: self.weight0Node, clockwise: true)) {
                    self.weight0Node.run(self.moveWeight(startAngle: .pi + .pi/10, endAngle: .pi, for: self.weight0Node, clockwise: false))
                }
            }
        }
        
    }
    
    func moveWeight(startAngle: Double, endAngle: Double, for node: SKNode, clockwise: Bool) -> SKAction {
        
        let xCenter = leverNode.position.x - node.position.x
        let yCenter = xCenter * CGFloat(tan(startAngle))
        let radius = xCenter / CGFloat(cos(startAngle))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: xCenter, y: yCenter), radius: abs(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise)
        return SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, duration: 3)
        
    }
    
    
    func positionWeigths(leftMass: Float, leftPosition: Float, rightMass: Float, rightPosition: Float) {
        
        let xPositionL: Float = {
            let intermediateResult = 0.5 - leftPosition * 0.066
            return Float(skScene.frame.width) * intermediateResult
        }()
        weight0Node.position = CGPoint(x: CGFloat(xPositionL), y: skScene.frame.height / 2)
        let xPositionR: Float = {
            let intermediateResult = 0.5 + rightPosition * 0.066
            return Float(skScene.frame.width) * intermediateResult
        }()
        weight1Node.position = CGPoint(x: CGFloat(xPositionR), y: skScene.frame.height / 2)
        
        massLeftLabel.text = "\(leftMass) kg"
        
        
        massLeftLabel.fontColor = UIColor(red:0.81, green:0.13, blue:0.34, alpha:1.0)
        massLeftLabel.position = CGPoint(x: 0, y: -3 * weight0Node.size.height / 4)
        massLeftLabel.fontSize = 16
        weight0Node.addChild(massLeftLabel)
        
        massRightLabel.text = "\(rightMass) kg"
        massRightLabel.fontColor = UIColor(red:0.81, green:0.13, blue:0.34, alpha:1.0)
        massRightLabel.position = CGPoint(x: 0, y: -3 * weight1Node.size.height / 4)
        massRightLabel.fontSize = 16
        weight1Node.addChild(massRightLabel)
        
        let mL = leftMass * leftPosition
        let mR = rightMass * rightPosition
        
        balance = mL == mR
        
        
        if !balance {
            heavierSide = mL > mR ? "left" : "right"
        }
    }    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    //
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


