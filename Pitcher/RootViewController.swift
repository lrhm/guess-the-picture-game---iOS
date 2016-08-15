//
//  RootViewController.swift
//  Pitcher
//
//  Created by al on 6/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit
class RootViewController: UIViewController, UIPageViewControllerDelegate , UIScrollViewDelegate{
    
    var pageViewController: UIPageViewController?
    //var coinBox : CoinView?
    var sliderBackground: UIImageView!
    var slider: SliderView!
    var scrollView : UIScrollView!
    var pageNumLabel : UILabel!
    var icon : UIImageView!
    var animationTimer : NSTimer!
    var isInView = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
      (  UIApplication.sharedApplication().delegate as! AppDelegate).rootVC = self
        ImageManager.initCaches()
        DeviceDimensions.initialize(self.view.bounds.height, width: self.view.bounds.width)
        LevelManager.initialize()
        initBG()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        let startingViewController: ListViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        
        for child in pageViewController!.view.subviews{
            if(child.isKindOfClass(UIScrollView)){
                print("found")
                
                (                        child as! UIScrollView).delegate = self
                scrollView = child as!UIScrollView
                scrollView.delaysContentTouches = true
            
            }
        }
        
        
        
        //        self.pageViewController!.view.alpha = 0.85
        
        self.view.addSubview(self.pageViewController!.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        
        let frame : CGRect = CGRect(x: 0, y: DeviceDimensions.height / 4, width: DeviceDimensions.widht, height: DeviceDimensions.height / 2)
        
        self.pageViewController!.view.frame = frame
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
        initSlider()
        
        initCoinBox()
    }
    

