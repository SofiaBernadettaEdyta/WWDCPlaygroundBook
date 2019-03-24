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
    var weight0LastMovement: SKAction!
    var weight1LastMovement: SKAction!
    var leverLastMovement: SKAction!
    var backgroundNode: SKShapeNode!
    var leftMass = 2
    var leftPosition = 1
    var rightMass = 1
    var rightPosition = 4
    var isMoving = false
    
    override public func viewDidLoad() {
        
        skSetUp()
        drawLever()
    }
    

    public override func viewDidLayoutSubviews() {
        skScene = SKScene(size: view.bounds.size)
        leverNode.size = CGSize(width: skScene.frame.width * 0.7, height: 10)
        positionWeigths(leftMass: Float(leftMass), leftPosition: Float(leftPosition), rightMass: Float(rightMass), rightPosition: Float(rightPosition))
        leverNode.run(SKAction.rotate(toAngle: 0, duration: 0))
        leverNode.removeAllActions()
        weight0Node.removeAllActions()
        weight1Node.removeAllActions()
        if isMoving {
            rotateLever()
        } else {
            leverNode.run(SKAction.rotate(toAngle: 0, duration: 0))
        }
        
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
            skView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            skView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            skView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            skView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
            ])
        
    }
    
    func drawLever() {
        
        backgroundNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: view.bounds.size))
        backgroundNode.fillColor = UIColor.white
        skScene.addChild(backgroundNode)
        
        
        let leverImage = UIImage(named: "lever")
        let leverTexture = SKTexture(image: leverImage!)
        leverNode = SKSpriteNode(texture: leverTexture, size: CGSize(width: skScene.frame.width * 0.7, height: 10))
        leverNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leverNode.position = CGPoint(x: skScene.frame.width / 2, y: skScene.frame.height / 2)
        backgroundNode.addChild(leverNode)
        
        let weightImage = UIImage(named: "weight")
        let weightTexture = SKTexture(image: weightImage!)
        weight0Node = SKSpriteNode(texture: weightTexture, size: CGSize(width: skScene.size.width * 0.1, height: skScene.size.height * 0.1))
        weight0Node.anchorPoint = CGPoint(x: 0.5, y: 0.92)
        //        weight0Node.position = CGPoint(x: skScene.frame.width / 4, y: skScene.frame.height / 2)
        backgroundNode.addChild(weight0Node)
        
        
        weight1Node = SKSpriteNode(texture: weightTexture, size: CGSize(width: skScene.size.width * 0.1, height: skScene.size.height * 0.1))
        weight1Node.anchorPoint = CGPoint(x: 0.5, y: 0.92)
        //        weight1Node.position = CGPoint(x: 3 * skScene.frame.width / 4, y: skScene.frame.height / 2)
        backgroundNode.addChild(weight1Node)
        weight1Node.addChild(massRightLabel)
        weight0Node.addChild(massLeftLabel)
        
        
        
        let pivotImage = UIImage(named: "pivot")
        let pivotTexture = SKTexture(image: pivotImage!)
        pivotNode = SKSpriteNode(texture: pivotTexture, size: CGSize(width: skScene.size.width * 0.02, height: skScene.size.height * 0.1))
        pivotNode.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        pivotNode.position = CGPoint(x: skScene.frame.width / 2, y: skScene.frame.height / 2)
        skScene.addChild(pivotNode)
        
        
        
        
    }
    
    @objc func rotateLever() {
        isMoving = true
        let time = 0.3
        let angle = CGFloat.pi / 40
        leverNode.run(SKAction.rotate(toAngle: 0, duration: 0))
        leverNode.run(SKAction.rotate(byAngle: -angle, duration: time)) {
            self.leverNode.run(SKAction.rotate(byAngle: angle, duration: time)) {
                self.leverNode.run(SKAction.rotate(byAngle: angle, duration: time)) {
                    self.leverNode.run(SKAction.rotate(byAngle: -angle, duration: time)) {
                        self.leverNode.run(SKAction.rotate(byAngle: -angle, duration: time)) {
                            self.leverNode.run(SKAction.rotate(byAngle: angle, duration: time)) {
                                self.leverNode.run(SKAction.rotate(byAngle: angle, duration: time)) {
                                    self.leverNode.run(SKAction.rotate(byAngle: -angle, duration: time)) {
                                        self.leverNode.run(self.leverLastMovement)
                                        self.isMoving = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        weight1Node.run(moveWeight(startAngle: 0, endAngle: Double(-angle), for: weight1Node, clockwise: false, duration: time)) {
            self.weight1Node.run(self.moveWeight(startAngle: Double(-angle), endAngle: 0, for: self.weight1Node, clockwise: true, duration: time)) {
                self.weight1Node.run(self.moveWeight(startAngle: 0, endAngle: Double(angle), for: self.weight1Node, clockwise: true, duration: time)) {
                    self.weight1Node.run(self.moveWeight(startAngle: Double(angle), endAngle: 0, for: self.weight1Node, clockwise: false, duration: time)) {
                        self.weight1Node.run(self.moveWeight(startAngle: 0, endAngle: Double(-angle), for: self.weight1Node, clockwise: false, duration: time)) {
                            self.weight1Node.run(self.moveWeight(startAngle: Double(-angle), endAngle: 0, for: self.weight1Node, clockwise: true, duration: time)) {
                                self.weight1Node.run(self.moveWeight(startAngle: 0, endAngle: Double(angle), for: self.weight1Node, clockwise: true, duration: time)) {
                                    self.weight1Node.run(self.moveWeight(startAngle: Double(angle), endAngle: 0, for: self.weight1Node, clockwise: false, duration: time)) {
                                        self.weight1Node.run(self.weight1LastMovement)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        weight0Node.run(moveWeight(startAngle: .pi, endAngle: Double(.pi - angle), for: weight0Node, clockwise: false, duration: time)) {
            self.weight0Node.run(self.moveWeight(startAngle: Double(.pi - angle), endAngle: .pi, for: self.weight0Node, clockwise: true, duration: time)) {
                self.weight0Node.run(self.moveWeight(startAngle: .pi, endAngle: Double(.pi + angle), for: self.weight0Node, clockwise: true, duration: time)) {
                    self.weight0Node.run(self.moveWeight(startAngle: Double(.pi + angle), endAngle: .pi, for:  self.weight0Node, clockwise: false, duration: time)) {
                        self.weight0Node.run(self.moveWeight(startAngle: .pi, endAngle: Double(.pi - angle), for: self.weight0Node, clockwise: false, duration: time)) {
                            self.weight0Node.run(self.moveWeight(startAngle: Double(.pi - angle), endAngle: .pi, for: self.weight0Node, clockwise: true, duration: time)) {
                                self.weight0Node.run(self.moveWeight(startAngle: .pi, endAngle: Double(.pi + angle), for: self.weight0Node, clockwise: true, duration: time)) {
                                    self.weight0Node.run(self.moveWeight(startAngle: Double(.pi + angle), endAngle: .pi, for:  self.weight0Node, clockwise: false, duration: time)){
                                        self.weight0Node.run(self.weight0LastMovement)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func moveWeight(startAngle: Double, endAngle: Double, for node: SKNode, clockwise: Bool, duration: Double) -> SKAction {
        
        let xCenter = leverNode.position.x - node.position.x
        let yCenter = xCenter * CGFloat(tan(startAngle))
        let radius = xCenter / CGFloat(cos(startAngle))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: xCenter, y: yCenter), radius: abs(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise)
        return SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, duration: duration)
        
    }
    
    
    func positionWeigths(leftMass: Float, leftPosition: Float, rightMass: Float, rightPosition: Float) {
        
        let xPositionL: Float = {
            
            let intermediateResult = leftPosition * Float(leverNode.size.width) / 11
            return Float(leverNode.position.x) - intermediateResult
            
        }()
        weight0Node.position = CGPoint(x: CGFloat(xPositionL), y: leverNode.position.y)
        let xPositionR: Float = {
            let intermediateResult = rightPosition * Float(leverNode.size.width) / 11
            return Float(leverNode.position.x) + intermediateResult
            
        }()
        weight1Node.position = CGPoint(x: CGFloat(xPositionR), y: leverNode.position.y)
        
        massLeftLabel.text = "\(leftMass) kg"
        massLeftLabel.fontColor = UIColor(red:0.81, green:0.13, blue:0.34, alpha:1.0)
        massLeftLabel.position = CGPoint(x: 0, y: -3 * weight0Node.size.height / 4)
        massLeftLabel.fontSize = 16
        
        massRightLabel.text = "\(rightMass) kg"
        massRightLabel.fontColor = UIColor(red:0.81, green:0.13, blue:0.34, alpha:1.0)
        massRightLabel.position = CGPoint(x: 0, y: -3 * weight1Node.size.height / 4)
        massRightLabel.fontSize = 16
        
        
        let mL = leftMass * leftPosition
        let mR = rightMass * rightPosition
        
        balance = mL == mR
        
        
        if !balance {
            let time = 0.3 * 4
            let angle = CGFloat.pi / 10
            heavierSide = mL > mR ? "left" : "right"
            
            if heavierSide == "left" {
                leverLastMovement = SKAction.rotate(byAngle: angle, duration: time)
                weight0LastMovement = moveWeight(startAngle: Double(.pi - angle), endAngle: .pi, for: self.weight0Node, clockwise: true, duration: time)
                weight1LastMovement = self.moveWeight(startAngle: Double(-angle), endAngle: 0, for: self.weight1Node, clockwise: true, duration: time)
            } else if heavierSide == "right" {
                leverLastMovement = SKAction.rotate(byAngle: -angle, duration: time)
                weight0LastMovement = moveWeight(startAngle: .pi, endAngle: Double(.pi - angle), for: weight0Node, clockwise: false, duration: time)
                weight1LastMovement = moveWeight(startAngle: 0, endAngle: Double(-angle), for: weight1Node, clockwise: false, duration: time)
            }
            
        } else {
            leverLastMovement = SKAction.scale(by: 1, duration: 0)
            weight0LastMovement = SKAction.scale(by: 1, duration: 0)
            weight1LastMovement = SKAction.scale(by: 1, duration: 0)
        }
        
        
        
    }
    
    public func receive(_ message: PlaygroundValue) {
        guard case let .array(mass) = message else { return }
        guard case let .integer(leftMass) = mass[0] else {return}
        guard case let .integer(leftPosition) = mass[1] else {return}
        guard case let .integer(rightMass) = mass[2] else {return}
        guard case let .integer(rightPosition) = mass[3] else {return}

        self.leftMass = leftMass
        self.leftPosition = leftPosition
        self.rightMass = rightMass
        self.rightPosition = rightPosition
        
        positionWeigths(leftMass: Float(leftMass), leftPosition: Float(leftPosition), rightMass: Float(rightMass), rightPosition: Float(rightPosition))
        rotateLever()
    }
}

//
//  ViewController.swift
//  XMasTree
//
//  Created by Zofia Drabek on 13/03/2019.
//  Copyright © 2019 Zofia Drabek. All rights reserved.
//


