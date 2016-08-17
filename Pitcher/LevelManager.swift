//
//  LevelManager.swift
//  Pitcher
//
//  Created by al on 6/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct LevelManager {
    
    static var list : [LevelData] = [LevelData]()
    static var isInitilized = false
    
    
    
    static func getLevel(id : Int) -> LevelData{
        
        return list[id]
        
    }
    
    static func getCoin()->Int{
        var coins = 200
        if let temp = NSUserDefaults.standardUserDefaults().objectForKey("coins_count") as? Int {
            coins = temp
        }
        return coins
        
    }
    
    static func earnCoins(amount : Int){
        NSUserDefaults.standardUserDefaults().setInteger(getCoin() + amount, forKey: "coins_count")
    }
    
    
    
    static func spendCoin(amount : Int) -> Bool{
        let coin = getCoin()
        if(amount > coin){
            return false
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(coin - amount, forKey: "coins_count")

        
        return true
    }
    
    static func getLastLevelSolvedID() -> Int{
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let temp = defaults.valueForKey("lastLevelSolved") as? Int{
            return temp
        }
        else{
            return 0
        }
    }
    
    static func unlockNewLevel(){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        earnCoins(60)
        defaults.setInteger(getLastLevelSolvedID() + 1, forKey: "lastLevelSolved")
    }
    
    static func levelSolved(index : Int){
        if(index >= getLastLevelSolvedID()){
            unlockNewLevel()
        }
        
    }
    
    static func initialize(){
        if isInitilized{
            return
        }
        if let path = NSBundle.mainBundle().pathForResource("levels", ofType: "json") {
            do {
                var text =  NSData(contentsOfFile: path)
                let jsonArray = JSON(data: text!)["levels"].arrayValue
                print(jsonArray.count)
                var i = 0
                for item in jsonArray{
                    var level = LevelData(id: i , answer: item["ans"].stringValue , picture: item["img"].stringValue)
                    list.append(level)
                    i+=1
                    
                }
                
            }
            catch{
                print ("error in file")
            }
        }
        

        
        isInitilized = true
    }
    
    
    
}