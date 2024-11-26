//
//  BackgroundRemovealViewController.swift
//  FotoFlex
//
//  Created by Unique Consulting Firm on 24/08/2024.
//

import UIKit

import AVFoundation
import Photos

class BackgroundRemovealViewController: UIViewController {

    @IBOutlet weak var RemoverButton: UIButton!

    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var imagePicker = UIImagePickerController()
    
    var ImporImage = UIImage()
    var removedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientToButton(button: RemoverButton)

        indicatorView.isHidden = true
        inputImage.addSubview(indicatorView)
    }
    

    @IBAction func backgroundRemoverbtnPressed(_ sender:UIButton) {
        // Check if an image is imported
        guard ImporImage.size.width != 0 else {
            showAlert(title: "No Image", message: "Please import an image first.")
            return
        }
        if let removedBackgroundImage = ImporImage.removeBackground(returnResult: .finalImage) {
            inputImage.image = removedBackgroundImage
            removedImage = inputImage.image
        }
    }
        

    @IBAction func downloadbtnPressed(_ sender:UIButton) {
        // Check if an image is imported
        guard ImporImage.size.width != 0 else {
            showAlert(title: "No Image", message: "Please import an image first.")
            return
        }

        let newImage2 = drawImage(removedImage ?? ImporImage)
        let newImage = UIImage(data: newImage2!.pngData()!)!
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        inputImage.image = UIImage(named: "bgremover")
        ImporImage = UIImage()
        showAlert(title: "Success!", message: "Your image has been saved to your Photos.")
    }
    
    @IBAction func importbtnPressed(_ sender:UIButton)
    {
        showStyleSheet()
    }
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
    func drawImage(_ image: UIImage) -> UIImage?
        {
            guard let coreImage = image.cgImage else {
                return nil;
            }
            UIGraphicsBeginImageContext(CGSize(width: coreImage.width, height: coreImage.height))
            image.draw(in: CGRect(x: Int(0.0), y: Int(0.0), width: coreImage.width, height: coreImage.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
            return resultImage;
        }
    
    func showStyleSheet()
    {
        let styleSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Capture from Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Select from Gallery", style: .default) { [weak self] _ in
            self?.chooseImageFromGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        styleSheet.addAction(cameraAction)
        styleSheet.addAction(galleryAction)
        styleSheet.addAction(cancelAction)
        
        present(styleSheet, animated: true, completion: nil)
    }
    
    func openCamera()
   {
       let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
       
       switch cameraAuthorizationStatus {
       case .authorized:
        DispatchQueue.main.async { [weak self] in
               self?.presentCamera()
        }
       case .notDetermined:
           AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
               DispatchQueue.main.async {
                   if granted {
                       self?.presentCamera()
                   } else {
                       self?.redirectToSettings()
                   }
               }
           }
       case .denied, .restricted:
           redirectToSettings()
       @unknown default:
           break
       }
   }
    
    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    private func redirectToSettings()
    {
        let alertController = UIAlertController(title: "Permission Required", message: "Please enable access to the camera or photo library in Settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func chooseImageFromGallery() {
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
           activityIndicator.center = view.center
           activityIndicator.startAnimating()
           view.addSubview(activityIndicator)
        
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoLibraryAuthorizationStatus {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.presentImagePicker(with: activityIndicator)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async
                {
                    if status == .authorized
                    {
                        self?.presentImagePicker(with: activityIndicator)
                    } else {
                        self?.redirectToSettings()
                    }
                }
            }
        case .denied, .restricted:
            redirectToSettings()
        case .limited:
            // Handle limited photo library access if needed
            break
        @unknown default:
            break
        }
    }
    
    private func presentImagePicker(with activityIndicator: UIActivityIndicatorView) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true) {
            // Dismiss the activity indicator once the gallery is presented
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    

}

extension BackgroundRemovealViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        inputImage.image = image
        ImporImage  = image

    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
