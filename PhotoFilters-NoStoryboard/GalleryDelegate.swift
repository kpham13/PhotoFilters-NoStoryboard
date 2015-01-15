//
//  GalleryDelegate.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/14/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

protocol GalleryDelegate: class {
  
  func didSelectImage(image: UIImage)
  
}