//
//  UsersSearchViewController.swift
//  GithubClient
//
//  Created by Bradley Johnson on 1/20/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class UsersSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
  
  var users = [User]()

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  let animationController = UserAnimationController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.searchBar.delegate = self
      self.collectionView.dataSource = self
      self.navigationController?.delegate = self
        // Do any additional setup after loading the view.
    }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    NetworkController.sharedNetworkController.fetchUsersWithSearchTerm(searchBar.text, completionHandler: { (errorDescription, results) -> (Void) in
      self.users = results!
      self.collectionView.reloadData()
    })
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    ++cell.tag
    let tag = cell.tag
    cell.imageView.image = nil
    let user = self.users[indexPath.row]
    if user.avatarImage != nil {
      cell.imageView.image = user.avatarImage
    } else {
      
     NetworkController.sharedNetworkController.fetchAvatarImageWithURLString(user.avatarURL, completionHandler: { (userImage) -> (Void) in
        if cell.tag == tag {
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            user.avatarImage = userImage
            cell.imageView.image = userImage
            
          })
        }
      })
    }
    
    return cell
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.users.count
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationVC = segue.destinationViewController as SelectedUserViewController
    var indexPaths = self.collectionView.indexPathsForSelectedItems()
    let indexPath = indexPaths.first as NSIndexPath
    let user = self.users[indexPath.row]
    destinationVC.selectedUser = user
    self.animationController.selectedCell = self.collectionView.cellForItemAtIndexPath(indexPath)
  }
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if toVC is SelectedUserViewController {
      return self.animationController
    }
    else {
      return nil
    }
  }
  

}
