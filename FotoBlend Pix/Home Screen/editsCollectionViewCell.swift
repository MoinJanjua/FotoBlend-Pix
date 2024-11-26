//
//  editsCollectionViewCell.swift
//  PickFlick Snap
//
//  Created by Moin Janjua on 02/09/2024.
//

import UIKit

class editsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eLabel: UILabel!
    
    @IBOutlet weak var eImages: UIImageView!
    
    @IBOutlet weak var curveView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        curveView.layer.cornerRadius = 10

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
