//
//  KeyboardView.swift
//  Pitcher
//
//  Created by al on 7/5/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class KeyboardView: UIView  , KeyButtonDelegate , AnswerButtonDelegate{
    
    let level : LevelData
    var allStrings = "qwertyuiopasdfghjklzxcvbnm"
    var keyButtons = [KeyButton]()
    var answerButtons = [AnswerButton?]()
    var shuffledString = ""
    var remainingAnswer = [Character]()
    var delegate : KeyButtonDelegate?
    var keyboardViewDelegate : KeyboardViewDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    init(frame: CGRect , level : LevelData) {
        self.level = level
        super.init(frame: frame)
        
        var count = level.answer.length
        
        while(count >= 0 ){
            count -= 1
            answerButtons.append(nil)
        }
        initAnswerButtons()
        initKeyButtons()
        
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initAnswerButtons(){
        
        let converter = SizeConvertor(fromWidth: DeviceDimensions.widht*0.08, baseHeight: 166, baseWidth: 166)
        
        var splited = level.answer.componentsSeparatedByString(".")
        if(splited.count == 1){

            
            
            initAnswerButtonsInLine(0, converter: converter, string: level.answer, yOffset: (frame.height / 4 - converter.mHeight/2 ))
        }
        else{
            initAnswerButtonsInLine(0, converter: converter, string: (splited[0]), yOffset: (frame.height / 4 - converter.mHeight  ))
            initAnswerButtonsInLine(splited[0].length, converter: converter, string: (splited[1]), yOffset: (frame.height / 4  + DeviceDimensions.height * 0.001 ))
            
        }
        
    }
    
    func initAnswerButtonsInLine(startingIndex : Int , converter : SizeConvertor , string : String , yOffset : CGFloat){
        var array = Array(string.characters)
        let middle = DeviceDimensions.widht/2
        var xAllwaysOffset = DeviceDimensions.widht * 0.002
        let xOffset = DeviceDimensions.widht * 0.001
        var leftSpaceOffset = CGFloat(0)
        var rightSpaceOffset = CGFloat(0)
        if(array.count % 2 == 1){
            xAllwaysOffset += converter.mWidth/2
            var width = converter.mWidth
            var state = AnswerState.Empty
            if(array[array.count/2] == Character(" ") ){
                rightSpaceOffset -= converter.mWidth/4
                leftSpaceOffset -= converter.mWidth/4
                width = converter.mWidth/2
                state = .Space
            }
            
            let frame = CGRect(x: middle - converter.mWidth/2, y: yOffset, width: width, height: converter.mHeight)
            let answerButton = AnswerButton(frame: frame , keyboardView: self, state: state, index: startingIndex + array.count/2 , answerButtonDelegate: self , currectCharacter: array[array.count/2])
            answerButtons[answerButton.index] = answerButton
            self.addSubview(answerButton)
        }
        var j = array.count / 2
        var i = array.count / 2
        var chapiTemp = 0
        var even = 0
        if(array.count % 2 == 0){
            j += 1
            even = 1
        }
        else{
            chapiTemp = 1
            
        }
        
        let indexMiddle = array.count / 2
        
        while(   j > 0 && i < array.count ){
            i += 1
            j -= 1
            
            var leftWidth = converter.mWidth
            var rightWidht = converter.mWidth
            var leftState = AnswerState.Empty
            var rightState = AnswerState.Empty
            if(array[i - even] == " "){
                rightWidht = converter.mWidth/2
                rightState = .Space
            }
            
            
            if(array[j - even] == " "){
                leftWidth = converter.mWidth/2
                leftState = .Space
            }
            let rightFrame = CGRect(x: xAllwaysOffset + rightSpaceOffset +  middle + CGFloat(i - indexMiddle - 1) * (converter.mWidth + xOffset), y: yOffset, width: rightWidht, height: converter.mHeight  )
            let leftFrame = CGRect(x: middle - xAllwaysOffset - leftSpaceOffset - CGFloat(indexMiddle - j + 1  - chapiTemp) * (converter.mWidth + xOffset), y: yOffset, width: leftWidth, height: converter.mHeight )
            
            let tempRight = AnswerButton(frame: rightFrame, keyboardView: self, state: rightState, index: startingIndex + i - even , answerButtonDelegate: self , currectCharacter: array[i - even] )
            let tempLeft = AnswerButton(frame: leftFrame, keyboardView: self, state: leftState, index: startingIndex + j - even , answerButtonDelegate: self, currectCharacter: array[j - even] )
            
            
            answerButtons[tempRight.index] = tempRight
            answerButtons[tempLeft.index] = tempLeft
            
            addSubview(tempRight)
            addSubview(tempLeft)
            
            if(array[i - even] == " "){
                rightSpaceOffset -= converter.mWidth/2
            }
            
            
            if(array[j - even] == " "){
                leftSpaceOffset -= converter.mWidth/2
            }
        }
        
        
        
        
    }
    
    func initKeyButtons(){
        let startingHeight = frame.height / 2
        let xOffset =  DeviceDimensions.widht * 0.01
        
        let yOffset = DeviceDimensions.height * 0.01
        let converter = SizeConvertor(fromWidth:  (DeviceDimensions.widht * 0.1), baseHeight: 116, baseWidth: 116)
        let xOffsetAllways = (  DeviceDimensions.widht - xOffset  -  CGFloat(7) * ( converter.mWidth  + xOffset)
            )/2
        
        var temp : [Character] = Array( (level.answer.stringByReplacingOccurrencesOfString(".", withString: "", options: .LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)).characters )
        print("original temp is " + String(temp))
        var allArray = Array(allStrings.characters)
        srand(UInt32(level.levelID))
        
        
        while(temp.count != 21){
            let r = Int(rand()) % allArray.count
            let index = allArray.startIndex.advancedBy(r)
            temp.append((allArray.removeAtIndex(index)))
        }
        
        var shuffledArray = [Character]()
        while(temp.count != 0){
            print(String(temp) + " is temp ")
            let r = Int(rand()) % temp.count
            let index = temp.startIndex.advancedBy(r)
            let selectedChar = temp.removeAtIndex(index)
            print(selectedChar)
            shuffledArray.append((selectedChar))
        }
        
        shuffledString = String(shuffledArray)
        
        remainingAnswer = Array(level.answer.stringByReplacingOccurrencesOfString(".", withString: "", options: .LiteralSearch, range: nil).characters)
        
        for i in 0...2{
            for j in 0...6{
                let x = xOffsetAllways + CGFloat(j) * ( converter.mWidth  + xOffset )
                var origin = CGPoint(x: x , y: self.frame.height/2 + CGFloat(i) * (converter.mHeight + yOffset ))
                var button = KeyButton( origin: origin , state: KeyState.Normal , index: i * 7 + j, character: shuffledArray[i*7 + j] , keyboardView: self)
                //                if(i == 0 && j == 0){
                //                    UIView.animateWithDuration(2.0, animations: {
                //                        button.movingTextView.frame = CGRect(x: 0, y: 50, width: converter.mWidth, height: converter.mHeight)
                //
                //                        }
                //                    )
                //                }
                button.delegate = self
                keyButtons.insert(button, atIndex: button.index)
                addSubview(button)
                
            }
        }
        
    }
    
    func keyClicked(index: Int) {
        
        
        let ansIndex = getFirstEmptyIndex()
        if(ansIndex == -1){
            if(guessIsRight()){
                keyboardViewDelegate?.allClickedRight()
            }
            return
        }
        
        keyButtons[index].setClicked(answerButtons[ansIndex]!)
        
        if(guessIsRight()){
            keyboardViewDelegate?.allClickedRight()
        }
        
    }
    
    func answerButtonClicked(atIndex: Int) {
        
        if(answerButtons[atIndex]!.state == AnswerState.Occupied){
            answerButtons[atIndex]!.clearAnswerButton(keyButtons[answerButtons[atIndex]!.keyButtonIndex!])
        }
    }
    
    func getFirstEmptyIndex() -> Int{
        for temp in answerButtons{
            if let ans = temp {
                if ans.state == AnswerState.Empty {
                    return ans.index
                }
            }
        }
        return -1
    }
    
    func getGuessed() -> String{
        var res = ""
        for temp in answerButtons{
            if let ans = temp {
                if ans.state == AnswerState.Occupied || ans.state == AnswerState.Cheated {
                    res +=    String( keyButtons[ans.keyButtonIndex!].character)
                }
                if ans.state == AnswerState.Space{
                    res +=    String(" ")
                    
                }
            }
        }
        return res
    }
    
    func guessIsRight() -> Bool{
        return level.answer.stringByReplacingOccurrencesOfString(".", withString: "", options: .LiteralSearch, range: nil) == getGuessed()
    }
    
    func numberOfEmptyIndexes() -> Int{
        var res = 0
        for temp in answerButtons{
            if let ans = temp {
                if ans.state == AnswerState.Empty {
                    res += 1
                }
            }
        }
        return res
    }
    
    func findKeyButtonWithCharacter(character : Character) -> KeyButton?{
        for button in keyButtons{
            if(button.state == KeyState.Normal && button.character == character){
                return button
            }
        }
        for button in keyButtons{
            if(button.state == KeyState.Clicked && button.character == character){
                return button
            }
        }
        return nil
    }
    
    func getNotCheatedCount()->Int{
        var c = 0
        for temp in answerButtons{
            if let ans = temp {
                if (ans.state == AnswerState.Empty || ans.state == AnswerState.Occupied) {
                    c += 1
                }
            }
        }
        return c
        
    }
    
    
    func getNotCheatedKeyButtonCount()->Int{
        var c = 0
        for temp in keyButtons{
                if (temp.state != KeyState.Removed) {
                    c += 1
                }
            
        }
        return c
        
    }
    
    
    
    func cheatWithSkipLevel(){
        var c = answerButtons.count
        while( c != 0){
            c -= 1
            cheatWithShowOne()
        }
        
    }
    
    func numberOfCharacterInAnswer(char : Character)->Int{
        var res = 0
        for butt in answerButtons {
            if butt?.currectCharacter == char {
                res += 1
            }
        }
        return res
    }
    
    
    func numberOfRemainigCharacterInButtons(char : Character)->Int{
        var res = 0
        for butt in keyButtons {
            if butt.character == char && butt.state != KeyState.Removed {
                res += 1
            }
        }
        return res
    }
    
    func cheatWithRemoveSome()->Bool{
        let answersLen = getNotCheatedCount()
        let notCheatedKeyButtons = getNotCheatedKeyButtonCount()
        
        if notCheatedKeyButtons < answersLen {
            return false
        }
        
        var count = (notCheatedKeyButtons - answersLen )/3
        if(count == 0){
            return false
        }
        var r = Int(arc4random()) % 20

        while (count > 0){
            while(r < 20){
                if(keyButtons[r].state != KeyState.Removed && numberOfRemainigCharacterInButtons(keyButtons[r].character) > numberOfCharacterInAnswer(keyButtons[r].character) ) {
                    keyButtons[r].setRemoved()
                    count -= 1
                    if(count == 0 ){
                        break
                    }
                }
                r += 1
            }
            r = 0
            
        }

        
        
        
        return true
    }
    
    
    func cheatWithShowOne() ->Bool{
        
        let notCheatedCount = getNotCheatedCount()
        if(notCheatedCount == 0){
            return false
        }
        
        //        var countEmpty =  numberOfEmptyIndexes()
        //        var r = Int(rand()) % countEmpty
        //        var c = 0
        //        for temp in answerButtons{
        //            if let ans = temp {
        //                if ans.state == AnswerState.Empty {
        //                    if(c == r){
        //                        var butt = findKeyButtonWithCharacter(ans.currectCharacter)
        //                        butt?.setCheated(ans)
        //                        return true
        //                    }
        //                    c++
        //                }
        //            }
        //        }
        let r = Int(arc4random()) % notCheatedCount
        var c = 0
        for temp in answerButtons{
            if let ans = temp {
                if ans.state == AnswerState.Empty || ans.state == AnswerState.Occupied{
                    if(c == r){
                        let butt = findKeyButtonWithCharacter(ans.currectCharacter)
//                        if(ans.state == AnswerState.Occupied){
//                            ans.clearAnswerButton(keyButtons[ans.keyButtonIndex!])
//                        }
                        butt?.setCheated(ans)
                        
                        if(guessIsRight()){
                            keyboardViewDelegate?.allClickedRight()
                        }
                        return true
                    }
                    c += 1
                }
            }
        }
        
        
        return false
    }
    
}
extension String {
    var length: Int { return self.characters.count        }  // Swift 1.2
}
