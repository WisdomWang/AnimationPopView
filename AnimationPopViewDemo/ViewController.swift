//
//  ViewController.swift
//  AnimationPopViewDemo
//
//  Created by Cary on 2018/7/16.
//  Copyright © 2018年 Cary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        let button = UIButton(type: .contactAdd)
        button.center = self.view.center
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    @objc func click() {
        
        var imgs:Array = [String]()
        for i in 0..<7 {
        
            imgs.append("publish_\(i)")
        }
        let titles = ["文字", "图片", "视频", "语言", "投票", "签到", "直播"]
        PopView.showWithImages(imgs: imgs, titles: titles) { (index) in
            
            print(index)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

