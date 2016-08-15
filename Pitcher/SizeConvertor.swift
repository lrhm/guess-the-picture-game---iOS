//
//  SizeConvertor.swift
//  Pitcher
//
//  Created by al on 4/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import Foundation
import UIKit

struct DeviceDimensions{
    static var widht : CGFloat = 0;
    static var height : CGFloat = 0;
    
    static func initialize(height : CGFloat , width : CGFloat){
        self.widht = width;
        self.height = height;
    }
}

class SizeConvertor {
    var mWidth : CGFloat
    var mHeight : CGFloat
    var baseHeight : CGFloat
    var baseWidth : CGFloat
    init(fromHeight height : CGFloat , baseHeight : CGFloat , baseWidth : CGFloat){
        self.baseHeight = baseHeight;
        self.baseWidth = baseWidth;
        var    ratio = (  ( height)) / ( baseHeight)
        mHeight = height
        mWidth = ((ratio) * baseWidth)
        
    }
    init(fromWidth width : CGFloat , baseHeight : CGFloat , baseWidth : CGFloat){
        self.baseHeight = baseHeight;
        self.baseWidth = baseWidth;
        var  ratio = (  ( width)) / ( baseWidth)
        mWidth = width
        mHeight = ((ratio) * baseHeight)
        
    }
    func convertWidht(width : Int) -> CGFloat {
        var ratio = mWidth/baseWidth
        return ratio * CGFloat(width
        )    }
    
    func convertHeight(height : Int) -> CGFloat{
        var ratio = mHeight/baseHeight
        return ratio * CGFloat(height)
    }
    func convertWidht(width : CGFloat) -> CGFloat {
        var ratio = mWidth/baseWidth
        return ratio * CGFloat(width
        )    }
    
    func convertHeight(height : CGFloat) -> CGFloat{
        var ratio = mHeight/baseHeight
        
        return ratio * CGFloat(height)
    }
}