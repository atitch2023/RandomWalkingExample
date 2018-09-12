//
//  BlockNode.swift
//  RandomWalkingExample
//
//  Created by Arlan Titchbourne on 5/31/18.
//  Copyright © 2018 Arlan Titchbourne. All rights reserved.
//

import Cocoa
import SpriteKit

class BlockNode: SKSpriteNode {
    var isLowering = false
    var isPickedUp = false
    var hasBeenPickedUp = false
    private var oldZPosition: CGFloat = 0.0
    
    init(texture: SKTexture, color: NSColor, gridSquareSize: NSSize) {
        let innerSquareSize = CGSize.init(width: gridSquareSize.width - 6.0, height: gridSquareSize.height - 6.0)
        super.init(texture: texture, color: color, size: gridSquareSize)
        self.colorBlendFactor = 1
        self.color = NSColor.black
        self.run(SharedVariables.warpSquareForEver)
        self.name = "blockNode"
        let innerBlockNode = SKSpriteNode.init(color: NSColor.magenta, size: innerSquareSize)
        self.addChild(innerBlockNode)
        innerBlockNode.position = CGPoint.init(x: 1, y: 1)
        innerBlockNode.run(SharedVariables.warpSquareForEver)
        innerBlockNode.name = "innerBlockNode"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enlarge() {
        oldZPosition = self.zPosition
        self.zPosition = 10000
        self.run(SharedVariables.enlarge)
        self.children[0].run(SharedVariables.enlarge)
    }
    
    func shrink() {
        self.run(SharedVariables.shrink)
        self.children[0].run(SharedVariables.shrink) {
            self.isLowering = false
            self.isPickedUp = false
            if let parent = self.parent as! ClickableNode? {
                SharedVariables.changeDynamicKey(position: (x: parent.nodeIndices.x, y: parent.nodeIndices.y), value: 1)
                parent.tileNodeHolder[0].isHidden = true
            }
            self.zPosition = self.oldZPosition
        }
    }
    
    
}
