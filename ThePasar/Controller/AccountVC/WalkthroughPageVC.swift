//
//  WalkthroughVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol WalkthroughPageVCDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageVC: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    var walkthroughdelegate: WalkthroughPageVCDelegate?
    
    var pageHeading = ["Undecided on Food?","Select on nearby Store","Easy to See Details","Notified Status"]
    var subheading = ["Browse home cook food from neighbours or nearby communities","Stores are categories by food types for your convenience","All product details are clear and comprehensive","Receive notification of your food and payment method are what you agreed with the owner"]
    var imgStrs = ["hint1","hint2","hint3","hint4"]
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let startingVC = contentViewController(at: 0){
            setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        }
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed:Bool){
        if completed{
            if let contentVC = pageViewController.viewControllers?.first as? WalkthroughContentVC{
                currentIndex = contentVC.index
                walkthroughdelegate!.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    

    func contentViewController(at index:Int) -> WalkthroughContentVC?{
        if index < 0 || index >= pageHeading.count{
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(identifier: "WalkthroughContentVC")as? WalkthroughContentVC{
            pageContentViewController.heading = pageHeading[index]
            pageContentViewController.imgStr = imgStrs[index]
            pageContentViewController.subheading = subheading[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
       
    }
    
    func forwardPage(){
        currentIndex += 1
        if let next = contentViewController(at: currentIndex){
            setViewControllers([next], direction: .forward, animated: true, completion: nil)
        }
    }
}
