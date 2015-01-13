//
//  HomeViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  let photoButton = UIButton()
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupPhotoButton()
    
    // Photo Button Autolayout
    let views = ["photoButton" : self.photoButton]
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
  
  // MARK: - NAVIGATION
  
  func photoButtonPressed(sender: UIButton) {
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
  
  // MARK: - SETUP
  
  func setupPhotoButton() {
    self.photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.photoButton.setTitle("Photos", forState: .Normal)
    self.photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    self.photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    self.rootView.addSubview(self.photoButton)
  }
  
}