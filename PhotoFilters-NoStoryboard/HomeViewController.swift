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
  var collectionView : UICollectionView!
  var collectionViewYConstraint : NSLayoutConstraint!
  let imageView = UIImageView()
  let actionsButton = UIButton()
  var thumbnails = [FilteredThumbnail]()
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupActionsButton()
    self.setupImageView()
    self.setupCollectionView()
    
    // Auto Layout
    let views = ["actionsButton" : self.actionsButton, "imageView" : self.imageView, "collectionView" : self.collectionView]
    self.setupConstraintsOnRootView(self.rootView, forViews: views)
    self.setupConstraintsOnCollectionView(self.rootView, forViews: views)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    // Apple recommends this to be last in loadView
    self.view = self.rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "FILTER_CELL")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - COLLECTION VIEW DATA SOURCE
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.thumbnails.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    let thumbnail = self.thumbnails[indexPath.row]
    if thumbnail.originalImage != nil {
      if thumbnail.filteredImage == nil {
        thumbnail.generateThumbnail({ (image) -> (Void) in
          cell.imageView.image = thumbnail.filteredImage!
        })
      }
    }
    
    return cell
  }
  
  // MARK: - NAVIGATION
  
  func actionsButtonPressed(sender: UIButton) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let filterAction = UIAlertAction(title: "Filter", style: .Default) { (action) -> Void in
      //self.enterFilterMode()
      println("Enter Filter Mode")
      self.collectionViewYConstraint.constant = 20
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        self.view.setNeedsLayout()
      })
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
    rootView.addConstraints(actionsButtonConstraintVertical)
    let actionsButton = views["actionsButton"] as UIView!
    let actionsButtonConstraintHorizontal = NSLayoutConstraint(item: actionsButton,
                                                          attribute: .CenterX,
                                                          relatedBy: NSLayoutRelation.Equal,
                                                             toItem: rootView,
                                                          attribute: NSLayoutAttribute.CenterX,
                                                         multiplier: 1.0,
                                                           constant: 0.0)
    rootView.addConstraint(actionsButtonConstraintHorizontal)
    let imageViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-72-[imageView]-30-[actionsButton]",
                                                                             options: nil,
                                                                             metrics: nil,
                                                                               views: views)
    rootView.addConstraints(imageViewConstraintVertical)
    let imageViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|",
                                                                               options: nil,
                                                                               metrics: nil,
                                                                                 views: views)
    rootView.addConstraints(imageViewConstraintHorizontal)
  }
  
  func setupConstraintsOnCollectionView(rootView: UIView, forViews views: [String : AnyObject]) {
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]",
                                                                                options: nil,
                                                                                metrics: nil,
                                                                                  views: views)
    self.collectionView.addConstraints(collectionViewConstraintHeight)
    let collectionViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|",
                                                                                    options: nil,
                                                                                    metrics: nil,
                                                                                      views: views)
    rootView.addConstraints(collectionViewConstraintHorizontal)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|",
                                                                                  options: nil,
                                                                                  metrics: nil,
                                                                                    views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
    self.collectionViewYConstraint = collectionViewConstraintVertical.first as NSLayoutConstraint
  }
  
  // MARK: - SETUP
  
  func setupActionsButton() {
    self.actionsButton.setTitle("Actions", forState: .Normal)
    self.actionsButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    self.actionsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.actionsButton.addTarget(self, action: "actionsButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    self.rootView.addSubview(self.actionsButton)
  }
  
  func setupImageView() {
    self.imageView.frame = CGRectMake(0, 0, 200, 200)
    self.imageView.backgroundColor = UIColor.blueColor()
    self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.rootView.addSubview(self.imageView)
  }
  
  func setupCollectionView() {
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    //self.collectionView.backgroundColor = UIColor.whiteColor()
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Horizontal
    self.rootView.addSubview(self.collectionView)
  }
  
}