//
//  TimelineScrollingViewController.swift
//  TimelineScrollingViewController
//
//  Created by Felipe Ricieri on 23/08/2018.
//  Copyright © 2018 Ricieri ME. All rights reserved.
//

import UIKit

open class TimelineScrollingViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    public var mainScrollView: UIScrollView!
    public weak var timelineScrollController: TimelineScrollController!
    
    public var viewControllers: [TimelineSectionable] {
        set {
            self.removeAllViewControllers()
            self.items = newValue.map { TimelineSection($0 as! UIViewController, $0.preferredHeightInTimeline() ) }
            self.relayoutItems()
        }
        get { return self.items.map { $0.controller as! TimelineSectionable } }
    }
    
    private var items: [TimelineSection] = []
    
    private var scrollWrapperOriginY: CGFloat = 0
    
    // MARK: - Lifecycle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard mainScrollView != nil && timelineScrollController != nil else {
            fatalError("You must connect a valid - main & inner - scroll view to the view controller")
        }
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.delegate = self
        timelineScrollController.scrollView.isScrollEnabled = false
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.relayoutItems()
    }
    
    // MARK: - Private methods
    
    private func removeAllViewControllers() {
        self.items.forEach {
            $0.controller.removeFromParentViewController()
            $0.controller.view.removeFromSuperview()
        }
        self.timelineScrollController.view.removeFromSuperview()
        self.items.removeAll()
    }
    
    public func relayoutItems() {
        
        scrollWrapperOriginY = 0
        
        var offset_y: CGFloat = 0.0
        let width = mainScrollView!.frame.size.width
        var contentSizeHeight : CGFloat = 0
        
        for item in self.items {
            
            item.rect = CGRect(x: 0.0, y: offset_y, width: width, height: item.sectionHeight)
            item.controller.view.frame = item.rect
            mainScrollView.addSubview(item.controller.view)
            
            contentSizeHeight += item.sectionHeight
            offset_y += item.sectionHeight
        }
        
        scrollWrapperOriginY = offset_y
        
        let rect = CGRect(x: 0.0, y: scrollWrapperOriginY, width: width, height: mainScrollView.bounds.height)
        timelineScrollController.view.frame = rect
        mainScrollView.addSubview(timelineScrollController.view)
        contentSizeHeight += timelineScrollController.scrollView.contentSize.height
        
        self.mainScrollView.contentSize = CGSize(width: width, height: contentSizeHeight)
        self.adjustContentOnScroll()
    }
    
    private func adjustContentOnScroll() {
        
        let contentOffset = mainScrollView.contentOffset
        let minY : CGFloat = scrollWrapperOriginY
        
        if  contentOffset.y > minY {
            guard !mainScrollView.isBouncing else { return }
            timelineScrollController.view.frame.origin.y = contentOffset.y
            timelineScrollController.scrollView.contentOffset = CGPoint(x: 0, y: contentOffset.y - minY)
        } else {
            timelineScrollController.view.frame.origin.y = minY
            timelineScrollController.scrollView.contentOffset = .zero
        }
    }
    
    // MARK: - Scrollview Delegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.mainScrollView else { return }
        self.adjustContentOnScroll()
    }
}

public final class TimelineSection {
    var controller: UIViewController
    var sectionHeight: CGFloat
    var rect: CGRect = .zero
    init(_ controller: UIViewController, _ sectionHeight: CGFloat) {
        self.controller = controller
        self.sectionHeight = sectionHeight
    }
}

public protocol TimelineSectionable: class {
    func preferredHeightInTimeline() -> CGFloat
}

public protocol TimelineScrollController: class {
    var view: UIView! { get }
    var scrollView: UIScrollView! { get }
}



