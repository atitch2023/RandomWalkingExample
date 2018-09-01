//
//  ViewController.swift
//  RandomWalkingExample
//
//  Created by Arlan Titchbourne on 5/8/18.
//  Copyright © 2018 Arlan Titchbourne. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    
    let controlBarHeight: CGFloat = 80.0
    var sKView = SKView()
    
    @IBOutlet var walkerSpeed: NSNumber? = 55.0 {
        didSet {
            if let walkerSpeed = walkerSpeed {
                SharedVariables.timeBetweenSteps = (100.0 / (walkerSpeed as! Double)) * SharedVariables.baseTimeBetweenSteps
            }
        }
    }
    
    @IBOutlet var walkerSpawnSpeed: NSNumber? = 10.0 {
        didSet {
            if let walkerSpawnSpeed = walkerSpawnSpeed {
                SharedVariables.timeBetweenSpawnedWalkers = 10.0 / (walkerSpawnSpeed as! Double)
                SharedVariables.graphScene.toggleSpawningRandomWalkers(needsNewSpeed: true)
            }
        }
    }
    
    @IBAction func getNewKey(sender: AnyObject) {
        sKView.presentScene(SharedVariables.graphScene)
    }
    
    @IBAction func toggleSpawningRandomWalkers(sender: AnyObject) {
        SharedVariables.graphScene.toggleSpawningRandomWalkers(needsNewSpeed: false)
    }

    override func viewDidLoad() {
        if let window = view.window {
            var newWindowFrame = window.frame
            newWindowFrame.size =  NSSize.init(width: newWindowFrame.size.width, height: newWindowFrame.size.height + (newWindowFrame.size.height * 2.0))
            window.setFrame(newWindowFrame, display: true)
        }
        
        sKView = SKView.init(frame: NSMakeRect(0.0, controlBarHeight, view.frame.size.width, view.frame.size.height - controlBarHeight))
        view.addSubview(sKView)
        SharedVariables.graphScene.size = sKView.frame.size
        SharedVariables.graphScene.scaleMode = .resizeFill
        sKView.ignoresSiblingOrder = true
        sKView.presentScene(SharedVariables.graphScene)
        super.viewDidLoad()
    }

    
}

