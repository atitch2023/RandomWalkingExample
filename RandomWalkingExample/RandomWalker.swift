 //
//  RandomWalker.swift
//  RandomWalkingExample
//
//  Created by Arlan Titchbourne on 5/13/18.
//  Copyright © 2018 Arlan Titchbourne. All rights reserved.
//

import Cocoa

class RandomWalker: NSObject {
    
    var stepTimer = Timer()
    var oldTimeBetweenSteps = 0.0
    
    func takeAWalk(startingPosition: (x: Int, y: Int)) {
        
        if SharedVariables.getWalkerPositionCount() >= SharedVariables.maxNumberOfWalkers || SharedVariables.getDynamicKey()[startingPosition.x][startingPosition.y] != 0 { return }
        
        SharedVariables.addWalkerPosition(newWalkerPosition: startingPosition)
        
        GraphScene.sceneNeedsUpdate = true
        
        if !stepTimer.isValid || SharedVariables.timeBetweenSteps != oldTimeBetweenSteps {
            changeStepTimer()
        }
        
    }
    
    func changeStepTimer() {
        oldTimeBetweenSteps = SharedVariables.timeBetweenSteps
        startStepTimer()
    }
    
    func startStepTimer() {
        stepTimer.invalidate()
        stepTimer = Timer.init(timeInterval: SharedVariables.timeBetweenSteps, target: self, selector: #selector(takeStep), userInfo: nil, repeats: true)
        RunLoop.main.add(stepTimer, forMode: .commonModes)
    }
    
    @objc func takeStep() {
        var i = 0
       
        if SharedVariables.timeBetweenSteps != oldTimeBetweenSteps {
            changeStepTimer()
        }
        
        while i < SharedVariables.getWalkerPositionCount() {
        
            var didTakeStep = false
            var j = 0
            
            while !didTakeStep && j < 4 {
                let stepDirection = SharedVariables.getRandomChoiceOfFour()
                let result = tryDirection(stepDirection: stepDirection, key: SharedVariables.getDynamicKey(), walkerPosition: SharedVariables.getWalkerPosition(index: i))
                didTakeStep = result.0
                if didTakeStep {
                    SharedVariables.changeWalkerPosition(index: i, newPosition: result.1)
                }
                j = j + 1
            }
            
            let currentDynamicKey = SharedVariables.getDynamicKey()
            let currentWalkerPosition = SharedVariables.getWalkerPosition(index: i)
            
            if currentDynamicKey[SharedVariables.getWalkerPosition(index: i).x - 1][currentWalkerPosition.y] != 0 && currentDynamicKey[SharedVariables.getWalkerPosition(index: i).x + 1][currentWalkerPosition.y] != 0 && currentDynamicKey[SharedVariables.getWalkerPosition(index: i).x][currentWalkerPosition.y + 1] != 0 && currentDynamicKey[SharedVariables.getWalkerPosition(index: i).x][currentWalkerPosition.y - 1] != 0 {
                    SharedVariables.graphScene.updateGraphWithSteps()
                    SharedVariables.removeWalkerPosition(index: i)
                    if SharedVariables.getWalkerPositionCount() == 0 {
                        stepTimer.invalidate()
                }
            }
            i = i + 1
        }
        GraphScene.sceneNeedsUpdate = true
        
    }
    
    private func tryDirection(stepDirection: StepDirection, key: [[Int]], walkerPosition: (x: Int, y: Int)) ->(Bool, (x: Int, y: Int)) {
        var didTakeStep = false
        var newWalkerPosition = walkerPosition
        if stepDirection == StepDirection.right {
            if key[walkerPosition.x + 1][walkerPosition.y] == 0 {
                SharedVariables.changeDynamicKey(position: (x: walkerPosition.x + 1, y: walkerPosition.y), value: 2)
                newWalkerPosition.x = walkerPosition.x + 1
                didTakeStep = true
            }
        } else if stepDirection == StepDirection.left {
            if key[walkerPosition.x - 1][walkerPosition.y] == 0 {
                SharedVariables.changeDynamicKey(position: (x: walkerPosition.x - 1, y: walkerPosition.y), value: 2)
                newWalkerPosition.x = walkerPosition.x - 1
                didTakeStep = true
            }
        } else if stepDirection == StepDirection.up {
            if key[walkerPosition.x][walkerPosition.y + 1] == 0 {
                SharedVariables.changeDynamicKey(position: (x: walkerPosition.x, y: walkerPosition.y + 1), value: 2)
                newWalkerPosition.y = walkerPosition.y + 1
                didTakeStep = true
            }
        } else {
            if key[walkerPosition.x][walkerPosition.y - 1] == 0 {
                SharedVariables.changeDynamicKey(position: (x: walkerPosition.x, y: walkerPosition.y - 1), value: 2)
                newWalkerPosition.y = walkerPosition.y - 1
                didTakeStep = true
            }
        }
        return (didTakeStep, newWalkerPosition)
    }
    

}
