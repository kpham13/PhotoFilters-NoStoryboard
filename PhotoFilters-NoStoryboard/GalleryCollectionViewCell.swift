//
//  GalleryCollectionViewCell.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/13/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.imageView)
    self.imageView.frame = self.bounds
    self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
    self.imageView.layer.masksToBounds = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}