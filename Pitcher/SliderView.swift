//
//  SliderView.swift
//  Pitcher
//
//  Created by al on 7/5/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class SliderView: UISlider {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    var isInTouch = false
    var timing = false;
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isInTouch = true
        
        timing = true
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
         NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(SliderView.enable), userInfo: nil, repeats: false)
        timing = false
        super.touchesEnded(touches, withEvent: event)
    }
    func enable(){
        if(timing){
            return
        }
        isInTouch = false
        
    }
    
}
