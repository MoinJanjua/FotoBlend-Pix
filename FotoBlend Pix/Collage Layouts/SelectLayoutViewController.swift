//
//  SelectLayoutViewController.swift
//  PixelMingle
//
//  Created by Moin Janjua on 23/08/2024.
//

import UIKit

class SelectLayoutViewController: UIViewController {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CollectionView.dataSource = self
        CollectionView.delegate = self
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension SelectLayoutViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return layoutImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as! CollectionViewCell
        
//        cell.Meds_labelNames.text = isSearching ? filteredData[indexPath.item] : MedicineName[indexPath.item]
        cell.Imgs.image? = layoutImages [indexPath.item]
        
        return cell
  
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Item at index \(indexPath.item) selected")
//        let item = isSearching ? filteredData[indexPath.item] : MedicineName[indexPath.item]
        let item = layoutImages [indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let secondVC = storyboard.instantiateViewController(withIdentifier: "CollaegSetsViewController")
          as! CollaegSetsViewController
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.indexPath = indexPath.item
        self.present(secondVC, animated: true)
        
    }

}
