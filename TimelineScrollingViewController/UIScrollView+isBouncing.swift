//
//  UIScrollView+isBouncing.swift
//  TimelineScrollingViewController
//
//  Created by Felipe Ricieri on 23/08/2018.
//  Copyright © 2018 Ricieri ME. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    /**
     * Returns TRUE if scrollview is bouncing overall
     */
    public var isBouncing: Bool {
        return isBouncingTop || isBouncingBottom
    }
    
    /**
     * Returns TRUE if scrollview is bouncing on top
     */
    public var isBouncingTop: Bool {
        return contentOffset.y < -contentInset.top
    }
    
    /**
     * Returns TRUE if scrollview is bouncing on bottom
     */
    public var isBouncingBottom: Bool {
        let contentFillsScrollEdges = contentSize.height + contentInset.top + contentInset.bottom >= bounds.height
        return contentFillsScrollEdges && contentOffset.y > contentSize.height - bounds.height + contentInset.bottom
    }
}
