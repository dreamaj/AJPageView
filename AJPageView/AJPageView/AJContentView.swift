//
//  AJContentView.swift
//  AJPageView
//
//  Created by 艾晶 on 2017/4/14.
//  Copyright © 2017年 艾晶. All rights reserved.
//

import UIKit

/*
    self. 不能省略的情况
    1> 在方法中和其他标识符有歧义
    2> 在闭包中self.不能省略
 */


private let kContentCellID = "kContentCellID"

protocol AJContentViewDelegate: class {
    func contentView(_ contentView: AJContentView, targetIndex: Int)
    func contentView(_ contentView: AJContentView, targetIndex: Int, progress: CGFloat)
}

class AJContentView: UIView {

    weak var delegate: AJContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0.0
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        
        
        return collectionView
        
    }()
    
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


extension AJContentView {

    fileprivate func setupUI() {
        
        
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        
        
        addSubview(collectionView)
        
    }
    
}

extension AJContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    
}

//MARK: - UICollectionView的delegate
extension AJContentView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断和开始时的偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x else {
            return
        }

        //定义targetIndex及progress
        var targetIndex = 0
        var progress: CGFloat = 0.0
        
        //给targetIndex、progess赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x { //向左滑动
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
            
        }else{ //右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        
        //通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    private func contentEndScroll() {
        
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)

        
        //通知titleView进行调整
        delegate?.contentView(self, targetIndex: currentIndex)
        
    }
}


//MARK: - 遵守AJTitleViewDelegate
extension AJContentView: AJTitleViewDelegate {

    func titleView(_ titleView: AJTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}




















