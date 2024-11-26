//
//  WallpaperViewController.swift
//  PixelMingle
//
//  Created by Moin Janjua on 28/08/2024.
//

import UIKit

class WallpaperViewController: UIViewController {

    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
  
    let imagesList = ["one","two","three","four","five","six","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wallpaperCollectionView.dataSource = self
        wallpaperCollectionView.delegate = self
        wallpaperCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension WallpaperViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCollectionViewCell
        cell.Imgs.image = UIImage(named: imagesList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width - 20, height: width + 20)
      // return CGSize(width: wallpaperCollectionView.frame.size.width , height: wallpaperCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right:20) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
      // let item = imagesList [indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "DetailWallpaperVC")
        as! DetailWallpaperVC
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.selectedImage = UIImage(named: imagesList[indexPath.item])
        self.present(secondVC, animated: true)
        
    }
}
