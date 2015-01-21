//
//  UserAnimationController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/25/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class UserAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var selectedCell : UICollectionViewCell!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //getting both the view controller we are presenting from (fromVC) and the one we are presenting (toVC)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UsersSearchViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as SelectedUserViewController
        let containerView = transitionContext.containerView()
      
      //generate our moving image view
      let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
      let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
      let cellSnapshot = cell.imageView.snapshotViewAfterScreenUpdates(false)
      cellSnapshot.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
      cell.imageView.hidden = true
  
        //start the toVC with alpha 0 so we dont see it initially
      toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
      toVC.view.alpha = 0
      toVC.imageView.hidden = true
      
      containerView.addSubview(toVC.view)
      containerView.addSubview(cellSnapshot)
      toVC.view.setNeedsLayout()
      toVC.view.layoutIfNeeded()
      
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
          toVC.view.alpha = 1
          let frame = containerView.convertRect(toVC.imageView.frame, fromView: toVC.view)
          cellSnapshot.frame = frame
            
        }) { (finished) -> Void in
            
           toVC.imageView.hidden = false
           cell.imageView.hidden = false
          cellSnapshot.removeFromSuperview()
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        

    }
}
