//
//  CustomModelTranstion.swift
//  YHCustomModelTransition
//
//  Created by harvey on 16/6/14.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit

class CustomModelTranstion: UIPercentDrivenInteractiveTransition {

    //设置是否可拖拽
    var dragable:Bool!
    //---保存入口传入的 试图控制器，用于操作
    var modalVC:UIViewController!
    //---保存时弹出还是收起的状态
    var isDismiss:Bool!
    //---拖动手势
    var dragGesture:UIPanGestureRecognizer!
    //---保存frame
    var tempTransform:CATransform3D!
    //---保存当前动画的上下文
    var transitionContext:UIViewControllerContextTransitioning?
    //---保存是否可手势驱动
    var isInteractive:Bool!
    //---保存是否完成
    var isDragEnough:Bool!
    
    
    init(ModelViewController:UIViewController) {
       
        super.init()
        modalVC = ModelViewController
        dragable = false
    }
    
    func setDrageqble(drag:Bool){
    
        dragable = drag
        
        if self.dragable! {
            
            self.dragGesture = UIPanGestureRecognizer(target: self,action:#selector(handlePanGesture))
            self.dragGesture.delegate = self
            self.modalVC.view.addGestureRecognizer(self.dragGesture)
        }
    }
    
    func handlePanGesture(gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translationInView(self.modalVC.view)
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            
            self.isInteractive = true
            self.modalVC.dismissViewControllerAnimated(true, completion:nil)
        
        case UIGestureRecognizerState.Changed:
            
            let percent = (translation.y/UIScreen.mainScreen().bounds.size.height) <= 1 ?(translation.y/UIScreen.mainScreen().bounds.size.height):1
            self.isDragEnough = (percent > 0.2)
            self.updateInteractiveTransition(percent)
        case UIGestureRecognizerState.Cancelled: break
        case UIGestureRecognizerState.Ended:
            
            self.isInteractive = false
            
            if(gesture.state == UIGestureRecognizerState.Cancelled || !self.isDragEnough){
                
                self.cancelInteractiveTransition()
                
            }else{
            
                self.finishInteractiveTransition()
            }
        default: break
            
        }
    }
    
}

extension CustomModelTranstion:UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate{

   
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        print(self.dragable)
        
        if(self.isInteractive && self.dragable){
            
            self.isDismiss = true
            return self
            
        }
        return nil
        
    }
    
    
  

    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        self.tempTransform = toVC?.view.layer.transform
        self.transitionContext = transitionContext
        
        
    }
    
    override func updateInteractiveTransition(percentComplete: CGFloat) {
        
        let transitionContext = self.transitionContext
        let fromVC = transitionContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let scale = 1 + ((1/0.8*0.95)-1)*percentComplete
        toVC?.view.layer.transform = CATransform3DScale(self.tempTransform,scale,scale,1)
        let nowFrame = CGRectMake(0,CGRectGetHeight((fromVC?.view.bounds)!)*percentComplete,CGRectGetWidth((fromVC?.view.frame)!),CGRectGetHeight((fromVC?.view.frame)!))
        fromVC?.view.frame = nowFrame
        
    }
    
    override func finishInteractiveTransition() {
     
        let transitionContext = self.transitionContext
        let fromVC = transitionContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        let finalRect = CGRectMake(0,CGRectGetHeight((fromVC?.view.bounds)!),CGRectGetWidth((fromVC?.view.frame)!),CGRectGetHeight((fromVC?.view.frame)!))

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            let transition = CATransform3DIdentity
            toVC?.view.layer.transform = transition
            fromVC?.view.frame = finalRect
        
        }) { (true) in
            
            transitionContext?.completeTransition(true)
            self.modalVC = nil
            
        }
        
    }
    
    override func cancelInteractiveTransition() {
       
        let transitionContext = self.transitionContext
        let fromVC = transitionContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        UIView.animateWithDuration(0.4, delay:0, usingSpringWithDamping:5, initialSpringVelocity:5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
           
            toVC?.view.layer.transform = self.tempTransform
            fromVC?.view.frame  = CGRectMake(0,0,CGRectGetWidth((fromVC?.view.frame)!),CGRectGetHeight((fromVC?.view.frame)!))
            
            
            
            }) { (true) in
                
                transitionContext?.completeTransition(false)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        if(!self.isDismiss!){
        
        
            fromVC?.view.layer.zPosition = -300
            toVC?.view.layer.zPosition = 300
            
            let finalRect = transitionContext.finalFrameForViewController(toVC!)
            toVC?.view.frame = CGRectOffset(finalRect,0,UIScreen.mainScreen().bounds.height)
            containerView?.addSubview((toVC?.view)!)
        
            UIView.animateWithDuration(transitionDuration(transitionContext)/2, delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                fromVC?.view.layer.transform = self.firstTransform()
                
                
                }, completion: { (finished) in
                    
                    
                    UIView.animateWithDuration(self.transitionDuration(transitionContext)/2, delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        
                        fromVC?.view.layer.transform = self.secondTransform()
                        
                        }, completion: { (finished) in
                            
                            
                    })
            })
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                toVC?.view.frame = finalRect
                
                }, completion: { (finished) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            
        }else{
        
        
            let initRect = transitionContext.initialFrameForViewController(fromVC!)
            let finalRect = CGRectOffset(initRect,0,UIScreen.mainScreen().bounds.height)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext)/2, delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                toVC?.view.layer.transform = self.firstTransform()
                
                }, completion: { (finished) in
                
                    UIView.animateWithDuration(self.transitionDuration(transitionContext)/2, delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        
                        toVC?.view.layer.transform = CATransform3DIdentity
                       
                        }, completion: { (finished) in
                            
                    })
                })
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay:0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                fromVC?.view.frame = finalRect
                
                }, completion: { (finished) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        
        }
        
    }
    
    
  
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isDismiss = false
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isDismiss = true
        return self
    }
    
    func firstTransform()->CATransform3D{
    
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -900
    transform = CATransform3DScale(transform,0.95,0.95,1)
    transform = CATransform3DRotate(transform,CGFloat(15 * M_PI/180), 1,0,0)
    return transform
    
    }
    
    func secondTransform()->CATransform3D{
    
     var transform = CATransform3DIdentity
     transform.m34 = firstTransform().m34
     transform = CATransform3DTranslate(transform,0,0, 0)
     transform = CATransform3DScale(transform,0.8,0.8,1)
     return transform
    
    }
    
}


