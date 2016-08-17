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
    var text : UITextView?
    
    
    func initSubviews(frame: CGRect){
        print("initilize coinveView subviews \(frame.width) \(frame.height)")
        image = UIImageView(frame: frame)
        print("1")

        image?.image = ImageManager.loadScaledImageByWidth("coins", width: Int(frame.width))
        
        print("2")

        text = UITextView(frame: frame)
        text?.textAlignment = .Right
        
        print("3")

        
        addSubview(image!)
        
        print("4")

        text?.backgroundColor = nil
        addSubview(text!)
        
        print("initilzed coinview")
        
    }
    
    func setCoinCount(){

        text?.text = String(LevelManager.getCoin())
    }

}
