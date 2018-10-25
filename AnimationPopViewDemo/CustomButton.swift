
//
//  CustomButton.swift
//  AnimationPopViewDemo
//
//  Created by Cary on 2018/7/16.
//  Copyright © 2018年 Cary. All rights reserved.
//

import UIKit


class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let kIconHeight = 71
    let kTitleHeight = 30
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = CGRect(x:0, y: (contentRect.size.height - CGFloat(kIconHeight) - CGFloat(kTitleHeight)) / 2, width: contentRect.size.width, height: CGFloat(kIconHeight))
        return rect
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = CGRect(x:0, y: (contentRect.size.height - CGFloat(kIconHeight) - CGFloat(kTitleHeight)) / 2+CGFloat(kIconHeight), width: contentRect.size.width, height: CGFloat(kIconHeight))
        
        return rect
    }
}

