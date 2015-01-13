//
//  HomeViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  let collectionView = UICollectionView()
  let imageView = UIImageView()
  let actionsButton = UIButton()
  //var thumbnails = [Thumbnails]()
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupImageView()
    self.setupActionsButton()
    
    // Actions Button Auto Layout
    let views = ["actionsButton" : self.actionsButton]
    self.setupConstraintsOnRootView(rootView, forViews: views)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    // Apple recommends this to be last in loadView
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - COLLECTION VIEW DATA SOURCE
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    
    
    return cell
  }
  
  // MARK: - NAVIGATION
  
  func actionsButtonPressed(sender: UIButton) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let filterAction = UIAlertAction(title: "Filter", style: .Default) { (action) -> Void in
      //self.enterFilterMode()
      println("Enter Filter Mode")
    }
    let avfAction = UIAlertAction(title: "AVF Camera", style: .Default) { (action) -> Void in
      //self.performSegueWithIdentifier("SHOW_AVF", sender: self)
      println("Push to AVF")
    }
    let cameraAction = UIAlertAction(title: "ImagePicker Camera", style: .Default) { (action) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let imagePickerAction = UIAlertAction(title: "ImagePicker Moments", style: .Default) { (action) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
      
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let galleryAction = UIAlertAction(title: "HQ Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      let galleryViewController = GalleryViewController()
      self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    let photosAction = UIAlertAction(title: "Photos Framework", style: .Default) { (action) -> Void in
      // Show photos framework
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    alertController.addAction(filterAction)
    alertController.addAction(avfAction)
    alertController.addAction(cameraAction)
    alertController.addAction(imagePickerAction)
    alertController.addAction(galleryAction)
    alertController.addAction(photosAction)
    alertController.addAction(cancelAction)

    self.presentViewController(alertController, animated: true, completion: nil  )
  }

  // MARK: - AUTO LAYOUT
  
  func setupConstraintsOnRootView(rootView: UIView, forViews views: [String : AnyObject]) {
    let actionsButtonConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[actionsButton]-20-|",
                                                                                  options: nil,
                                                                                  metrics: nil,
                                                                                    views: views)
    self.rootView.addConstraints(actionsButtonConstraintVertical)
    
    let actionsButton = views["actionsButton"] as UIView!
    let actionsButtonConstraintHorizontal = NSLayoutConstraint(item: actionsButton,
                                                        attribute: .CenterX,
                                                        relatedBy: NSLayoutRelation.Equal,
                                                           toItem: rootView,
                                                        attribute: NSLayoutAttribute.CenterX,
                                                       multiplier: 1.0,
                                                         constant: 0.0)
    self.rootView.addConstraint(actionsButtonConstraintHorizontal)
  }
  
  // MARK: - SETUP
  
  func setupActionsButton() {
    self.actionsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.actionsButton.setTitle("Actions", forState: .Normal)
    self.actionsButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    self.actionsButton.addTarget(self, action: "actionsButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    self.rootView.addSubview(self.actionsButton)
  }
  
  func setupImageView() {
    self.imageView.frame = CGRectMake(0, 0, 200, 200)
    self.imageView.backgroundColor = UIColor.blueColor()
    self.rootView.addSubview(self.imageView)
  }
  
}