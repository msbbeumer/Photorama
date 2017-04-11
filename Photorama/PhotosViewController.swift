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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    store.fetchInterestingPhotos {
      (photosResult) -> Void in
      
      switch photosResult {
      case let .success(photos):
        print("successfully found \(photos.count) photos.")
      case let .failure(error):
        print("Error fetching interesting photos: \(error)")
      }
    }
  }
  
}