    override func viewWillAppear(animated: Bool) {
        print("view will apeear")
        isInView = true
        animationTimer =  NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(RootViewController.rotateAnimation), userInfo: nil, repeats: true  )
   //     self.coinBox?.updateText()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will dis appear")
        isInView = false
        animationTimer.invalidate()
        animationTimer = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
            _modelController?.rootVC = pageViewController
        }
        return _modelController!
    }
    
    var _modelController: ModelController? = nil
    
    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            let currentViewController = self.pageViewController!.viewControllers![0] as UIViewController
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
            
            self.pageViewController!.doubleSided = false
            return .Min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! ListViewController
        var viewControllers: [UIViewController]
        
        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        
        return .Mid
    }
    
    func initSlider(){
        slider = SliderView()
        sliderBackground = UIImageView()
        //         var trans = CGAffineTransformRotate(nil, M_PI)
        let imageBackgorundSlider = UIImage(named: "seek_back")
        let converter = SizeConvertor(fromHeight: DeviceDimensions.height * 0.1, baseHeight: 211, baseWidth: 211)
        let width = (CGFloat(DeviceDimensions.widht) * 0.05 ) * CGFloat(4) + ( CGFloat(4) * CGFloat(converter.mWidth ))
        let frameOfSlider = CGRect(x: CGFloat(DeviceDimensions.widht) * 0.05 , y: CGFloat(DeviceDimensions.height) * 0.839, width: width , height: CGFloat(DeviceDimensions.height) * 0.1 )
        let frameOfSliderBG = CGRect(x: CGFloat(DeviceDimensions.widht) * 0.05 , y: CGFloat(DeviceDimensions.height) * 0.833, width: width , height: CGFloat(DeviceDimensions.height) * 0.1 )
        slider.frame = frameOfSlider
        //        slider?.transform = trans
        slider.minimumValue = 0
        slider.maximumValue = Float(modelController.pageCount)
        sliderBackground.frame = frameOfSliderBG
        sliderBackground.contentMode = UIViewContentMode.ScaleToFill
        sliderBackground.image = imageBackgorundSlider
        let heightOfThumb : Int = Int(DeviceDimensions.height * 0.11)
        let thumbImage = ImageManager.loadScaledImageByHeight("thumb", height: heightOfThumb)
        slider.setThumbImage(thumbImage, forState: UIControlState.Normal)
        
        let minImage = UIImage(named: "empty")?.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        _ = UIImage(named: "empty")?.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        slider.setMinimumTrackImage(minImage, forState: .Normal)
        slider.setMaximumTrackImage(minImage, forState: .Normal)
        slider.addTarget(self, action: #selector(RootViewController.sliderDidChange), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(sliderBackground)
        self.view.addSubview(slider)
        
        
        let widthPageNum = DeviceDimensions.widht/3
        
        let pageNumFrame = CGRect(x: DeviceDimensions.widht/2 - widthPageNum/2, y: DeviceDimensions.height/2 - widthPageNum/2, width: widthPageNum, height: widthPageNum)
        
        pageNumLabel = UILabel(frame: pageNumFrame)
        pageNumLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        pageNumLabel.textAlignment = .Center
        pageNumLabel.clipsToBounds = true
        pageNumLabel.layer.cornerRadius = 20
        pageNumLabel.textColor = UIColor.whiteColor()
        pageNumLabel.font = UIFont(name: "Helvetica", size: 40)
        pageNumLabel.text = "1"
        pageNumLabel.hidden = true
        
        self.view.addSubview(pageNumLabel)
        
        
    }
    var currentPage = 0
    
    var queue = [Int]()
    
    func sliderDidChange(){
        if(currentPage == Int(slider.value)){
            return
        }
        if(!queue.isEmpty){
            queue.append(Int(slider.value))
            return;
        }
        scrollTo(Int(slider.value))
        
        
        
        
        
        
    }
    
    
    func scrollTo(index : Int){
        let lastPage = currentPage
        currentPage = index
        let index2 = ( pageViewController!.viewControllers!.last as! ListViewController ).pageNumber!
        
        if(index == modelController.pageCount){
            
            
            currentPage -= 1
            
            if(index2  == modelController.pageCount - 1){
                return
            }
        }
        
        let startingViewController: ListViewController = self.modelController.viewControllerAtIndex(currentPage, storyboard: self.storyboard!)!
        
        let viewControllers = [startingViewController]
        var direction : UIPageViewControllerNavigationDirection
        if (lastPage > currentPage) {
            direction = UIPageViewControllerNavigationDirection.Reverse
        }
        else{
            direction = UIPageViewControllerNavigationDirection.Forward
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: direction, animated: true, completion:  nil)
        
    }
    //
    //    func checkQueue(){
    //        if(queue.isEmpty){
    //            return
    //        }
    //        println("go to queee")
    //        scrollTo(queue.first!)
    //
    //    }
    
    func initBG(){
        let bgImageView = UIImageView(frame: self.view.bounds)
        bgImageView.contentMode = UIViewContentMode.Center
        bgImageView.image = ImageManager.loadScaledImageByHeight("bg", height: Int(DeviceDimensions.height))
        
        self.view.addSubview(bgImageView)
        
    }
    
    func initCoinBox(){
        
        _ = SizeConvertor(fromWidth: DeviceDimensions.widht * 0.3 , baseHeight: 123, baseWidth: 327)
        
//        coinBox = CoinView(frame: CGRect(x: 0  , y: DeviceDimensions.height * 0.04   , width: converter.mWidth   , height: converter.mHeight))
//        
//        self.view.addSubview(coinBox!)
        
        
        let logoConverter = SizeConvertor(fromWidth: DeviceDimensions.widht * 0.35 , baseHeight: 226, baseWidth: 512)
        
        icon = UIImageView(frame: CGRect(x: DeviceDimensions.widht * 0.9 - logoConverter.mWidth, y: DeviceDimensions.height * 0.07  , width: logoConverter.mWidth, height: logoConverter.mHeight ))
        icon.contentMode = UIViewContentMode.ScaleAspectFit
        icon.image = UIImage(named: "logo")
        
        self.view.addSubview(icon)
        
        
    }
    
    var originalOffset : Float = -10
    
    var start : NSDate!
    
    func setLabelHidden(){
        let end = NSDate()
        
        if(end.timeIntervalSinceDate(start) > 0.5){
            pageNumLabel.hidden = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RootViewController.setLabelHidden), userInfo: nil, repeats: false)
        if(pageNumLabel.text != "\(Int(slider.value)+1)"){
            pageNumLabel.text = "\(Int(slider.value)+1)"}
        start = NSDate()
        pageNumLabel.hidden = false
        
        if(slider.isInTouch){
            originalOffset = -10
            return
        }
        
//        let index = ( pageViewController!.viewControllers!.last as! ListViewController ).pageNumber!
        //        let indexFloat = Float(index)
        //
        let offset = Float( ( scrollView.contentOffset.x - DeviceDimensions.widht ) / DeviceDimensions.widht)
        
        if(offset <= -1 || offset >= 1 ){
            originalOffset = -10
            return;
        }
        
        if(originalOffset == -10 ){
            originalOffset = slider.value
        }
        
        slider.value = originalOffset + offset
        
        
    }
    
    
    
    //    @IBAction func rotateImage(sender: UIButton) {
    //        UIView.animateWithDuration(2.0, animations: {
    //            self.imageView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
    //        })
    //    }
    
    func rotateAnimation(){
        if (UIApplication.sharedApplication().delegate as! AppDelegate).isInBackground || !isInView {
            animationTimer.invalidate()
            animationTimer = nil
            return;
        }
       
        
        print("rotate anime")
        UIView.animateWithDuration( 1.0 ,
            animations: { self.icon.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4/4)) } ,
            completion: { (data : Bool ) in
                
                UIView.animateWithDuration(1.0,
                    animations:
                    {
                        self.icon.transform = CGAffineTransformMakeRotation( CGFloat(-M_PI_4)/4)
                        return
                    },
                    completion: {
                        data in
                        
                        UIView.animateWithDuration(1.0, animations: {self.icon.transform = CGAffineTransformMakeRotation(0)})
                        
                        return ;
                        
                    }
                )
                return ;
                
        });
    }
}
extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}

