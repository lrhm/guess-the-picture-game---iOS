//
//  CoinView.swift
//  Pitcher
//
//  Created by al on 1395/5/27 ه‍.ش..
//  Copyright © 1395 ه‍.ش. TreeCo. All rights reserved.
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
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initSubviews(frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    var image : UIImageView?
    var text : UILabel?
    
    
    func initSubviews(frame: CGRect){
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        image?.image = ImageManager.loadScaledImageByWidth("coins", width: Int(frame.width))
        

        text = UILabel(frame:
            CGRect(x: frame.width * 0.1 , y: 0, width: frame.size.width, height: frame.size.height))
        text?.textAlignment = .Center

        
        addSubview(image!)

        addSubview(text!)
        
        
    }
    
    func setCoinCount(){

        text?.text = String(LevelManager.getCoin())
    }

}
