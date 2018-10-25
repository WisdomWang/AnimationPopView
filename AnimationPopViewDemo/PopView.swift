

//
//  PopView.swift
//  AnimationPopViewDemo
//
//  Created by Cary on 2018/7/16.
//  Copyright © 2018年 Cary. All rights reserved.
//

import UIKit
typealias callbackFunc = (_ num:NSInteger) -> Void

let SCREEN_WIDTH  = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
extension UIDevice {
    
    public func isX() -> Bool {
        
//        if UIScreen.main.bounds.height == 812 {
//            return true
//        }
        
        let  window = UIApplication.shared.windows.last
        if window?.safeAreaInsets.bottom ?? 0 > CGFloat(0) {
            
            return true
        }
      
        return false
    }
    
}
let TAB_BAR_SAFE_BOTTOM_MARGIN = (UIDevice.current.isX() ? 34 : 0)

class PopView: UIView,UIScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
            let kColumnCount = 3
            let kAnimationDuration : TimeInterval = 0.3
            var imageNames:Array<Any> = []
            var titles:Array<Any> = []
            let scrollView = UIScrollView()
            let pageControl = UIPageControl()
            let shutImageView = UIImageView()
            var currentPage = NSInteger()
            var evaluationBlockCallback:callbackFunc?

    class func showWithImages(imgs:Array<Any>,titles:Array<Any>,selectBlock:@escaping (NSInteger)->Void) {
        
        let bg = PopView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(TAB_BAR_SAFE_BOTTOM_MARGIN)))
        bg.backgroundColor = UIColor.white
        bg.alpha = 0.9
        let window = UIApplication.shared.windows.last
        window?.addSubview(bg)
        let effect = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = bg.bounds
        bg.addSubview(effectView)
        bg.evaluationBlockCallback = selectBlock
        let tap = UITapGestureRecognizer(target: bg, action: #selector(close(gesture:)))
        bg.addGestureRecognizer(tap)
        bg.imageNames = imgs
        bg.titles = titles
        bg.setupMainView()
        bg.setupItem()
        bg.setupBottom()
    }
    func setupMainView() {

        scrollView.frame = CGRect(x: 0, y: SCREEN_WIDTH*0.7, width: SCREEN_WIDTH, height: 300)
        scrollView.delegate = self
        let pages = (titles.count-1)/(kColumnCount*2)+1
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(pages), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        pageControl.numberOfPages = pages
        pageControl.currentPage = 0
        pageControl.frame = CGRect(x: self.frame.size.width / 2 - 10, y: self.bounds.size.height - 49 - 20 - 20, width: 20, height: 20)
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.green
        self.addSubview(pageControl)
    
    }
    func setupItem() {
    
        let vMargin = 15
        let vSpacing = 20
        let itemWidth = scrollView.frame.size.width/CGFloat(kColumnCount)
        let itemHeight = (265 - 2 * vMargin-vSpacing) / 2
        var row = 0
        var loc = 0
        var x:CGFloat = 0
        var y:CGFloat = 0
        for i in 0..<imageNames.count {
            row = i/kColumnCount % 2
            loc = i % kColumnCount
            x = itemWidth * CGFloat(loc) + (CGFloat(i/(kColumnCount)/2)) * scrollView.frame.size.width
            if (i / (kColumnCount * 2) > 0) {
                
                y = CGFloat(vMargin) + (itemWidth + CGFloat(vSpacing)) * CGFloat(row)
            }
            else {
                y = scrollView.frame.size.height  + CGFloat((itemHeight + vSpacing) * row)
            }
            let button = CustomButton(frame: CGRect(x: x, y: y, width: itemWidth, height: CGFloat(itemHeight)))
            button.tag = 1000 + i
            button.setTitle(titles[i] as? String, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setImage(UIImage(named: (imageNames[i] as? String)!), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.titleLabel?.textAlignment = .center
            button.imageView?.contentMode = .center
            self.scrollView.addSubview(button)
            button.addTarget(self, action: #selector(selectClick(button:)), for: .touchUpInside)
            if  i < kColumnCount * 2 {
                
                UIView.animate(withDuration: kAnimationDuration, delay: Double(i) * 0.03, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.04, options: .allowUserInteraction, animations: {
                    button.frame = CGRect (x: itemWidth * CGFloat(loc), y: CGFloat(vMargin)+CGFloat((itemHeight+vSpacing)*row), width: itemWidth, height: CGFloat(itemHeight))
                    
                }) { (finished) in
                }
            }
        }
    }
    func setupBottom() {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - 49, width: self.bounds.size.width, height: 49))
        self.addSubview(bottomView)
        let line = UIView (frame: CGRect(x: 0, y: 0, width: bottomView.bounds.size.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        bottomView.addSubview(line)
        
        shutImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        shutImageView.image = UIImage(named: "icon_add")
        shutImageView.center = CGPoint(x: bottomView.bounds.size.width * 0.5, y: bottomView.bounds.size.height * 0.5)
        bottomView.addSubview(shutImageView)
        UIView.animate(withDuration: kAnimationDuration) {
            self.shutImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        }
    }
    @objc func selectClick(button:CustomButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
         self.alpha = 0
        }) { (finished) in
            
        self.removeFromSuperview()
            
        }
        self.evaluationBlockCallback!(button.tag-1000)
    }
    
    @objc func close(gesture:UITapGestureRecognizer){
     
        UIView.animate(withDuration: kAnimationDuration) {
            self.shutImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
        pageControl.isHidden = true
        let dy = self.frame.height + 70
        var count = 0
        if imageNames.count/(kColumnCount * 2) > currentPage {
            
            count = kColumnCount * 2
        }
        else {
            count = imageNames.count % (kColumnCount * 2)
        }
        for i in 0..<count {
            let button = self.viewWithTag(1000 + currentPage * (kColumnCount * 2) + i)
            let width = button?.frame.width
            let buttonX = button?.frame.origin.x
            UIView.animate(withDuration: kAnimationDuration, delay: 0.03 * Double(count - i), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.04, options: .curveEaseInOut, animations: {
                button?.frame = CGRect(x: buttonX!, y: dy, width: width!, height: width!)
            }) { (finished) in
                self.removeFromSuperview()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        currentPage = NSInteger(page)
        pageControl.currentPage = Int(page)
    }
}
