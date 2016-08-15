//
//  AnswerButton.swift
//  Pitcher
//
//  Created by al on 7/5/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class AnswerButton: UIView {
    static var counter = 0 ;

    var state : AnswerState!
    var imageView : UIImageView!
    var occupiedCharacter : Character?
    var currectCharacter : Character!
    var keyboardView : KeyboardView!
    var index : Int!
    var delegate : AnswerButtonDelegate!
    var keyButtonIndex : Int?
    
    init(frame: CGRect , keyboardView : KeyboardView , state : AnswerState , index : Int , answerButtonDelegate : AnswerButtonDelegate , currectCharacter : Character) {
        self.delegate = answerButtonDelegate
        self.keyboardView = keyboardView
        self.state = state
        self.index = index
        self.currectCharacter = currectCharacter
        
        
        
        imageView = UIImageView(frame: frame)
        
        
        if(state == .Space){
            super.init(frame: frame)
            return;
        }
        
        
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.image = UIImage(named: "place_holder")
        
        self.keyboardView.addSubview(imageView)
        
        super.init(frame: frame)
        
        var gesRec = UITapGestureRecognizer(target: self, action: "clicked")
        self.addGestureRecognizer(gesRec)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked(){
        delegate.answerButtonClicked(index)
    }
    
    
    func clearAnswerButton(keyButton : KeyButton){
        println("clear answer button \(AnswerButton.counter++) \(state == .Cheated) \(keyButton.state == KeyState.Removed) \(keyButton.index) \(keyButtonIndex) ")
        var dointToButton = keyButton
        
        if(keyButton.state == .Removed){
            return;
        
        }
        state = .Empty
        UIView.animateWithDuration(0.4, animations: {
            
            dointToButton.textView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            dointToButton.textView.clipsToBounds = true
            dointToButton.movingTextView.frame = keyButton.textView.frame})
            dointToButton.state = KeyState.Normal
        
    }
    
    func clearAnswerButtonWithoutMoving(){
        state = .Empty
    }

    

}

protocol AnswerButtonDelegate{
    func answerButtonClicked(atIndex : Int)
}


enum AnswerState{
    case Cheated
    case Empty
    case Occupied
    case Space
}