//
//  AJPageView.swift
//  AJPageView
//
//  Created by 艾晶 on 2017/4/14.
//  Copyright © 2017年 艾晶. All rights reserved.
//

import UIKit



class AJPageView: UIView {
    
    
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var style : AJTitlesStyle
    
    fileprivate var titleView : AJTitleView!
    
    init(frame: CGRect,titles: [String], childVcs: [UIViewController], parentVc: UIViewController, style: AJTitlesStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- 设置UI界面
extension AJPageView {
    
    fileprivate func setupUI() {
        
        setupTitleView()
        setupContentView()
        
    }
    
    private func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = AJTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView!)
        titleView.backgroundColor = UIColor.randomColorWithAlpha()
    }
    
    private func setupContentView() {
        
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        
        let contentView = AJContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        
        titleView.delegate = contentView
        contentView.delegate = titleView
        
    }
    
}


















