//
//  BackgroundremoerViewController.swift
//  PhotoEdit Magic
//
//  Created by Unique Consulting Firm on 31/05/2024.
//

import UIKit
import Foundation
import CoreML

class BackgroundremoerViewController: UIViewController {

    
    var selectedImage: UIImage!
    
    
    let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Background", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGreen // Set your desired background color
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 163/255, blue: 108/255, alpha: 1.0)
        navigationController?.navigationBar.backgroundColor = .systemGreen // Assuming AppColour is defined somewhere
        
        navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "Background Remove"
        
        let download = UIButton(type: .custom)
        download.setImage(UIImage(named: "download"), for: .normal)
        download.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        let downButtonItem = UIBarButtonItem(customView: download)
        
        let rotate = UIButton(type: .custom)
        rotate.setImage(UIImage(named: "rotate"), for: .normal)
        rotate.addTarget(self, action: #selector(rotateImage), for: .touchUpInside)
        let rotateButtonItem = UIBarButtonItem(customView: rotate)
        
        navigationItem.rightBarButtonItems = [downButtonItem,rotateButtonItem]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        setupBottomButton()
        imageView.image = selectedImage
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped()
    {
        self.dismiss(animated: true)
    }
    
    func setupBottomButton() {
        view.addSubview(bottomButton)

        NSLayoutConstraint.activate([
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50), // Set the margin from the bottom
            bottomButton.heightAnchor.constraint(equalToConstant: 50), // Set the height of the button
        ])
    }
    
    @objc func rotateImage()
    {
        guard var rotatedImage = imageView.image else { return }

            // Check and correct the orientation of the image
            if rotatedImage.imageOrientation != .up {
                UIGraphicsBeginImageContextWithOptions(rotatedImage.size, false, rotatedImage.scale)
                rotatedImage.draw(in: CGRect(origin: .zero, size: rotatedImage.size))
                rotatedImage = UIGraphicsGetImageFromCurrentImageContext() ?? rotatedImage
                UIGraphicsEndImageContext()
            }

            // Rotate the image
            rotatedImage = rotatedImage.rotate(radians: .pi / 2) ?? rotatedImage
            imageView.image = rotatedImage
    }
    
    
    @objc func saveButtonPressed() {
        guard let imageToSave = imageView.image else {
                
                return
            }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }

    
    @objc func bottomButtonTapped()
    {
            
        if let removedBackgroundImage = selectedImage.removeBackground(returnResult: .finalImage) {
            imageView.image = removedBackgroundImage
                   
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the save error
            print("Error saving image: \(error.localizedDescription)")
            // Display a success message or perform any other actions upon successful save
            let alert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            backButtonTapped()
        } else {
       
            let alert = UIAlertController(title: "Images!", message: "Your new image has been saved to Photo Library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.backButtonTapped()
            }))
            self.present(alert, animated: true)
           
        }
    }
}


enum RemoveBackroundResult {
    case background
    case finalImage
}

extension UIImage {

    func removeBackground(returnResult: RemoveBackroundResult) -> UIImage? {
        guard let model =  getDeepLabV3Model() else { return nil }
        let width: CGFloat = 513
        let height: CGFloat = 513
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer),
        let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
        let outputCIImage = CIImage(image: outputImage),
        let maskImage = outputCIImage.removeWhitePixels(),
        let maskBlurImage = maskImage.applyBlurEffect() else { return nil }

        switch returnResult {
        case .finalImage:
            guard let resizedCIImage = CIImage(image: resizedImage),
                  let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
            let finalImage = UIImage(ciImage: compositedImage)
                .resized(to: CGSize(width: size.width, height: size.height))
            return finalImage
        case .background:
            let finalImage = UIImage(
                ciImage: maskBlurImage,
                scale: scale,
                orientation: self.imageOrientation
            ).resized(to: CGSize(width: size.width, height: size.height))
            return finalImage
        }
    }

    private func getDeepLabV3Model() -> DeepLabV3? {
        do {
            let config = MLModelConfiguration()
            return try DeepLabV3(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

}

extension CIImage {

    func removeWhitePixels() -> CIImage? {
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }

    func composite(with mask: CIImage) -> CIImage? {
        return CIFilter(
            name: "CISourceOutCompositing",
            parameters: [
                kCIInputImageKey: self,
                kCIInputBackgroundImageKey: mask
            ]
        )?.outputImage
    }

    func applyBlurEffect() -> CIImage? {
        let context = CIContext(options: nil)
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        clampFilter.setDefaults()
        clampFilter.setValue(self, forKey: kCIInputImageKey)

        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        currentFilter.setValue(2, forKey: "inputRadius")
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: extent) else { return nil }

        return CIImage(cgImage: cgimg)
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func chromaKeyFilter() -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()

        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }

        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

        let colorCubeFilter = CIFilter(
            name: "CIColorCube",
            parameters: [
                "inputCubeDimension": size,
                "inputCubeData": data
            ]
        )
        return colorCubeFilter
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }

}



