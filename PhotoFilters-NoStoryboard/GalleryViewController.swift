//
//  GalleryViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  var collectionView : UICollectionView!
  var images = [UIImage]()
  var thumbnails = [UIImage]()
  weak var delegate : GalleryDelegate?
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupCollectionView()
    self.collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
    
    let views = ["collectionView" : self.collectionView]
    self.setupConstraintsOnRootView(self.rootView, forViews: views)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.view = self.rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addImages()
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
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    let thumbnail = self.thumbnails[indexPath.row]
    cell.imageView.image = thumbnail
    
    return cell
  }
  
  // MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.didSelectImage(self.images[indexPath.row])
    self.navigationController?.popViewControllerAnimated(true)
  }

  
  func setupConstraintsOnRootView(rootView: UIView, forViews views: [String : AnyObject]) {
    let collectionViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|",
                                                                                    options: nil,
                                                                                    metrics: nil,
                                                                                      views: views)
    rootView.addConstraints(collectionViewConstraintHorizontal)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|",
                                                                                  options: nil,
                                                                                  metrics: nil,
                                                                                    views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
  }
  
  // MARK: - SETUP
  
  func addImages() {
    for imageIndex in 1...14 {
      let size = CGSize(width: 100, height: 100)
      var image = UIImage(named: "unsplash_\(imageIndex).jpg")
      self.images.append(image!)
      
      UIGraphicsBeginImageContext(size)
      image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
      image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.thumbnails.append(image!)
    }
  }
  
  func setupCollectionView() {
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Vertical
    self.rootView.addSubview(self.collectionView)
  }
  
}

