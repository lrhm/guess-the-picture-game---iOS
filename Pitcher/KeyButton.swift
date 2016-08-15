//
//  KeyView.swift
//  Pitcher
//
//  Created by al on 7/5/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class KeyButton: UIView {
    var state : KeyState
    var index : Int
    var answerIndex : Int?
    var textView : UILabel
    var movingTextView : UILabel
    var imageView : UIImageView
    var character : Character
    var keyboardView : KeyboardView!
    var delegate : KeyButtonDelegate?
    
    
    init(origin : CGPoint ,  state : KeyState , index : Int , character : Character , keyboardView : KeyboardView) {
        self.state = state
        self.index = index
        self.character = character
        self.keyboardView = keyboardView
        
        
        let converter = SizeConvertor(fromWidth:  (DeviceDimensions.widht * 0.1), baseHeight: 116, baseWidth: 116)
        
        var frame = CGRect(x: origin.x, y: origin.y, width: converter.mWidth, height: converter.mHeight)
        textView = UILabel(frame : frame)
        movingTextView = UILabel(frame : frame)
        imageView = UIImageView(frame : frame)
        
        super.init(frame: frame)
        
        textView.textAlignment = .Center
        movingTextView.textAlignment = .Center
        
        imageView.image = UIImage(named: "albutton")
        imageView.contentMode = UIViewContentMode.ScaleToFill
        textView.text = String( character)
        movingTextView.text = String(character)
        var gesRec = UITapGestureRecognizer(target: self, action: #selector(KeyButton.clicked))
        self.addGestureRecognizer(gesRec)
        
        keyboardView.addSubview(imageView)
        keyboardView.addSubview(textView)
        keyboardView.addSubview(movingTextView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked(){
        if(state == .Normal){
            delegate?.keyClicked(index)
        }
    }
    
    //    ToDO
    func setClicked(toAnswerButton : AnswerButton){
        state = .Clicked
        UIView.animateWithDuration(0.4, animations: {self.movingTextView.frame = toAnswerButton.frame})
        UIView.animateWithDuration(0.4, animations: {
            
            self.textView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            self.textView.clipsToBounds = true
            self.textView.layer.cornerRadius = 9
            
        })
        toAnswerButton.keyButtonIndex = index
        toAnswerButton.state = AnswerState.Occupied
        answerIndex = toAnswerButton.index
    }
    func setCheated(toAnswerButton : AnswerButton){
        
        if(toAnswerButton.state == AnswerState.Occupied){
            if toAnswerButton.index != answerIndex{
                toAnswerButton.clearAnswerButton(keyboardView.keyButtons[toAnswerButton.keyButtonIndex!])
            }
        }
        
        state = .Removed
        UIView.animateWithDuration(0.4, animations: {self.movingTextView.frame = toAnswerButton.frame})
        UIView.animateWithDuration(0.4, animations: {
            self.movingTextView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            self.movingTextView.clipsToBounds = true
            self.movingTextView.layer.cornerRadius = 9
            
            self.textView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
            self.textView.clipsToBounds = true
            self.textView.layer.cornerRadius = 9
            
        })
        toAnswerButton.keyButtonIndex = index
        toAnswerButton.state = AnswerState.Cheated
        answerIndex = toAnswerButton.index
    }
    func setRemoved(){
        
        if(state == .Clicked){
            keyboardView.answerButtons[answerIndex!]?.state = AnswerState.Empty
        }
        
        state = .Removed
        UIView.animateWithDuration(0.4, animations: {self.movingTextView.alpha = 0
            self.textView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
            self.textView.clipsToBounds = true
            self.textView.layer.cornerRadius = 9
            
            
        })
    }
    
    
}

enum KeyState{
    case Normal
    case Clicked
    case Removed
    case Empty
}