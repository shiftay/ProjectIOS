//
//  ss_Alpha.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class SSAlpha: SpaceStation {
    
    override func interact() {
        if !descOpen {
            guard let scene = scene as? World else {
                return
            }
            
            scene.spaceStationTouched = true
            openDesc(name: name!)
            GameViewController.Player.currentPlanetSelected = name!
        }
    }
    
    override func sceneLoaded() {
        name = "SpaceStation Alpha"
        isUserInteractionEnabled = true
        randomizeRates()
    }
    
}
