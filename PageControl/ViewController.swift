//
//  ViewController.swift
//  PageControl
//
//  Created by Guang Lei on 2019/4/29.
//  Copyright © 2019 Guang Lei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageControl: PageControl!
    
    lazy var pageViewController = {
        return children.first as! PageViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageControl()
        setupPageViewController()
        
        // set the default selected Index if needed.
//        pageControl.selectedIndex = 1
//        pageViewController.selectedIndex = 1
    }
    
    func setupPageControl() {
        pageControl.titles = ["明月夜", "春雨", "润无声", "古道风", "未未读"]
        pageControl.indexChanged = { [weak self] (newIndex) in
            print("page control index changed:", newIndex)
            self?.pageViewController.selectedIndex = newIndex
        }
    }
    
    func setupPageViewController() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .purple
        let vc5 = UIViewController()
        vc5.view.backgroundColor = .cyan
        pageViewController.viewControllers = [vc1, vc2, vc3, vc4, vc5]
        pageViewController.indexChanged = { [weak self] (newIndex) in
            print("page view controller index changed:", newIndex)
            self?.pageControl.selectedIndex = newIndex
        }
    }
}
