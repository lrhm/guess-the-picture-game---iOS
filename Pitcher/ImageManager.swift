//
//  ImageManager.swift
//  Pantomim
//
//  Created by al on 4/30/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import Foundation
import ImageIO
import UIKit

struct ImageManager{
    
    
 //   static let cache = Shared.imageCache
  //  static let formatList = "Format_List"
   // static let formatNone = "Format_None"
    
    static func initCaches(){
        
    //    let listFormat = Format<UIImage>(name: formatList, diskCapacity: 80 * 1024 * 1024 , transform: nil)
    //   cache.addFormat(listFormat)
        
        
    }
    
    static   func loadScaledImage(normal name : String ,Width width : CGFloat ,Height height : CGFloat , Format format : String) -> UIImage{
        
        var temp = UIImage(named: name)
        var reSized =    reSizeImage(normal: temp!, Width: width, Height: height)
        
        return reSized
    }
    static   func loadScaledImage(normal name : String ,Width width : Int ,Height height : Int , Format format : String) -> UIImage{
        
        
        var temp = UIImage(named: name)
        var reSized =    reSizeImage(normal: temp!, Width: width, Height: height)
        
        return reSized
    }
    
    static func loadScaledImage(forList name: String ,Height height : Int ) -> UIImage{
        var temp = UIImage(named: name)
        var reSized =  temp!.resizedImageByHeight(UInt(height))
        return reSized
    }
    /*
    
    [width] -- resize by width, height automatically selected to preserve aspect ratio.
    x[height] -- resize by height, width automagically selected to preserve aspect ratio.
    [width]x[height] -- maximum values of height and width given, aspect ratio preserved.
    [width]x[height]^ -- minimum values of height and width given, aspect ratio preserved.
    [width]x[height]! -- width and height emphatically given, original aspect ratio ignored.
    [width]x[height]# -- scale and crop to exactly that size, original aspect ratio preserved (you probably want this one for your thumbnails).
    
    */
    
    static func loadScaledImageByWidth(name : String , width : Int) ->UIImage{
        return UIImage(named: name)!.resizedImageByWidth(UInt(width));
    }
    
    static func loadScaledImageByHeight(name : String , height : Int) ->UIImage{
        return UIImage(named: name)!.resizedImageByHeight(UInt(height));
    }
    static  func reSizeImage(normal source : UIImage , Width width : CGFloat , Height height : CGFloat) -> UIImage{
        
        return source.resizedImageByMagick("\(Int(width))x\(Int(height))#");
     
    }
    static  func reSizeImage(normal source : UIImage , Width width : Int , Height height : Int) -> UIImage{
        
        return source.resizedImageByMagick("\(width)x\(height)!");
        //        let image = source.CGImage
        //        let bitsPerComponent = CGImageGetBitsPerComponent(image)
        //        let bytesPerRow = CGImageGetBytesPerRow(image)
        //        let colorSpace = CGImageGetColorSpace(image)
        //        let bitmapInfo = CGImageGetBitmapInfo(image)
        //
        //        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
        //
        //        CGContextSetInterpolationQuality(context, kCGInterpolationHigh)
        //
        //        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), image)
        //
        //        let scaledImage = UIImage(CGImage: CGBitmapContextCreateImage(context))
        //        return scaledImage!
        
    }
    
    
    
    
}



