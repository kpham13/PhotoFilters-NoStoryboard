//
//  ViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  let photoButton = UIButton()
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupPhotoButton()
    
    // Photo Button Autolayout
    let views = ["photoButton" : photoButton]
    self.setupConstraintsOnRootView(rootView, forViews: views)
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func photoButtonPressed(sender: UIButton) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    let galleryAlert = UIAlertAction(title: "HQ Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      let galleryViewController = GalleryViewController()
      self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    alertController.addAction(galleryAlert)
    /*
    // Instantiate UIAlertController
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet) // UIAlertControllerStyle is an enum. Once typed, it'll give you options afterwards.
    
    // Create UIAlertActions
    let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (action) -> Void in
      // Filter Action, calling animation function
      self.enterFilterMode()
    }
    let avfAction = UIAlertAction(title: "AVF Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.performSegueWithIdentifier("SHOW_AVF", sender: self)
    }
    let cameraAction = UIAlertAction(title: "ImagePicker Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let imagePickerAction = UIAlertAction(title: "ImagePicker Moments", style: UIAlertActionStyle.Default) { (action) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
      
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let galleryAction = UIAlertAction(title: "HQ Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      // Segue from HomeViewController to GalleryViewController
      self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
    }
    
    let photosAction = UIAlertAction(title: "Photos Framework", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.performSegueWithIdentifier("SHOW_PHOTOS", sender: self)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    
    // Add actions to UIAlertController
    alertController.addAction(filterAction)
    alertController.addAction(avfAction)
    alertController.addAction(cameraAction)
    alertController.addAction(imagePickerAction)
    alertController.addAction(galleryAction)
    alertController.addAction(photosAction)
    alertController.addAction(cancelAction)
    
    // Show alertController
    self.presentViewController(alertController, animated: true, completion: nil)
    */

    self.presentViewController(alertController, animated: true, completion: nil  )
  }

  // MARK: AUTO LAYOUT
  
  func setupConstraintsOnRootView(rootView: UIView, forViews views: [String : AnyObject]) {
    let photoButtonConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|",
                                                                                  options: nil,
                                                                                  metrics: nil,
                                                                                    views: views)
    
    self.rootView.addConstraints(photoButtonConstraintVertical)
    let photoButton = views["photoButton"] as UIView!
    let photoButtonConstraintHorizontal = NSLayoutConstraint(item: photoButton,
                                                        attribute: .CenterX,
                                                        relatedBy: NSLayoutRelation.Equal,
                                                           toItem: rootView,
                                                        attribute: NSLayoutAttribute.CenterX,
                                                       multiplier: 1.0,
                                                         constant: 0.0)
    
    self.rootView.addConstraint(photoButtonConstraintHorizontal)
  }
  
  // MARK: SETUP
  
  func setupPhotoButton() {
    self.photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.photoButton.setTitle("Photos", forState: .Normal)
    self.photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    self.photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    self.rootView.addSubview(photoButton)
  }
  
}