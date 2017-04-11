//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Mischa Beumer on 4/10/17.
//  Copyright © 2017 msbbeumer. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var store: PhotoStore!
  
  @IBAction func toggleList(_ sender: UIBarButtonItem) {
    if store.photoListSelector == 0 {
      store.photoListSelector = 1
    } else {
      store.photoListSelector = 0
    }
    store.fetchPhotosList {
      (photosResult) -> Void in
      
      switch photosResult {
      case let .success(photos):
        print("successfully found \(photos.count) photos.")
        if let firstPhoto = photos.first {
          self.updateImageView(for: firstPhoto)
        }
      case let .failure(error):
        print("Error fetching interesting photos: \(error)")
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    store.fetchPhotosList {
      (photosResult) -> Void in
      
      switch photosResult {
      case let .success(photos):
        print("successfully found \(photos.count) photos.")
        if let firstPhoto = photos.first {
          self.updateImageView(for: firstPhoto)
        }
      case let .failure(error):
        print("Error fetching interesting photos: \(error)")
      }
    }
  }
  
  func updateImageView(for photo: Photo) {
    store.fetchImage(for: photo) {
      (imageResult) -> Void in
      
      switch imageResult {
      case let .success(image):
        self.imageView.image = image
      case let .failure(error):
        print("Error downloading image: \(error)")
      }
    }
  }
  
}
