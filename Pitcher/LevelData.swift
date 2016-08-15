//
//  LevelData.swift
//  Pitcher
//
//  Created by al on 6/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import Foundation


class LevelData {
    
    var picture : String
    var answer : String
    var levelID : Int
    
     func isLocked() -> Bool{

        return levelID > LevelManager.getLastLevelSolvedID()
    }
    
     init(id : Int , answer : String , picture : String){
        self.levelID = id; self.answer = answer ; self.picture = picture;
    }
    
    
    
}