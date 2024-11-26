//
//  PhotoFramesViewController.swift
//  FotoFlex
//
//  Created by Unique Consulting Firm on 25/08/2024.
//

import UIKit

class PhotoFramesViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedImages  = ["temp1","temp2","temp3","temp4","temp5","temp6","temp7","temp8","temp9","temp10","temp11","temp12","temp13","temp14","temp15"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
       
    }
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count // Number of selected images to display in the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoFramesCollectionViewCell
        let name = selectedImages[indexPath.item]
        
        cell.imageView.image = UIImage(named: name) // Set the image to display in the cell
        cell.imageView.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = selectedImages[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FramesDetailsViewController") as! FramesDetailsViewController
        newViewController.Frame_Imge = item
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}
