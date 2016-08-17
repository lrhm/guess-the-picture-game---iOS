//
//  DataViewController.swift
//  Pitcher
//
//  Created by al on 6/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class ListViewController: UIViewController  {

    
    var pageNumber : Int?
    var rootVC : UIPageViewController?
    var imageViews = [UIImageView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(rootVC == nil){
            print("rootVC is nil")
        }
        

        
        self.view.gestureRecognizers = rootVC?.gestureRecognizers
        let converter = SizeConvertor(fromHeight: DeviceDimensions.height * 0.1, baseHeight: 211, baseWidth: 211)
        let cageImage = ImageManager.loadScaledImage(forList: "cage", Height: Int(converter.mHeight))
        var lockImage = UIImage(named: "lock")
//        [inputPrompt setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];

        self.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        var viewHolder = UIView()
        viewHolder.contentMode = UIViewContentMode.Center

        self.view.addSubview(viewHolder)

        for i in 0..<4 {
            for j in 0..<4{
                
                
                var x =  (CGFloat(DeviceDimensions.widht) * 0.05 ) * CGFloat(i + 1) + ( CGFloat(i) * CGFloat(converter.mWidth ))
                var y =  (CGFloat(DeviceDimensions.height) * 0.02 ) * CGFloat(j+1) + ( CGFloat(j) * CGFloat(converter.mHeight ))
                
                var cageFrame = CGRect(
                    x: x, y: y, width: converter.mWidth, height: converter.mHeight)
                let cageView = UIImageView(frame: cageFrame )
                cageView.contentMode = UIViewContentMode.ScaleAspectFit
                cageView.image = cageImage
                viewHolder.addSubview(cageView)
                
                
                
                
                x =  (CGFloat(DeviceDimensions.widht) * 0.05 ) * CGFloat(i + 1) + ( CGFloat(i) * CGFloat(converter.mWidth )) + (CGFloat(DeviceDimensions.widht) * 0.01 )
                y =  (CGFloat(DeviceDimensions.height) * 0.02 ) * CGFloat(j+1) + ( CGFloat(j) * CGFloat(converter.mHeight )) +  (CGFloat(DeviceDimensions.height) * 0.007 )
                
                let levelThumbFrame = CGRect(
                    x: x, y: y, width: converter.mWidth * 0.88 , height: converter.mHeight * 0.85)
                
                let levelData = LevelManager.list[pageNumber! * 16 + j * 4 + i]
                var imageNamed = "lock"
                if(!levelData.isLocked()){
                    imageNamed = levelData.picture
                }
                let levelThumbnail = ImageManager.loadScaledImage(forList: imageNamed, Height: Int(converter.mHeight * 0.85))
                
                // UIImage(named: levelData.picture   )
                
                let lockView = UIImageView(frame: levelThumbFrame)
                lockView.clipsToBounds = true
                lockView.contentMode = UIViewContentMode.Center
//                lockView.alpha = CGFloat(0.7)
                
                
//                lockView.
                
            
                let buttonClick : UIButton = UIButton(frame : levelThumbFrame)
                let tapRec = UITapGestureRecognizer(target: self, action: "buttonClicked:")
                tapRec.numberOfTapsRequired = 1
                buttonClick.tag = pageNumber! * 16 + j * 4 + i
                buttonClick.addGestureRecognizer(tapRec)
//                
//                buttonClick.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchDown)
                buttonClick.clipsToBounds = true
                
                lockView.image = levelThumbnail
                lockView.tag = pageNumber! * 16 + j * 4 + i
                imageViews.append(lockView)
                
                
                viewHolder.addSubview(lockView)
                self.view.addSubview(buttonClick)
                
                
            }
        }
        
        
        
    }

    
     override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
        for imageView in imageViews{
            let index = imageView.tag
            let levelData = LevelManager.list[index]
            var imageNamed = "lock"
            if(!levelData.isLocked()){
                imageNamed = levelData.picture
            }
            let converter = SizeConvertor(fromHeight: DeviceDimensions.height * 0.1, baseHeight: 211, baseWidth: 211)

            let levelThumbnail = ImageManager.loadScaledImage(forList: imageNamed, Height: Int(converter.mHeight * 0.85))
            imageView.image = levelThumbnail

        }
    }
    
    func buttonClicked(tapRec : UITapGestureRecognizer ){
        print("button clicked \(tapRec.view?.tag)")
        if(!LevelManager.getLevel(tapRec.view!.tag).isLocked()){
        performSegueWithIdentifier("levelStart", sender: tapRec.view?.tag)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "levelStart"){
            
            let nextVC = (segue.destinationViewController as! LevelViewController)
            nextVC.level = LevelManager.list[ sender as! Int  ]
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

