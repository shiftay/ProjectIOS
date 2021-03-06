//
//  MiddleBtn.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-22.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class MiddleBtn: SKSpriteNode, InteractiveNode
{
    //change name for other lane
    static let middleLane = "MiddleLane"
    
    func sceneLoaded()
    {
        guard let scene = scene else
        {
            return
        }
        
        alpha = 0.01
        size = CGSize(width: scene.size.width * 0.33, height: scene.size.height * 0.25)
        position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height / 8)
        isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(positionBtn), name: Notification.Name(Runner.movedCamera), object: nil)
    }
    
    func positionBtn()
    {
        guard let scene = scene else
        {
            return
        }
        
        position = CGPoint(x: scene.size.width * 0.5,
                           y: (scene.camera?.position.y)! - ((scene.size.height * 0.25) + ((scene.size.height * 0.25) * 0.5)))
    }
    
    func interact()
    {
        if !Runner.gameState
        {
            NotificationCenter.default.post(Notification(name: NSNotification.Name(MiddleBtn.middleLane), object: nil))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
