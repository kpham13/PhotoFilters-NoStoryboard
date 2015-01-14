//
//  FilteredThumbnail.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/13/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class FilteredThumbnail {
  
  var filterName : String
  var filter : CIFilter?
  var originalImage : UIImage
  var filteredImage : UIImage?
  var gpuContext : CIContext
  var imageQueue : NSOperationQueue
  
  init(name: String, originalThumbnail: UIImage, context: CIContext, operationQueue: NSOperationQueue) {
    self.filterName = name
    self.originalImage = originalThumbnail
    self.gpuContext = context
    self.imageQueue = operationQueue
  }
  
  func generateThumbnail(completionHandler: (image: UIImage) -> (Void)) {
    var image = CIImage(image: self.originalImage)
    var imageFilter = CIFilter(name: self.filterName)
    imageFilter.setDefaults()
    imageFilter.setValue(image, forKey: kCIInputImageKey)
    let result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
    let extent = result.extent()
    let imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
    self.filteredImage = UIImage(CGImage: imageRef)
    
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      completionHandler(image: self.filteredImage!)
    }
  }
  
}