//
//  ClickableNode.swift
//  RandomWalkingExample
//
//  Created by Arlan Titchbourne on 5/13/18.
//  Copyright © 2018 Arlan Titchbourne. All rights reserved.
//

import Cocoa
import SpriteKit

class ClickableNode: SKNode {
    var nodeIndices = (x: 0, y: 0)
    
    var mouseDownTimer = Timer()
    var isAClick = false
    
    var positionNodePickedUpFrom = NSMakePoint(0.0, 0.0)
    
    var blockNodeHolder: [BlockNode] = Array<BlockNode>()
    var tileNodeHolder: [SKSpriteNode] = Array<SKSpriteNode>()
    
    override func mouseUp(with event: NSEvent) {
        
        if blockNodeHolder.count == 0 && isAClick {
            startRandomWalker()
        } else if blockNodeHolder.count != 0 {
            if blockNodeHolder[0].isPickedUp &&  !blockNodeHolder[0].isLowering {
                self.name = "pickedUpMasterNode"
                let nodesAtPosition = SharedVariables.graphScene.nodes(at: event.location(in: SharedVariables.graphScene))
                var i = 0
                while i < nodesAtPosition.count {
                    if nodesAtPosition[i].name == "masterNode" {
                        let clickableNode = nodesAtPosition[i] as! ClickableNode
                        if clickableNode.blockNodeHolder.count == 0 {
                            self.name = "masterNode"
                            setDown(newMasterNode: clickableNode)
                            i = nodesAtPosition.count
                        }
                    }
                    if i == nodesAtPosition.count - 1 {
                        self.name = "masterNode"
                        setDown(newMasterNode: self)
                    }
                    i = i + 1
                }
            }
        }
        super.mouseUp(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        isAClick = true
        if mouseDownTimer.isValid {
            mouseDownTimer.invalidate()
        }
        mouseDownTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.3), target: self, selector: #selector(changeIsAClick), userInfo: nil, repeats: false)
        
        super.mouseDown(with: event)
    }
    
    @objc func changeIsAClick() {
        isAClick = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        if blockNodeHolder.count != 0 {
            if !blockNodeHolder[0].isPickedUp {
                pickUpNode()
            } else {
                let myBlock = blockNodeHolder[0]
                myBlock.position.x = myBlock.position.x + event.deltaX
                myBlock.position.y = myBlock.position.y - event.deltaY
                super.mouseDragged(with: event)
            }
        }
    }
    
    func pickUpNode() {
        if !blockNodeHolder[0].hasBeenPickedUp {
            blockNodeHolder[0].hasBeenPickedUp = true
            blockNodeHolder[0].color = NSColor.white
            blockNodeHolder[0].isPickedUp = true
            tileNodeHolder[0].isHidden = false
            let currentBlockNode = blockNodeHolder[0]
            tileNodeHolder[0].color = NSColor.cyan
            currentBlockNode.enlarge()
        }
    }
    
    func setDown(newMasterNode: ClickableNode) {
        let positionOfNodeMouseIsOver = SharedVariables.graphScene.gridPositions[newMasterNode.nodeIndices.x][newMasterNode.nodeIndices.y]
        blockNodeHolder[0].isLowering = true
        
        if let parent = self.parent {
            let convertedPoint = convert(positionOfNodeMouseIsOver, from: parent)
            let moveToPoint = SKAction.move(to: convertedPoint, duration: SharedVariables.setDownDuration)
            blockNodeHolder[0].run(moveToPoint)
        }
        
        blockNodeHolder[0].shrink()
        if newMasterNode != self {
            blockNodeHolder[0].removeFromParent()
            newMasterNode.addChild(blockNodeHolder[0])
            newMasterNode.blockNodeHolder.append(blockNodeHolder[0])
            blockNodeHolder.removeAll()
        }
        
    }
    
    func startRandomWalker() {
        if !self.hasActions() {
            SharedVariables.graphScene.startRandomWalkerAtPosition(startPosition: nodeIndices)
        }
    }
    

}

