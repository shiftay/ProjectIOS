//
//  World-Touch.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//
import Foundation
import SpriteKit

extension World {
    
    func worldTouch(firstTouch: UITouch) {
        if !(cameraNode?.hasActions())! {
        
            if !planetTouched && !spaceStationTouched {

                moveCamera(firstTouch: firstTouch)
            }
        
            if planetTouched && !visitingPlanet {
                handleDescBox(firstTouch: firstTouch, isSpaceStation: false)
            }

            if spaceStationTouched && !visitingSpaceStation {
                handleDescBox(firstTouch: firstTouch, isSpaceStation: true)
            }
            
            if planetTouched || spaceStationTouched {
                if eventPoppedUp {
                    handleREvent()
                }
            }
        
            if visitingSpaceStation {
                let hud = childNode(withName: "HUD") as? SKSpriteNode
                if let _ = hud?.childNode(withName: "ShopPopup") {
                    handleShopPopup(firstTouch: firstTouch)
                } else if let _ = hud?.childNode(withName: "QuestPopup") {
                    handleQuestPopup(firstTouch: firstTouch)
                } else {
                    handleSSOL(firstTouch: firstTouch)
                }
            }
        
            if visitingPlanet {
                handlePlanetOL(firstTouch: firstTouch)
            }
        }
    }
    
    
    func handleREvent() {
        //TODO handle random event
    }
    
    
    func handleQuestPopup(firstTouch: UITouch) {
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            switch touchedNode.name! {
            case "okay0":
                GameViewController.Player.currentQuest = spaceStation?.quests[0]
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }
            case "okay1":
                GameViewController.Player.currentQuest = spaceStation?.quests[1]
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }
            case "cancel0":
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }
            case "cancel1":
                    if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                        popup.removeFromParent()
                }
            default:
                break
            }
        }
    }
    
    
    func handleShopPopup(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let text = hud?.childNode(withName: "ShopPopup")?.childNode(withName: "numText") as? SKLabelNode
        let sellText = hud?.childNode(withName: "ShopPopup")?.childNode(withName: "maxText") as? SKLabelNode
        
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            
            switch touchedNode.name! {
            case "plus":
                //TODO: Logic preventing above max amount
                if amountToSell + 1 >= returnMax() {
                    amountToSell = returnMax()
                } else {
                    amountToSell += 1
                }
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "minus":
                if amountToSell - 1 < 0 {
                    amountToSell = 0
                } else {
                    amountToSell -= 1
                }
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "MAX":
                amountToSell = returnMax()
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "CLEAR":
                amountToSell = 0
                sellText?.text = "$0"
                text?.text = "\(amountToSell)"
            case "okay":
                //TODO: sell / buy
                if buy {
                    buyItem()
                } else {
                    sellItem()
                }
                
                if let popup = hud?.childNode(withName: "ShopPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                    //TODO: set stored values to none / 0
                    amountToSell = 0
                }
                print("okay")
            case "cancel":
                if let popup = hud?.childNode(withName: "ShopPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                    amountToSell = 0
                    //TODO: set stored values to none / 0
                }
            default:
                break
            }
            
        }
    }
    
    

    
    func handlePlanetOL(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let planet = childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase
        
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKNode {
            switch touchedNode.name! {
            case "Leave":
                hud?.removeFromParent()
                GameViewController.Player.image.run(SKAction.sequence([SKAction.scale(to: 0.8, duration: 1),
                                                                       SKAction.run {
                                                                        GameViewController.Player.image.yScale *= -1
                                                    }]))
                planetTouched = false
                planet?.descOpen = false
                GameViewController.Player.currentPlanetSelected = "none"
                visitingPlanet = false
            case "Gather":
                hud?.addChild(createGatherBox(HUDsize: (hud?.size)!))
            case "Quest":
                break
            case "Quit":
                if let node = hud?.childNode(withName: "GatherPopup") as? SKSpriteNode {
                    node.removeFromParent()
                }
            case "Oil":
                if let scene = SKScene(fileNamed: "RunnerScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    GameViewController.Player.planetResources = "Oil"
                    GameViewController.Player.image.removeFromParent()
                    // Present the scene
                    view?.presentScene(scene)
                }
            case "Fuel":
                print("fuel")
            case "Minerals":
                if let scene = SKScene(fileNamed: "RunnerScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view?.presentScene(scene)
                }
            case "Metal":
                if let scene = SKScene(fileNamed: "RunnerScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view?.presentScene(scene)
                }
            default:
                break
            }
        }
    
        //TODO: Gather: Fuel -> Loads other scene
        //              Materials -> Loads other scene
        //      Leave:  Closes the HUD
        //      Quest:  Hand in quest or accept cargo
    }
    
    
        
    

    func handleSSOL(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        let player = GameViewController.Player
        //TODO: In order for touch to work with inventory, each space station needs the same amount of things to sell
        //      Player can only SELL the resources
        //      if other thing is open, okay, cancel, max, + / -
        //
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKNode {
            switch touchedNode.name! {
            case "Shop":
                if let quest = hud?.childNode(withName: "QuestPage") as? SKSpriteNode {
                    quest.removeFromParent()
                    let half = hud?.childNode(withName: "Shop") as? SKSpriteNode
                    hud?.addChild((spaceStation?.generateShopPage(HUDSize: hud!.size, halfSize: half!.size))!)
                }
            case "Quest":
                if let shop = hud?.childNode(withName: "ShopPage") as? SKSpriteNode {
                    shop.removeFromParent()
                    let half = hud?.childNode(withName: "Shop") as? SKSpriteNode
                    hud?.addChild((spaceStation?.generateQuestPage(HUDSize: hud!.size, halfSize: half!.size))!)
                }
            case "buy1":
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "fuel"
                buy = true
                print("buy fuel")
            case "buy2":
                if (player?.ShipStock.spaceLeft())! <= 0 {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Inventory FULL"))
                } else {
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    shopItem = "minerals"
                    buy = true
                }
            case "buy3":
                if (player?.ShipStock.spaceLeft())! <= 0 {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Inventory FULL"))
                } else {
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    shopItem = "oil"
                    buy = true
                }
                print("buy oil")
            case "buy4":
                if (player?.ShipStock.spaceLeft())! <= 0 {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Inventory FULL"))
                } else {
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    shopItem = "metal"
                    buy = true
                }
                print("buy metal")
            case "sell1":
                if ((player?.currentMinerals)! <= 0) {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Nothing to Sell"))
                } else {
                    print("sell minerals")
                    shopItem = "minerals"
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    buy = false
                }

            case "sell2":
                if ((player?.currentOil)! <= 0) {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Nothing to Sell"))
                } else {
                    print("sell oil")
                    shopItem = "oil"
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    buy = false
                }
            case "sell3":
                if ((player?.currentMetalParts)! <= 0) {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Nothing to Sell"))
                } else {
                    print("sell metal")
                    shopItem = "metal"
                    hud?.addChild(createSellBox(HUDsize: hud!.size))
                    buy = false
                }
            case "quest1":
                if GameViewController.Player.currentQuest == nil {
                    hud?.addChild(createQuestBox(HUDsize: hud!.size, QuestNumber: 0))
                } else {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "You already have a quest"))
                }
                //TODO: Only allow if player doesnt have any quests.

            case "quest2":
                if GameViewController.Player.currentQuest == nil {
                    hud?.addChild(createQuestBox(HUDsize: hud!.size, QuestNumber: 1))
                } else {
                    hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "You already have a quest"))
                }
            
            case "Leave":
                hud?.removeFromParent()
                GameViewController.Player.image.run(SKAction.sequence([SKAction.scale(to: 0.8, duration: 1),
                                                                       SKAction.run {
                                                                        GameViewController.Player.image.yScale *= -1
                    }]))
                spaceStationTouched = false
                GameViewController.Player.currentPlanetSelected = "none"
                visitingSpaceStation = false
                spaceStation?.descOpen = false
                
            case "leaveInv":
                if let node = hud?.childNode(withName: "InvenFull") as? SKSpriteNode {
                    node.removeFromParent()
                }
            default:
                break
            }
            
        }
    }
    
        
    

    func handleDescBox(firstTouch: UITouch, isSpaceStation: Bool) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            switch touchedNode.name! {
            case "yes":
                
                
                
                
                if isSpaceStation {
                    flyShipToStation()
                } else {
                    flyShip()
                }
                
                if (hud?.childNode(withName: "InvenFull") as? SKSpriteNode) == nil {
                    if let hud = scene?.childNode(withName: "HUD") {
                        hud.removeFromParent()
                        followPlayer = true
                    }
                }
            case "no":
                if let hud = scene?.childNode(withName: "HUD") {
                    hud.removeFromParent()
                }
                
                if isSpaceStation {
                    if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation {
                        planet.descOpen = false
                    }
                    spaceStationTouched = false
                } else {
                    if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase {
                        planet.descOpen = false
                    }
                    planetTouched = false
                }
                
                GameViewController.Player.currentPlanetSelected = "none"
                
            case "leaveInv":
                if let node = hud?.childNode(withName: "InvenFull") as? SKSpriteNode {
                    node.removeFromParent()
                }
            default:
                break
            }
        }
    }

    func moveCamera(firstTouch: UITouch) {
        if checkBounds(pos: firstTouch.location(in: self)) {
            cameraNode?.run(SKAction.sequence([SKAction.move(to: firstTouch.location(in: self), duration: 0.5),
                                               SKAction.run {
                                                World.cameraPos = self.cameraNode?.position
                }]))
        }
    }
    
        
    
       
 
    // TODO:    Decide how large the solar system is.
    func checkBounds(pos: CGPoint) -> Bool {
        var retVal: Bool = true
        
        if pos.x > maxWidth || pos.x < -maxWidth {
            retVal = false
        }
        
        if pos.y > maxHeight || pos.y < -maxHeight {
            retVal = false
        }
        return retVal
    }

    
}
