//
//  ScrollView.swift
//  HTCollectScroll
//
//  Created by taotao on 1/16/16.
//  Copyright © 2016 taotao. All rights reserved.
//

import Foundation
import UIKit

class HTScrollView:UIView,UICollectionViewDelegate,UICollectionViewDataSource{

    let screenSize = UIScreen.mainScreen().bounds.size
    let numberOfCollectionSections = 20
    let scrollInterval:NSTimeInterval = 3
    
    //MARK:- properties
    var collectionView:UICollectionView?
    let ItemIdentifier = "ItemIdentifier"
    var imageArray:[String]?
    var timer:NSTimer?
    var pageControl:UIPageControl?
    var collectLayout:UICollectionViewFlowLayout?
   
    
    var dataArray:[String]{
        get{
            return self.imageArray!
        }
        
        set(datas){
            self.imageArray = datas
            if let timer = self.timer{
                timer.invalidate()
                self.timer = nil
            }
            //将indexPath.item == 0
            self.setupTimer()
            // 先reloadData然后再 UICollectionView scrollToItemAtIndexPath
            self.collectionView?.reloadData()
            self.restScrollItem2Zero()
            self.setupPageControl(datas)
        }
    }
    
    //MARK:- override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupData()
        self.setupUI()
        self.setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- private methods
    private func setupData(){
        self.imageArray = ["da1.jpg","da2.jpg","da3.jpg","da4.jpg","da5.jpg"]
    }
    
    
    private func setupUI(){
        //setup collecitonViewLayout
        self.collectLayout = UICollectionViewFlowLayout.init()
        self.collectLayout!.scrollDirection = .Horizontal
        //        collectLayout.sectionInset = UIEdgeInsetsMake(50, 10, 50, 15);
        self.collectLayout!.minimumLineSpacing = 0
        self.collectLayout!.itemSize = CGSizeMake(screenSize.width, self.frame.height)
        
        // setup collectionView
        self.collectionView = UICollectionView.init(frame: self.bounds,collectionViewLayout:self.collectLayout!)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.pagingEnabled = true
        self.addSubview(self.collectionView!)
        
        let cellNib = UINib.init(nibName: "CollectionCell", bundle: nil)
        self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: ItemIdentifier)
        let imageCount = self.imageArray?.count
        self.collectionView?.contentSize = CGSizeMake(self.frame.width * CGFloat(imageCount!) , self.frame.height)
        
        //将indexPath.item == 0
        self.restScrollItem2Zero()
        // setup UIPageControl
        let pageControlHeight = self.frame.height * 0.2
        let pageControlWidth = self.frame.width
        let y = self.frame.height - pageControlHeight
        let pageFrame = CGRectMake(0, y, pageControlWidth, pageControlHeight)
        self.pageControl = UIPageControl.init(frame: pageFrame)
        self.addSubview(self.pageControl!)
        
    }
    
    
    func setupTimer(){
        if self.timer == nil{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(scrollInterval, target: self, selector: Selector("startupScrollView"), userInfo: nil, repeats: true)
        }
    }
    
   //timer selector scroll imageView in UICollectionView reset section to middle
    func startupScrollView(){
//        print("startupscrollView.....")
        let midIndexPath = self.scrollCollectionView2Mid()
        let imgCount = self.imageArray?.count
        let itemIndex = (midIndexPath.item + 1) % imgCount!
        var  section = midIndexPath.section
        
        if itemIndex == 0{
            section = midIndexPath.section + 1
        }
        let scrollIndex = NSIndexPath.init(forItem: itemIndex, inSection: section)
        self.collectionView?.scrollToItemAtIndexPath(scrollIndex, atScrollPosition:
            UICollectionViewScrollPosition.Left, animated: true)
        // set UIPageControl current page number 
//        self.pageControl?.currentPage = itemIndex
        
    }
    
    
    private func restScrollItem2Zero(){
        // 第一次将section设为中间位置
        let midSectionIndexPath = NSIndexPath.init(forItem:0, inSection: numberOfCollectionSections/2)
        
        self.collectionView?.scrollToItemAtIndexPath(midSectionIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    private func scrollCollectionView2Mid()-> NSIndexPath{
        // scroll CollectionView to mid position
        let currentIndexPath = self.collectionView?.indexPathsForVisibleItems().first
        let midIndexPath = NSIndexPath.init(forItem: (currentIndexPath?.item)!, inSection: numberOfCollectionSections/2)
        
        self.collectionView?.scrollToItemAtIndexPath(midIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        return midIndexPath
    }
    
    
   
    
    
    private func setupPageControl(imgsArray:[String]){
        self.pageControl?.numberOfPages = imgsArray.count
        self.pageControl?.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl?.pageIndicatorTintColor = UIColor.orangeColor()
        self.pageControl?.currentPage = 0
    }
    
    
    
   
    
    //MARK:- UIScrollViewDelegate  Methods 
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //set up uipageControl current page number
        let pageControlIndex = Int((self.collectionView?.contentOffset.x)! / (self.collectLayout?.itemSize.width)!)
        self.pageControl?.currentPage = pageControlIndex % self.dataArray.count
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let timer = self.timer{
            timer.invalidate()
            self.timer = nil
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.setupTimer()
    }
    
    //MARK:- UICollectionViewDataSource Methods 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.imageArray?.count)!
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(ItemIdentifier, forIndexPath: indexPath) as! CollectionCell
        item.image = self.imageArray![indexPath.row]
        
        return item
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfCollectionSections
    }
    

    
}