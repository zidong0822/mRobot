
//  RZSimpleCollectionViewController.swift
//  RZTransitions-Demo

//  Created by Eric Slosser on 11/16/15.
//  Copyright © 2015 Raizlabs and other contributors.
//  http://raizlabs.com/

//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:

//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import CoreGraphics
import UIKit
import RZTransitions
let kRZCollectionViewCellReuseId = "kRZCollectionViewCellReuseId"
let kRZCollectionViewNumCells = 2
let kRZCollectionViewCellSize: CGFloat = 320

@objc(RZSimpleCollectionViewController)
final class RZSimpleCollectionViewController: UIViewController
    , UICollectionViewDataSource
    , UICollectionViewDelegate
    , UIViewControllerTransitioningDelegate
    , RZTransitionInteractionControllerDelegate
    , RZCirclePushAnimationDelegate
    , RZRectZoomAnimationDelegate
{

    var circleTransitionStartPoint: CGPoint = CGPointZero
    var transitionCellRect: CGRect = CGRectZero
    var presentOverscrollInteractor: RZOverscrollInteractionController?
    var presentDismissAnimationController: RZRectZoomAnimationController?
    var colltionView : UICollectionView?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
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
        
        presentDismissAnimationController = RZRectZoomAnimationController()
        presentDismissAnimationController?.rectZoomDelegate = self
        RZTransitionsManager.shared().setAnimationController( presentDismissAnimationController,
        fromViewController:self.dynamicType,
        forAction:.PresentDismiss )
        transitioningDelegate = RZTransitionsManager.shared()
    }

//MARK: - New VC Helper Methods

    func newColorVCWithColor(color: UIColor?) -> UIViewController {
        let newColorVC = CarViewController()
        newColorVC.transitioningDelegate = RZTransitionsManager.shared()
        return newColorVC
    }
    
    func droneViewController(color: UIColor?) -> UIViewController {
        let newColorVC = DroneViewController()
        newColorVC.transitioningDelegate = RZTransitionsManager.shared()
        return newColorVC
    }

//MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) else {
            fatalError("no cell at \(indexPath)")
        }
        if(indexPath.section == 0){
        let colorVC = newColorVCWithColor(cell.backgroundColor ?? UIColor.clearColor())
        circleTransitionStartPoint = collectionView.convertPoint(cell.center, toView:view)
        transitionCellRect = collectionView.convertRect(cell.frame, toView:view)
        presentViewController(colorVC, animated:true) {}
        }else{
            let colorVC = droneViewController(cell.backgroundColor ?? UIColor.clearColor())
            circleTransitionStartPoint = collectionView.convertPoint(cell.center, toView:view)
            transitionCellRect = collectionView.convertRect(cell.frame, toView:view)
            presentViewController(colorVC, animated:true) {}
            
        
        }
    }

//MARK: - UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Home_Cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    
        return UIEdgeInsetsMake(0,0,0,0)
        
    }
    
//MARK: - RZTransitionInteractionControllerDelegate

    func nextViewControllerForInteractor() -> UIViewController? {
        return newColorVCWithColor(nil)
    }

//MARK: - RZRectZoomAnimationDelegate

    func rectZoomPosition() -> CGRect {
        return transitionCellRect
    }

//MARK: - RZCirclePushAnimationDelegate

    func circleCenter() -> CGPoint {
        return circleTransitionStartPoint;
    }

    func circleStartingRadius() -> CGFloat {
        return (kRZCollectionViewCellSize / 2.0);
    }
}