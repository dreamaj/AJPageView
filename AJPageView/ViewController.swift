//
//  ViewController.swift
//  AJPageView
//
//  Created by 艾晶 on 2017/4/14.
//  Copyright © 2017年 艾晶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

//        let titles = ["游戏","娱乐","趣玩","美女","户外"]
        let titles = ["游戏","娱乐","趣趣趣趣趣趣玩","美女女","户外","娱乐","趣玩","美女","户外","其他"]
        let style = AJTitlesStyle()
        style.isScrollEnable = true
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
    
        
        let pageView = AJPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        view.addSubview(pageView)
        
        
        
        
    }



}

