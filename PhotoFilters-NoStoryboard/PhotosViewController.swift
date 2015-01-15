//
//  PhotosViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/14/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  var collectionView : UICollectionView!
  var imageManager : PHCachingImageManager!
  var assetFetchResult : PHFetchResult!
  var cellSize : CGSize!
  var assetCellSize : CGSize!
  var originalSize : CGSize!
  weak var delegate : GalleryDelegate?
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupCollectionView()
    self.setupPhotosFramework()
    self.collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "PHOTOS_CELL")
    
    let views = ["collectionView" : self.collectionView]
    self.setupConstraintsOnRootView(self.rootView, forViews: views)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.view = self.rootView
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
    return self.assetFetchResult.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOS_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    var currentTag = cell.tag + 1
    cell.tag = currentTag

    var asset = self.assetFetchResult[indexPath.row] as PHAsset
    cell.imageView.backgroundColor = UIColor.blueColor()
    self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: .AspectFill, options: nil) { (image, info) -> Void in
      if cell.tag == currentTag {
        cell.imageView.image = image
      }
    }
    
    return cell
  }
  
  // MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var asset = self.assetFetchResult[indexPath.row] as PHAsset
    self.imageManager.requestImageForAsset(asset, targetSize: self.originalSize, contentMode: .AspectFill, options: nil) { (image, info) -> Void in
      self.delegate?.didSelectImage(image)
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  // MARK: - AUTO LAYOUT
  
  func setupConstraintsOnRootView(rootView: UIView, forViews views: [String : AnyObject]) {
    let collectionViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintHorizontal)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
  }
  
  // MARK: - SETUP

  func setupCollectionView() {
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    //collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    self.cellSize = collectionViewFlowLayout.itemSize
    collectionViewFlowLayout.scrollDirection = .Vertical
    self.rootView.addSubview(self.collectionView)
  }
  
  func setupPhotosFramework() {
    self.imageManager = PHCachingImageManager()
    self.assetFetchResult = PHAsset.fetchAssetsWithOptions(nil)
    var scale = UIScreen.mainScreen().scale
    self.assetCellSize = CGSizeMake(self.cellSize.width * scale, self.cellSize.height * scale)
    self.originalSize = CGSize(width: 300, height: 300)
  }
  
}