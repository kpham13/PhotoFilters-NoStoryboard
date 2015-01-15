//
//  HomeViewController.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/12/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import UIKit
import CoreData
import Social

//import CoreImage
//import OpenGLES

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, GalleryDelegate {

  var filters = [Filter]()
  var thumbnails = [FilteredThumbnail]()
  
  let rootView = UIView(frame: UIScreen.mainScreen().bounds)
  var collectionView : UICollectionView!
  var collectionViewYConstraint : NSLayoutConstraint!
  let imageView = UIImageView()
  var imageViewHeightConstraint : NSLayoutConstraint!
  var imageViewWidthConstraint : NSLayoutConstraint!
  let actionsButton = UIButton()
  var composeButton : UIBarButtonItem!
  var cancelButton : UIBarButtonItem!
  var gpuContext : CIContext!
  var currentImage : UIImage?
  var originalThumbnail : UIImage?
  var imageQueue = NSOperationQueue()
  var hasChanged : Bool?
  
  override func loadView() {
    self.rootView.backgroundColor = UIColor.whiteColor()
    self.setupActionsButton()
    self.setupComposeButton()
    self.setupImageView()
    self.setupCollectionView()
    self.collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "FILTER_CELL")

    // Auto Layout
    let views = ["actionsButton" : self.actionsButton, "imageView" : self.imageView, "collectionView" : self.collectionView]
    self.setupConstraintsOnRootView(self.rootView, forViews: views)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    // Apple recommends this to be last in loadView
    self.view = self.rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupCoreImageContext()
    self.generateThumbnail()
    self.coreDataSeeder()
    self.fetchFilters()
    self.resetFilterThumbnails()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - PHOTO FILTERS
  
  func fetchFilters() {
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var context = appDelegate.managedObjectContext
    
    var error : NSError?
    var fetchRequest = NSFetchRequest(entityName: "Filter")
    let fetchResults = context?.executeFetchRequest(fetchRequest, error: &error)
    if let filters = fetchResults as? [Filter] {
      self.filters = filters
    }
  }
  
  func generateThumbnail() {
    let size = CGSize(width: 150, height: 150)
    
    UIGraphicsBeginImageContext(size)
    self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 150, height: 150))
    self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  func resetFilterThumbnails() {
    var newFilters = [FilteredThumbnail]()
    for filterIndex in 0...(self.filters.count-1) {
      var filter = self.filters[filterIndex]
      var filterName = filter.name
      var thumbnail = FilteredThumbnail(name: filterName, originalThumbnail: self.originalThumbnail!, context: self.gpuContext, operationQueue: self.imageQueue)
      newFilters.append(thumbnail)
    }
    
    self.thumbnails = newFilters
  }
  
  func applyFilter(thumbnail: FilteredThumbnail) {
    var image = CIImage(image: self.currentImage)
    var imageFilter = CIFilter(name: thumbnail.filterName)
    imageFilter.setDefaults()
    imageFilter.setValue(image, forKey: kCIInputImageKey)
    
    var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
    var extent = result.extent()
    var imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
    var filteredImage = UIImage(CGImage: imageRef!)
    self.imageView.image = filteredImage
  }
  
  func revertFilter() {
    self.imageView.image = self.currentImage
    self.navigationItem.leftBarButtonItem = nil
    self.hasChanged = false
  }
  
  // MARK: - SOCIAL
  
  func postToTwitter(sender: AnyObject) {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      var tweetSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      tweetSheet.setInitialText("What's happening?")
      tweetSheet.addImage(self.imageView.image)
      
      self.presentViewController(tweetSheet, animated: true, completion: nil)
    } else {
      let alertController = UIAlertController(title: "Twitter unavailable", message: "Please log in to your Twitter account in Settings", preferredStyle: .Alert)
      var okAlert = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(okAlert)
      
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  // MARK: - IMAGE PICKER
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    var image = info[UIImagePickerControllerEditedImage] as UIImage
    self.currentImage = image
    self.imageView.image = image
    self.generateThumbnail()
    self.resetFilterThumbnails()
    self.collectionView.reloadData()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - COLLECTION VIEW DATA SOURCE
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.thumbnails.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as GalleryCollectionViewCell
    
    let filteredThumbnail = self.thumbnails[indexPath.row]
    if filteredThumbnail.filteredImage != nil {
      cell.imageView.image = filteredThumbnail.filteredImage
    } else {
      cell.imageView.image = filteredThumbnail.originalImage
      filteredThumbnail.generateThumbnail({ (image) -> (Void) in
        if let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? GalleryCollectionViewCell {
          cell.imageView.image = image
        }
      })
    }
    
    return cell
  }
  
  // MARK: - COLLECTION VIEW DELEGATE
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var filteredThumbnail = self.thumbnails[indexPath.row]
    self.applyFilter(filteredThumbnail)
    
    self.hasChanged = true
    self.exitFilterMode()
  }
  
  // MARK: - GALLERY DELEGATE
  
  func didSelectImage(image: UIImage) {
    self.currentImage = image
    self.imageView.image = image
    self.generateThumbnail()
    self.resetFilterThumbnails()
    self.collectionView.reloadData()
  }
  
  // MARK: - NAVIGATION
  
  func actionsButtonPressed(sender: UIButton) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let filterAction = UIAlertAction(title: "Filters", style: .Default) { (action) -> Void in
      self.enterFilterMode()
    }
    let avfAction = UIAlertAction(title: "AVF Camera", style: .Default) { (action) -> Void in
      let avfViewController = AVFViewController()
      self.presentViewController(avfViewController, animated: true, completion: nil)
    }
    let cameraAction = UIAlertAction(title: "ImagePicker Camera", style: .Default) { (action) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      if UIImagePickerController.isSourceTypeAvailable(.Camera) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
      } else {
        let cameraAlertController = UIAlertController(title: "No camera available", message: "There is no camera available", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        cameraAlertController.addAction(okAction)
        self.presentViewController(cameraAlertController, animated: true, completion: nil)
      }
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
      galleryViewController.delegate = self
      self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    let photosAction = UIAlertAction(title: "Photos Framework", style: .Default) { (action) -> Void in
      let photosViewControler = PhotosViewController()
      self.navigationController?.pushViewController(photosViewControler, animated: true)
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
  
  // MARK: - ANIMATION
  
  func enterFilterMode() {
    self.imageViewHeightConstraint.constant = self.imageViewHeightConstraint.constant * 0.9
    self.imageViewWidthConstraint.constant = self.imageViewWidthConstraint.constant * 0.9
    self.collectionViewYConstraint.constant = 50 //20
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "exitFilterMode")
    self.navigationItem.leftBarButtonItem = self.cancelButton
    self.navigationItem.rightBarButtonItem = nil
    self.actionsButton.hidden = true
  }
  
  func exitFilterMode() {
    self.imageViewHeightConstraint.constant = self.imageViewHeightConstraint.constant / 0.9
    self.imageViewWidthConstraint.constant = self.imageViewWidthConstraint.constant / 0.9
    self.collectionViewYConstraint.constant = -120
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    if self.hasChanged == true {
      let revertButton = UIBarButtonItem(title: "Revert", style: .Bordered, target: self, action: "revertFilter")
      self.navigationItem.leftBarButtonItem = revertButton
    } else {
      self.navigationItem.leftBarButtonItem = nil
    }
    
    self.navigationItem.rightBarButtonItem = self.composeButton
    self.actionsButton.hidden = false
  }
  
  // MARK: - AUTO LAYOUT
  
  func setupConstraintsOnRootView(rootView: UIView, forViews views: [String : AnyObject]) {
    // Actions Button
    let actionsButtonConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[actionsButton]-20-|",
                                                                                 options: nil,
                                                                                 metrics: nil,
                                                                                   views: views)
    rootView.addConstraints(actionsButtonConstraintVertical)
    let actionsButton = views["actionsButton"] as UIView!
    let actionsButtonConstraintHorizontal = NSLayoutConstraint(item: actionsButton,
                                                          attribute: .CenterX,
                                                          relatedBy: NSLayoutRelation.Equal,
                                                             toItem: rootView,
                                                          attribute: NSLayoutAttribute.CenterX,
                                                         multiplier: 1.0,
                                                           constant: 0.0)
    rootView.addConstraint(actionsButtonConstraintHorizontal)
    actionsButton.setContentHuggingPriority(750, forAxis: .Vertical)
    
    // Image View
    let imageViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-72-[imageView]-30-[actionsButton]",
                                                                             options: nil,
                                                                             metrics: nil,
                                                                               views: views)
    rootView.addConstraints(imageViewConstraintVertical)
    let imageView = views["imageView"] as UIView!
    let imageViewConstraintHorizontal = NSLayoutConstraint(item: imageView,
                                                      attribute: .CenterX,
                                                      relatedBy: NSLayoutRelation.Equal,
                                                         toItem: rootView,
                                                      attribute: NSLayoutAttribute.CenterX,
                                                     multiplier: 1.0,
                                                       constant: 0.0)
    rootView.addConstraint(imageViewConstraintHorizontal)
    let imageViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[imageView(300)]",
                                                                           options: nil,
                                                                           metrics: nil,
                                                                             views: views)
    rootView.addConstraints(imageViewConstraintHeight)
    self.imageViewHeightConstraint = imageViewConstraintHeight.first as NSLayoutConstraint
    let imageViewConstraintWidth = NSLayoutConstraint.constraintsWithVisualFormat("H:[imageView(300)]",
                                                                          options: nil,
                                                                          metrics: nil,
                                                                            views: views)
    rootView.addConstraints(imageViewConstraintWidth)
    self.imageViewWidthConstraint = imageViewConstraintWidth.first as NSLayoutConstraint
    
    // Collection View
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]",
                                                                                options: nil,
                                                                                metrics: nil,
                                                                                  views: views)
    self.collectionView.addConstraints(collectionViewConstraintHeight)
    let collectionViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|",
                                                                                    options: nil,
                                                                                    metrics: nil,
                                                                                      views: views)
    rootView.addConstraints(collectionViewConstraintHorizontal)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|",
                                                                                  options: nil,
                                                                                  metrics: nil,
                                                                                    views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
    self.collectionViewYConstraint = collectionViewConstraintVertical.first as NSLayoutConstraint
  }
  
  // MARK: - SETUP
  
  func setupActionsButton() {
    self.actionsButton.setTitle("Actions", forState: .Normal)
    self.actionsButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    self.actionsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.actionsButton.addTarget(self, action: "actionsButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    self.rootView.addSubview(self.actionsButton)
  }
  
  func setupComposeButton() {
    composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "postToTwitter:")
    self.navigationItem.rightBarButtonItem = composeButton
  }
  
  func setupImageView() {
    let placeholderImage = UIImage(named: "placeholder")
    self.currentImage = placeholderImage
    self.imageView.image = placeholderImage
    
    self.imageView.frame = CGRectMake(0, 0, 200, 200)
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 10
    self.imageView.layer.borderWidth = 3.0
    self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
    self.imageView.clipsToBounds = true
    self.imageView.backgroundColor = UIColor.blueColor()
    self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.rootView.addSubview(self.imageView)
  }
  
  func setupCollectionView() {
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    //self.collectionView.backgroundColor = UIColor.whiteColor()
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Horizontal
    self.rootView.addSubview(self.collectionView)
  }
  
  func setupCoreImageContext() {
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
  }
  
  func coreDataSeeder() {
    var launchedOnce = NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")
    if launchedOnce != true {
      println("First time launching, seeding data")
      var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate // Access AppDelegate
      var seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
      
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
      NSUserDefaults.standardUserDefaults().synchronize()
      seeder.seedCoreData()
    } else {
      println("Has launched before, not seeding data")
    }
  }
  
}