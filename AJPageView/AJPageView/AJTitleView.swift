//
//  AJTitleView.swift
//  AJPageView
//
//  Created by 艾晶 on 2017/4/14.
//  Copyright © 2017年 艾晶. All rights reserved.
//

import UIKit

protocol AJTitleViewDelegate: class {
    func titleView(_ titleView: AJTitleView, targetIndex: Int)
    
}

class AJTitleView: UIView {

    
    weak var delegate: AJTitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style: AJTitlesStyle
    
    fileprivate lazy var currentIndex: Int = 0
    
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    
    fileprivate lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        
        return scrollView
        
        
    }()
    
    init(frame: CGRect, titles: [String], style: AJTitlesStyle) {
        
        self.titles = titles
        self.style = style
        
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension AJTitleView {

    fileprivate func setupUI() {
        addSubview(scrollView)
        
        setupTitleLabels()
        
        //设置titlelable的frame
        setupTitleLabelsFrame()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
            
            let tagGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tagGes)
            titleLabel.isUserInteractionEnabled = true
            
        }
    }
    
    
    private func setupTitleLabelsFrame() {
        
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable {
                //可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT),height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).width
                if i == 0 {
                    x = style.itemMargin * 0.5
                } else {
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                    
                }
                
                
            } else {
                //不可滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: (titleLabels.last)!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
        
    }
}

//MARK: -监听事件
extension AJTitleView {

    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        
        //找到用户点击View 以及 上一个view
        let targetLabel = tapGes.view as! UILabel
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        //通知contentView
        delegate?.titleView(self, targetIndex: currentIndex)
        
        
        
        
    }
    
    fileprivate func adjustTitleLabel(targetIndex: Int){
        
        if targetIndex == currentIndex {
            return
        }
        
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //切换文字
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        //记录下标值
        currentIndex = targetIndex
        
        //调整位置
        if style.isScrollEnable {
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            
            if offsetX < 0 {
                offsetX = 0
            }
            
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
    }
    
}

//MARK: - 遵守AJContentViewDelegate
extension AJTitleView: AJContentViewDelegate {
    
    func contentView(_ contentView: AJContentView, targetIndex: Int) {
        
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: AJContentView, targetIndex: Int, progress: CGFloat) {
        //1.取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //2.颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectedRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.2 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.2 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        
    }
    
}





























