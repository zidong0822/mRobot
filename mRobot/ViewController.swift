//
//  ViewController.swift
//  mRobot
//
//  Created by harvey on 16/5/16.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
import TabPageViewController
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var colltionView : UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT)
        colltionView = UICollectionView(frame: CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT), collectionViewLayout: layout)
        colltionView! .registerClass(Home_Cell.self, forCellWithReuseIdentifier:"cell")
        colltionView?.delegate = self;
        colltionView?.showsHorizontalScrollIndicator = false
        colltionView?.dataSource = self;
        colltionView?.pagingEnabled = true
        colltionView?.backgroundColor = UIColor.whiteColor()
        self.view .addSubview(colltionView!)
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Home_Cell
        if(indexPath.section == 0){
        
            cell.backgroundColor = UIColor.clearColor()
        }else
        {
        cell.backgroundColor = UIColor.blackColor()
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0,0,0,0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}

