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
  let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupPhotoButton()
    
    // Photo Button Autolayout
    let views = ["photoButton" : photoButton]
    self.setupConstraintsOnRootView(rootView, forViews: views)
    self.view = rootView
    
    let galleryAlert = UIAlertAction(title: "HQ Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      let galleryViewController = GalleryViewController()
      self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    self.alertController.addAction(galleryAlert)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func photoButtonPressed(sender: UIButton) {
    self.presentViewController(self.alertController, animated: true, completion: nil  )
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