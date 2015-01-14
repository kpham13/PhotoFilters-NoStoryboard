//
//  PhotosViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/14/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
  
  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.rootView.backgroundColor = UIColor.whiteColor()
    
    self.view = self.rootView
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}