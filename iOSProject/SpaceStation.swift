//
//  SpaceStation.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

enum SSDesc {
    static let alpha = "Welcome to SpaceStation Alpha. Shop at your leisure."
    static let beta = "Welcome to SpaceStation Beta. Shop at your leisure."
}

enum SSList {
    static let alpha = "SpaceStation Alpha"
    static let beta = "SpaceStation Beta"
}



class SpaceStation: SKSpriteNode, InteractiveNode {
    var quests: [Quest] = []
    // all rates are multipliers
    let fuelRate: CGFloat = 2.0
    // buyRates
    var oilRate: CGFloat = 100.0
    var mineralRate: CGFloat = 50.0
    var metalRate: CGFloat = 10.0
    // sellRates
    var oilSell: CGFloat = 300.0
    var mineralSell: CGFloat = 150.0
    var metalSell: CGFloat = 30.0
    var labelArray: [String] = ["sFuel", "sMinerals", "sOil", "sMetal"]
    
    var descOpen: Bool = false
    var ssDesc: SKSpriteNode!
    var descText: String!
    func sceneLoaded() {}
    
    func interact() {}
    
    func openInventory(name: String) {
        guard let scene = scene else {
            return
        }
        
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        
        let yes = SKSpriteNode(imageNamed: "Shop")
        yes.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 + testPic.size.height * 0.5) - yes.size.height * 0.7)
        yes.zPosition = 11
        yes.name = "Shop"
        
        let no = SKSpriteNode(imageNamed: "Quest")
        no.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 + testPic.size.height * 0.5) - yes.size.height * 0.7)
        no.zPosition = 11
        no.name = "Quest"
        
        
        let leave = SKSpriteNode(imageNamed: "Explore")
        leave.size = CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.1)
        leave.zPosition = 11
        leave.position = CGPoint(x: 0, y: (0 - testPic.size.height * 0.5) + leave.size.height * 0.5)
        leave.name = "Leave"
        
        testPic.addChild(leave)
        testPic.addChild(generateShopPage(HUDSize: testPic.size, halfSize: yes.size))
        testPic.addChild(no)
        testPic.addChild(yes)
        scene.addChild(testPic)
        
    }
    
    func openDesc(name: String) {
        guard let scene = scene else {
            return
        }
        
        descOpen = true
        
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        
        
        ssDesc.size = CGSize(width: testPic.size.width * 0.87, height:  testPic.size.height * 0.4)
        ssDesc.position = CGPoint(x: 0 - 2.5 , y: (0 + ssDesc.size.height * 0.5) + ssDesc.size.height * 0.15)
        ssDesc.name = "SSDesc"
        ssDesc.zPosition = 11
        testPic.addChild(ssDesc)
        
        testPic.addChild(World.createStringOL(string: descText, characterCount: 25))

        let yes = SKSpriteNode(imageNamed: "Land")
        yes.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.7)
        yes.zPosition = 11
        yes.name = "yes"
        

        let no = SKSpriteNode(imageNamed: "Explore")
        no.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.7)
        no.zPosition = 11
        no.name = "no"
        
        testPic.addChild(no)
        testPic.addChild(yes)
        scene.addChild(testPic)
    }
    
    func randomizeRates() {
        let multiplier = CGFloat.random(min: 0.75, max: 1.5)
  
        
        oilRate *= multiplier
        mineralRate *= multiplier
        metalRate *= multiplier
    }
    
    func randomizeSell() {
        let multiplier = CGFloat.random(min: 0.5, max: 1)
    
        
        oilSell *= multiplier
        mineralSell *= multiplier
        metalSell *= multiplier
    }
    
    func generateShopPage(HUDSize: CGSize, halfSize: CGSize) -> SKSpriteNode {
        let shopPage = SKSpriteNode()
        shopPage.position = CGPoint.zero
        shopPage.name = "ShopPage"
        shopPage.zPosition = 11
        
        
        let buy = SKLabelNode(fontNamed: "Arial")
        buy.position = CGPoint(x: 0 - halfSize.width * 0.5, y: (0 + HUDSize.height * 0.25))
        buy.text = "BUY"
        buy.fontSize = 50
        buy.fontColor = .white
        buy.zPosition = 12
        shopPage.addChild(buy)
        
        let sell = SKLabelNode(fontNamed: "Arial")
        sell.position = CGPoint(x: 0 + halfSize.width * 0.5, y: (0 + HUDSize.height * 0.25))
        sell.text = "SELL"
        sell.fontSize = 50
        sell.fontColor = .white
        sell.zPosition = 12
        shopPage.addChild(sell)
        
        
        for i in 1...4 {


            let buy2 = SKSpriteNode(imageNamed: labelArray[i - 1])
            buy2.size = CGSize(width: HUDSize.width * 0.33, height: HUDSize.height / 8)
        
            buy2.position = CGPoint(x: 0 - halfSize.width * 0.5, y: (0 + HUDSize.height * 0.15) - ((buy2.size.height + 10) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "buy\(i)"
            
            
            shopPage.addChild(buy2)
        }
        
        
        for i in 1...3 {

            let buy2 = SKSpriteNode(imageNamed: labelArray[i])
            buy2.size = CGSize(width: HUDSize.width * 0.33, height: HUDSize.height / 8)
            
            buy2.position = CGPoint(x: 0 + halfSize.width * 0.5, y: (0 + HUDSize.height * 0.15) - ((buy2.size.height + 10) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "sell\(i)"
            
            
            shopPage.addChild(buy2)
        }
        
        return shopPage
    }
    
    func generateQuestPage(HUDSize: CGSize, halfSize: CGSize) -> SKSpriteNode {
        let questPage = SKSpriteNode()
        questPage.position = CGPoint.zero
        questPage.name = "QuestPage"
        questPage.zPosition = 11
        
        for i in 1...2 {
            
            let buy2 = SKSpriteNode(imageNamed: "RawBtn")
            buy2.size = CGSize(width: HUDSize.width * 0.66, height: HUDSize.height / 8)
            buy2.position = CGPoint(x: 0, y: ((0 + HUDSize.height * 0.1 )) - ((buy2.size.height + 25) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "quest\(i)"
            
            let text = SKLabelNode(fontNamed: "Arial")
            text.name = "quest\(i)"
            text.position = buy2.position
            text.zPosition = 12
            text.fontSize = 25
            text.verticalAlignmentMode = .center
            text.fontColor = .white
            text.text = quests[i-1].questName
            
            questPage.addChild(text)
            questPage.addChild(buy2)
        }
        
        return questPage
    }
    
    func createQuests() {
        if quests.count > 0 {
            quests.removeAll()
        }
        
        for i in 0...1 {
            quests.insert(Quest(questGiver: self.name!), at: i)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
}
