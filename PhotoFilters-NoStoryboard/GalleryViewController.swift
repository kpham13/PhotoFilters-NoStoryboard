//
//  GalleryViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println("Gallery VC launched")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}