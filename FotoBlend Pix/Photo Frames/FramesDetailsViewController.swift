//
//  FramesDetailsViewController.swift
//  FotoFlex
//
//  Created by Unique Consulting Firm on 25/08/2024.
//

import UIKit
import AVFoundation
import Photos

class FramesDetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var userAddedImage: UIImageView!
    
    var Frame_Imge = String()
    var user_added_image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frameImage.image = UIImage(named: Frame_Imge)
        userAddedImage.contentMode = .scaleAspectFit
        userAddedImage.isUserInteractionEnabled = true
        
        showStyleSheet()
        
        // Add gesture recognizers for adjusting the image
        addGestureRecognizers()
    }
    
    private func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))

        userAddedImage.addGestureRecognizer(panGesture)
        userAddedImage.addGestureRecognizer(pinchGesture)
        userAddedImage.addGestureRecognizer(rotationGesture)
        userAddedImage.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.minimumPressDuration = 0.1
            gesture.setValue(gesture.location(in: view), forKey: "initialLocation")
            
        case .changed:
            guard let initialLocation = gesture.value(forKey: "initialLocation") as? CGPoint else { return }
            
            let location = gesture.location(in: view)
            let deltaX = location.x - initialLocation.x
            let deltaY = location.y - initialLocation.y
            
            let delta = max(deltaX, deltaY)
            let scale = 1 + (delta / 100) // Adjust the divisor to control sensitivity
            
            userAddedImage.transform = userAddedImage.transform.scaledBy(x: scale, y: scale)
            
            gesture.setValue(location, forKey: "initialLocation")
            
        default:
            break
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        let translation = gesture.translation(in: view)
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }

    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }

    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0.0
    }

    @IBAction func importbtnPressed(_ sender: UIButton) {
        showStyleSheet()
    }
    
    @IBAction func backbtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ShareButton(_ sender: Any) {
        // Check if the userAddedImage has an image set
        guard let imageToShare = userAddedImage.image else {
            let alert = UIAlertController(title: "No Image", message: "Please add an image first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Create a UIActivityViewController for sharing the image
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        
        // Present the share sheet
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func downloadbtnPressed(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(frameImage.bounds.size, false, 0.0)
        
        frameImage.image?.draw(in: CGRect(x: 0, y: 0, width: frameImage.bounds.width, height: frameImage.bounds.height))
        
        let adjustedFrame = userAddedImage.convert(userAddedImage.bounds, to: frameImage)
        
        userAddedImage.image?.draw(in: adjustedFrame)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let finalImage = combinedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension FramesDetailsViewController {
    func showStyleSheet() {
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
    
    func openCamera() {
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
    
    private func redirectToSettings() {
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
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentImagePicker(with: activityIndicator)
                    } else {
                        self?.redirectToSettings()
                    }
                }
            }
        case .denied, .restricted:
            redirectToSettings()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func presentImagePicker(with activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userAddedImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
