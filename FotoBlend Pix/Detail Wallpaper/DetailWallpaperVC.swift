//
//  DetailWallpaperVC.swift
//  PixelMingle
//
//  Created by Moin Janjua on 29/08/2024.
//

import UIKit

class DetailWallpaperVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = selectedImage
    }
    func saveImageToPhotoLibrary(_ image: UIImage) {
           UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
       }
       
       // Completion handler to handle success or failure
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               // If an error occurs, print it or show an alert
               print("Error saving image: \(error.localizedDescription)")
               showAlert(title: "Save error", message: error.localizedDescription)
           } else {
               // Notify the user that the save was successful
               print("Image saved successfully!")
               showAlert(title: "Saved!", message: "Your image has been saved to your photos.")
           }
       }
       
    @IBAction func DownloadWpButton(_ sender: Any) {
        
        // Check if there is an image to download
               guard let image = selectedImage else {
                   print("No image found!")
                   return
               }
               
               // Save the image to the photo library
               saveImageToPhotoLibrary(image)
    }
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
