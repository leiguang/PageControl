//
//  PageViewController.swift
//  PageControl
//
//  Created by Guang Lei on 2019/4/29.
//  Copyright © 2019 Guang Lei. All rights reserved.
//

import UIKit
import SnapKit

class PageViewController: UIViewController {
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            setupPageController()
        }
    }
    
    var selectedIndex = 0 {
        didSet {
            changeIndex(fromIndex: oldValue, toIndex: selectedIndex)
        }
    }
    
    var indexChanged: ((_ nextIndex: Int) -> Void)?
    
    private let pageController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
    private var nextIndex: Int?
    
    private func setupPageController() {
        guard selectedIndex >= 0, selectedIndex < viewControllers.count else {
            return
        }
        pageController.delegate = self
        pageController.dataSource = self
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        changeIndex(fromIndex: nil, toIndex: selectedIndex)
    }
    
    private func changeIndex(fromIndex: Int?, toIndex: Int) {
        guard toIndex >= 0, toIndex < viewControllers.count else {
            return
        }
        guard (fromIndex == nil) || (fromIndex != nil && fromIndex! != toIndex) else {
            return
        }
        let toViewController = viewControllers[toIndex]
        var direction: UIPageViewController.NavigationDirection
        if (fromIndex == nil) || (fromIndex != nil && fromIndex! <= toIndex) {
            direction = .forward
        } else {
            direction = .reverse
        }
        pageController.setViewControllers([toViewController], direction: direction, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = selectedIndex - 1
        guard previousIndex >= 0, previousIndex < viewControllers.count else {
            return nil
        }
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = selectedIndex + 1
        guard nextIndex >= 0, nextIndex < viewControllers.count else {
            return nil
        }
        return viewControllers[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextViewController = pendingViewControllers.first, let nextIndex = viewControllers.firstIndex(of: nextViewController) else {
            return
        }
        self.nextIndex = nextIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let nextIndex = nextIndex {
            selectedIndex = nextIndex
            indexChanged?(nextIndex)
        }
        nextIndex = nil
    }
}
