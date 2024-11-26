//
//  WallpaperCollectionViewCell.swift
//  PixelMingle
//
//  Created by Moin Janjua on 28/08/2024.
//

import UIKit

class WallpaperCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cview: UIView!
    @IBOutlet weak var Imgs: UIImageView!

     override func awakeFromNib() {
         super.awakeFromNib()
    
         cview.layer.cornerRadius = 15
        
    // Set up shadow properties
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 2)
      layer.shadowOpacity = 0.3
      layer.shadowRadius = 4.0
      layer.masksToBounds = false

      // Set background opacity
        contentView.alpha = 1.5 // Adjust opacity as needed

}
}
