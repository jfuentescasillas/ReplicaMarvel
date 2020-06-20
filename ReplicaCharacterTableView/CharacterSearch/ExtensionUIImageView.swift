//
//  ExtensionUIImageView.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 15/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit


// MARK: Extension: ImageView
/*
This extension helps to load the images into the search cell of the table view.
*/
let imageCache = NSCache<NSString, UIImage>()
var imageUrlString: String?

extension UIImageView {
	func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
		imageUrlString = "\(url)"
		image = nil
        
        if let imageFromCache = imageCache.object(forKey: "\(url)" as NSString) {
            self.image = imageFromCache
            
			return
        }
		
        let imageTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)  // This is when the image is loaded for the 1st time
				else { return }
			
            DispatchQueue.main.async() { [weak self] in
				guard let imageToCache = UIImage(data: data) else { return }
				
				if imageUrlString == "\(url)" {
					self?.image = imageToCache
                }
								
                self?.image = image // Loading image for the 1st time
				imageCache.setObject(imageToCache, forKey: "\(url)" as NSString) // Image is stored in cache and this will help to prevent the "reuse" of cells, which will help to avoid to show an incorrect image for a determined character.
            }
        }
		
		imageTask.resume()
    }
	
	
	func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

