//
//  SharedVariables.swift
//  RandomWalkingExample
//
//  Created by Arlan Titchbourne on 5/14/18.
//  Copyright © 2018 Arlan Titchbourne. All rights reserved.
//

import Cocoa
import SpriteKit

enum StepDirection {
    case up
    case down
    case left
    case right
}

class SharedVariables: NSObject {

    static let keyMaster = KeyMaster()
    
    static let generator = Generator()
    
    static let graphScene = GraphScene()
    
    static let dynamicKeyLock = NSLock.init()
    
    static let walkerPositionLock = NSLock.init()
    
    static let keyDimension: (x: Int, y: Int) = (x: 30, y: 30)
    
    static let baseTimeBetweenSteps = TimeInterval(0.03)
    
    static var timeBetweenSteps = TimeInterval(0.066) 
    
    static var timeBetweenSpawnedWalkers = TimeInterval(3)
    
    static let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    
    static var originalKey: [[Int]] = []
    
    private static var dynamicKey: [[Int]] = []
    
    static func getDynamicKey() ->[[Int]] {
        dynamicKeyLock.lock()
        let tempDynamicKey = self.dynamicKey
        dynamicKeyLock.unlock()
        return tempDynamicKey
    }
    
    static func setDynamicKey(newDynamicKey: [[Int]]) {
        dynamicKeyLock.lock()
        dynamicKey = newDynamicKey
        dynamicKeyLock.unlock()
    }
    
    static func changeDynamicKey(position: (x: Int, y: Int), value: Int) {
        dynamicKeyLock.lock()
        dynamicKey[position.x][position.y] = value
        dynamicKeyLock.unlock()
    }
    
    static let maxNumberOfWalkers = 10
    
    static let numberOfRandomChoices = 10000
    
    static var randomChoiceCounter = numberOfRandomChoices
    
    private static var randomChoices = Array<StepDirection>.init(repeating: StepDirection.up, count: numberOfRandomChoices)
    
    static func getRandomChoiceOfFour() ->StepDirection {
        if randomChoiceCounter == numberOfRandomChoices {
            fillRandomValues()
            randomChoiceCounter = 0
            return randomChoices[randomChoiceCounter ]
        } else {
            randomChoiceCounter = randomChoiceCounter + 1
            return randomChoices[randomChoiceCounter - 1]
        }
    }
    
    private static func fillRandomValues() {
        var i = 0
        while i < numberOfRandomChoices {
            randomChoices[i] = generator.getChoiceOfFour()
            i = i + 1
        }
    }
    
    private static var walkerPositions = Array<(x: Int, y: Int)>()
    
    static func getWalkerPosition(index: Int) ->(x: Int, y: Int) {
        walkerPositionLock.lock()
        let walkerPosition = walkerPositions[index]
        walkerPositionLock.unlock()
        
        return walkerPosition
    }
    
    static func getWalkerPositionCount() ->Int {
        walkerPositionLock.lock()
        let walkerPositionsCount = walkerPositions.count
        walkerPositionLock.unlock()
        
        return walkerPositionsCount
    }
    
    static func addWalkerPosition(newWalkerPosition: (x: Int, y: Int)) {
        walkerPositionLock.lock()
        walkerPositions.append(newWalkerPosition)
        walkerPositionLock.unlock()
    }
    
    static func changeWalkerPosition(index: Int, newPosition: (x: Int, y: Int)) {
        if getWalkerPositionCount() >= index {
            walkerPositionLock.lock()
            walkerPositions[index] = newPosition
            walkerPositionLock.unlock()
        } else {
            print("trying to change walker position that does not exist.")
        }
        
    }
    
    static func removeWalkerPosition(index: Int) {
        if getWalkerPositionCount() >= index {
            walkerPositionLock.lock()
            walkerPositions.remove(at: index)
            walkerPositionLock.unlock()
        } else {
            print("trying to remove walker that does not exist.")
        }
    }
    
    static func removeAllWalkers() {
        walkerPositionLock.lock()
        walkerPositions.removeAll()
        walkerPositionLock.unlock()
    }
    
    static let pickUpDuration = 0.3
    
    static let setDownDuration = 0.4
    
    // Between 300000000 and 700000000 should be about right.
    static let keyDensityFloor = 100000000
    
    static var originalSpriteSize = NSSize.init(width: 0, height: 0)
    
    static let spin = SKAction.rotate(byAngle: .pi, duration: 1.2)
    static let shrinkWidth = SKAction.resize(toWidth: 0.1, duration: 0.6)
    static let shrinkHeight = SKAction.resize(toHeight: 0.1, duration: 0.6)
    static let colorize = SKAction.colorize(with: NSColor.blue, colorBlendFactor: 1.0, duration: TimeInterval(0.3))
    static let decolorize = SKAction.colorize(with: NSColor.orange, colorBlendFactor: 1.0, duration: TimeInterval(1.5))
    static let stretchWidth = SKAction.resize(toWidth: originalSpriteSize.width, duration: 0.6)
    static let stretchHeight = SKAction.resize(toHeight: originalSpriteSize.height, duration: 0.6)
    static let enlarge = SKAction.resize(byWidth: originalSpriteSize.width * 2.0, height: originalSpriteSize.height * 2.0, duration: pickUpDuration)
    static let shrink = SKAction.resize(byWidth: originalSpriteSize.width * -2, height: originalSpriteSize.height * -2, duration: setDownDuration)
    
    static let modulateColor = SKAction.sequence([colorize, decolorize])
    static let squish = SKAction.sequence([shrinkWidth, stretchWidth, shrinkHeight, stretchHeight])
    
    static let squishSpin = SKAction.group([squish, spin])
    
    static let sourcePositions: [float2] = [
        float2(0, 1), float2(0.5, 1), float2(1, 1), float2(0, 0.5),float2(0.5, 0.5), float2(1, 0.5), float2(0, 0), float2(0.5, 0), float2(1, 0)
    ]
    
//    static let destinationPositions: [float2] = [
//        float2(0, 1), float2(0.5, 0.85), float2(1, 1), float2(0.15, 0.5),float2(0.5, 0.5), float2(0.85, 0.5), float2(0, 0), float2(0.5, 0.15), float2(1, 0)
//    ]
    
    static let destinationPositions: [float2] = [
        float2(0, 1), float2(0.6, 0.85), float2(1, 1), float2(0.15, 0.6),float2(0.5, 0.5), float2(0.85, 0.6), float2(0, 0), float2(0.6, 0.15), float2(1, 0)
    ]
    
    static let warpGeometryGrid = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: sourcePositions, destinationPositions: destinationPositions)
    
    static let warpGeometryGridNoWarps = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: sourcePositions, destinationPositions: sourcePositions)
    
    static let warpSquare = SKAction.warp(to: warpGeometryGrid, duration: 1.0)
    
    static let warpSquareReturn = SKAction.warp(to: warpGeometryGridNoWarps, duration: 1.0)
    
    static let warpSquareAndReturnIt = SKAction.sequence([warpSquare!, warpSquareReturn!])
    
    static let warpSquareForEver = SKAction.repeatForever(warpSquareAndReturnIt)
    

    
}
