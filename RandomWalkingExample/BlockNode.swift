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
    
    func enlarge() {
//        if let parent = self.parent as! ClickableNode? {
//            SharedVariables.changeDynamicKey(position: (x: parent.nodeIndices.x, y: parent.nodeIndices.y), value: 0)
//        }
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
