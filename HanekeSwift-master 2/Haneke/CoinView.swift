//
//  CoinView.swift
//  Pitcher
//
//  Created by al on 7/4/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class CoinView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var coinImageView : UIImageView?
    var coinTextView : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        let xText = frame.origin.x + frame.width / 3
        let widthText = frame.width * 2 / 3
        
        var textFrame = CGRect(x: xText, y: frame.origin.y, width: widthText, height: frame.height)
        
        coinTextView = UILabel(frame: textFrame)
        coinImageView = UIImageView(frame: frame)
        
        coinImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        coinImageView?.image = UIImage(named: "coins")
        coinTextView?.numberOfLines = 1
        coinTextView?.textAlignment = NSTextAlignment.Center
        coinTextView?.textColor = UIColor.whiteColor()
        
        updateText()
        self.addSubview(coinImageView!)
        self.addSubview(coinTextView!)
        
        
        
    }
    
    
    func updateText(){
       
        coinTextView?.text = "\(LevelManager.getCoin())"

    }

    required init(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }

    
    
    
    

}
