//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Mischa Beumer on 4/10/17.
//  Copyright © 2017 msbbeumer. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
  
  @IBOutlet var switchBarButton: UIBarButtonItem!
  @IBOutlet var collectionView: UICollectionView!
  var store: PhotoStore!
  let photoDataSource = PhotoDataSource()
  
  @IBAction func toggleList(_ sender: UIBarButtonItem) {
    if store.photoListSelector == 0 {
      store.photoListSelector = 1
      switchBarButton.title = "Interesting"
    } else {
      store.photoListSelector = 0
      switchBarButton.title = "Recent"
    }
    viewDidLoad()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = photoDataSource
    collectionView.delegate = self
    
    
    store.fetchPhotosList {
      (photosResult) -> Void in
      
      switch photosResult {
      case let .success(photos):
        print("successfully found \(photos.count) photos.")
        self.photoDataSource.photos = photos
      case let .failure(error):
        print("Error fetching interesting photos: \(error)")
        self.photoDataSource.photos.removeAll()
      }
      self.collectionView.reloadSections(IndexSet(integer: 0))
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let photo = photoDataSource.photos[indexPath.row]
    
    store.fetchImage(for: photo){
      (result) -> Void in
      
      guard let photoIndex = self.photoDataSource.photos.index(of: photo), case let .success(image) = result else {
        return
      }
      let photoIndexPath = IndexPath(item: photoIndex, section: 0)
      
      if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell { cell.update(with: image) }
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showPhoto"?:
      if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
        let photo = photoDataSource.photos[selectedIndexPath.row]
        
        let destinationVC = segue.destination as! PhotoInfoViewController
        destinationVC.photo = photo
        destinationVC.store = store
      }
    default:
      preconditionFailure("Unexpected segue identifier")
    }
  }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.size.width
    let numberOfItemsPerRow: CGFloat = 4
    let itemWidth = (collectionViewWidth / numberOfItemsPerRow) - 2
    
    return CGSize(width: itemWidth, height: itemWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    let interItemSpacing: CGFloat = 2
    return interItemSpacing
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.reloadData()
  }
}
