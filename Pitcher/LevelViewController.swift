//
//  LevelViewController.swift
//  Pitcher
//
//  Created by al on 7/5/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController , KeyboardViewDelegate{

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var keyboardView : KeyboardView!
    var level : LevelData?
    var coinView : CoinView?
    
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initBG()

        var imageWidth = DeviceDimensions.widht * 0.9
        var converter = SizeConvertor(fromWidth: imageWidth, baseHeight: 300, baseWidth: 400)
        var imageView = UIImageView(frame: CGRect(x: DeviceDimensions.widht * 0.05, y: DeviceDimensions.height/7, width: imageWidth, height: converter.mHeight) )
        imageView.image = UIImage(named : level!.picture)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        self.view.addSubview(imageView)
        keyboardView = KeyboardView(frame: CGRect(x: 0, y: DeviceDimensions.height/2, width: DeviceDimensions.widht, height: DeviceDimensions.height/2), level: level!)
        keyboardView.keyboardViewDelegate = self
     
        
        self.view.addSubview(keyboardView!)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func initCoinBox(){
        
        let converter = SizeConvertor(fromWidth: DeviceDimensions.widht * 0.3 , baseHeight: 123, baseWidth: 327)
        coinView = CoinView(frame: CGRect(x: 0  , y: DeviceDimensions.height * 0.04   , width: converter.mWidth   , height: converter.mHeight))
        
        self.view.addSubview(coinView!)
        
        
    
    }
    
    
    func initBG(){
//        let bgImageView = UIImageView(frame: self.view.bounds)
        background.frame = self.view.bounds
        background.contentMode = UIViewContentMode.Center
        background.image = ImageManager.loadScaledImageByHeight("bg", height: Int(DeviceDimensions.height))
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func allClickedRight(){
        print("all is right")
        levelSolved()
    }
    
    func levelSolved(){
        LevelManager.levelSolved(level!.levelID)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewControllerWithIdentifier("LevelVC") as! LevelViewController
        nextVC.level = LevelManager.list[level!.levelID + 1]
//        self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.pushViewController(nextVC, animated: true)

    }

    
    
    @IBAction func backButtonClicked(sender: UIButton) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func cheatRemoveSome(sender: AnyObject) {
        
        
        if(LevelManager.spendCoin(60)==false){

            self.view.makeToast("not enough money")
            return;
        }
        
       if( keyboardView.cheatWithRemoveSome() == false)
       {
        LevelManager.earnCoins(60)
        }
    }
    @IBAction func cheatShowOne(sender: AnyObject) {
        
        if(LevelManager.spendCoin(60)==false){
            
            self.view.makeToast("not enough money")
            return;
        }
        if(    keyboardView.cheatWithShowOne() == false){
            LevelManager.earnCoins(60)
        }
    }
    @IBAction func nextButtonClicked(sender: AnyObject) {
        
        if(LevelManager.spendCoin(100) == false){
            self.view.makeToast("not enoguth money")
            return;
            
        }
        keyboardView.cheatWithSkipLevel()
        
//        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "levelSolved", userInfo: nil, repeats: false)
           }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
