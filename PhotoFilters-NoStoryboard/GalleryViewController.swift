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
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: collectionViewFlowLayout)
    collectionViewFlowLayout.itemSize = CGSize(width: 200, height: 200)
    rootView.addSubview(self.collectionView)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println("Gallery VC launched")
    self.collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
    //Append images
    let image1 = UIImage(named: "unsplash_1.jpg")
    let image2 = UIImage(named: "unsplash_2.jpg")
    self.images.append(image1!)
    self.images.append(image2!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - COLLECTION VIEW DATA SOURCE
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let  cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    let image = self.images[indexPath.row]
    cell.imageView.image = image
    
    return cell
  }
  
  // MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.navigationController?.popViewControllerAnimated(true)
  }

}