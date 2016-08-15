//
//  ModelController.swift
//  Pitcher
//
//  Created by al on 6/25/15.
//  Copyright (c) 2015 irPulse. All rights reserved.
//

import UIKit



class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageCount : Int ;
    var rootVC : UIPageViewController?;


    override init() {
        pageCount = LevelManager.list.count / 16;
    
        super.init()
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> ListViewController? {
        // Return the data view controller for the given index.
        if (pageCount == 0) || (index >= pageCount) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
        dataViewController.pageNumber = index
        dataViewController.rootVC = rootVC
        return dataViewController
    }

    func indexOfViewController(viewController: ListViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        if let dataObject: Int = viewController.pageNumber {
            return dataObject
        } else {
            return NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ListViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ListViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageCount {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

