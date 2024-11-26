//
//  CollaegSetsViewController.swift
//  PixelMingle
//
//  Created by Moin Janjua on 23/08/2024.
//

import UIKit

class CollaegSetsViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var V1_img1: UIImageView!
    
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var V2_img1: UIImageView!
    @IBOutlet weak var V2_img2: UIImageView!
    
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var V3_img1: UIImageView!
    @IBOutlet weak var V3_img2: UIImageView!
    @IBOutlet weak var V3_img3: UIImageView!
    
    @IBOutlet weak var View4: UIView!
    @IBOutlet weak var V4_img1: UIImageView!
    @IBOutlet weak var V4_img2: UIImageView!
    @IBOutlet weak var V4_img3: UIImageView!
    @IBOutlet weak var V4_img4: UIImageView!
    
    @IBOutlet weak var View5: UIView!
    @IBOutlet weak var V5_img1: UIImageView!
    @IBOutlet weak var V5_img2: UIImageView!
    @IBOutlet weak var V5_img3: UIImageView!
    @IBOutlet weak var V5_img4: UIImageView!
    @IBOutlet weak var V5_img5: UIImageView!
    
    @IBOutlet weak var View6: UIView!
    @IBOutlet weak var V6_img1: UIImageView!
    @IBOutlet weak var V6_img2: UIImageView!
    @IBOutlet weak var V6_img3: UIImageView!
    @IBOutlet weak var V6_img4: UIImageView!
    @IBOutlet weak var V6_img5: UIImageView!
    @IBOutlet weak var V6_img6: UIImageView!
    
    @IBOutlet weak var View7: UIView!
    @IBOutlet weak var V7_img1: UIImageView!
    @IBOutlet weak var V7_img2: UIImageView!
    @IBOutlet weak var V7_img3: UIImageView!
    
    @IBOutlet weak var View8: UIView!
    @IBOutlet weak var V8_img1: UIImageView!
    @IBOutlet weak var V8_img2: UIImageView!
    @IBOutlet weak var V8_img3: UIImageView!
    @IBOutlet weak var V8_img4: UIImageView!
    
    @IBOutlet weak var View9: UIView!
    @IBOutlet weak var V9_img1: HeartImageView!
    
    @IBOutlet weak var View10: UIView!
    @IBOutlet weak var V10_img1: UIImageView!
    @IBOutlet weak var V10_img2: UIImageView!
    
    @IBOutlet weak var View11: UIView!
    @IBOutlet weak var V11_img1: UIImageView!
    @IBOutlet weak var V11_img2: UIImageView!
    
    @IBOutlet weak var View12: UIView!
    @IBOutlet weak var V12_img1: UIImageView!
    @IBOutlet weak var V12_img2: UIImageView!
    @IBOutlet weak var V12_img3: UIImageView!
    
    @IBOutlet weak var View13: UIView!
    @IBOutlet weak var V13_img1: UIImageView!
    @IBOutlet weak var V13_img2: UIImageView!
    @IBOutlet weak var V13_img3: UIImageView!
    
    @IBOutlet weak var View14: UIView!
    @IBOutlet weak var V14_img1: UIImageView!
    @IBOutlet weak var V14_img2: UIImageView!
    @IBOutlet weak var V14_img3: UIImageView!
    
    @IBOutlet weak var View15: UIView!
    @IBOutlet weak var V15_img1: UIImageView!
    
    var indexPath = Int()
    var activeImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath == 0
        {
            View5.isHidden = false
        }
        if indexPath == 1
        {
            View2.isHidden = false
        }
        if indexPath == 2
        {
            View15.isHidden = false
        }
        if indexPath == 3
        {
            View4.isHidden = false
        }
        if indexPath == 4
        {
            View15.isHidden = false
        }
        if indexPath == 5
        {
            View6.isHidden = false
        }
        if indexPath == 6
        {
            View11.isHidden = false
        }
        if indexPath == 7
        {
            View9.isHidden = false
        }
        if indexPath == 8
        {
            View8.isHidden = false
        }
        if indexPath == 9
        {
            View1.isHidden = false
        }
        if indexPath == 10
        {
            View13.isHidden = false
        }
        if indexPath == 11
        {
            View12.isHidden = false
        }
        if indexPath == 12
        {
            View10.isHidden = false
        }
        if indexPath == 13
        {
            View7.isHidden = false
        }
        if indexPath == 14
        {
            View3.isHidden = false
        }
        // Add tap gesture recognizers to each image view
        // View 1
        addTapGesture(to: V1_img1)
        // View 2
        addTapGesture(to: V2_img1);addTapGesture(to: V2_img2)
        // View 3
        addTapGesture(to: V3_img1);addTapGesture(to: V3_img2);addTapGesture(to: V3_img3)
        // View 4
        addTapGesture(to: V4_img1);addTapGesture(to: V4_img2);addTapGesture(to: V4_img3);addTapGesture(to: V4_img4)
        //        // dotting
        //        addDottedBorder(to: V4_img1);addDottedBorder(to: V4_img2);addDottedBorder(to: V4_img3);addDottedBorder(to: V4_img4)
        // View 5
        addTapGesture(to: V5_img1);addTapGesture(to: V5_img2);addTapGesture(to: V5_img3);addTapGesture(to: V5_img4)
        addTapGesture(to: V5_img4);addTapGesture(to: V5_img5)
        // View 6
        addTapGesture(to:V6_img1);addTapGesture(to:V6_img2);addTapGesture(to:V6_img3);addTapGesture(to:V6_img4);addTapGesture(to: V6_img5);addTapGesture(to: V6_img6)
        // View 7
        addTapGesture(to:V7_img1);addTapGesture(to:V7_img2);addTapGesture(to:V7_img3)
        // View 8
        addTapGesture(to: V8_img1);addTapGesture(to: V8_img2);addTapGesture(to: V8_img3);addTapGesture(to: V8_img4)
        // View 9
        addTapGesture(to: V9_img1)
        //        applyHeartShape(to: V9_img1)
        // View 10
        addTapGesture(to: V10_img1);addTapGesture(to: V10_img2)
        // View 11
        addTapGesture(to: V11_img1);addTapGesture(to: V11_img2)
        // View 12
        makeImageViewCircular(imageview: V12_img1);makeImageViewCircular(imageview: V12_img2);makeImageViewCircular(imageview: V12_img3)
        addTapGesture(to: V12_img1);addTapGesture(to: V12_img2);addTapGesture(to: V12_img3)
        // View 13
        addTapGesture(to: V13_img1);addTapGesture(to: V13_img2);addTapGesture(to: V13_img3)
        // View 14
        addTapGesture(to: V14_img1);addTapGesture(to: V14_img2);addTapGesture(to: V14_img3)
        applyHexagonMask(to: V14_img1);applyHexagonMask(to: V14_img2);applyHexagonMask(to: V14_img3)
        // View 15
        addTapGesture(to: V15_img1)
    }
        // Function to add a tap gesture recognizer to a UIImageView
        func addTapGesture(to imageView: UIImageView) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
        @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
            if let tappedImageView = sender.view as? UIImageView {
                activeImageView = tappedImageView
                openGallery()
            }
        }
        func openGallery() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                picker.dismiss(animated: true) {
                    // Set the selected image to the active image view
                    self.activeImageView?.image = pickedImage
                }
            }
        }
    func convertViewToImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    @IBAction func DownloadButton(_ sender: Any) {
        var viewToSave: UIView?
                if !View1.isHidden {
                    viewToSave = View1
                }  else if !View2.isHidden {
                    viewToSave = View2
                }else if !View3.isHidden {
                    viewToSave = View3
                } else if !View4.isHidden {
                    viewToSave = View4
                }else if !View5.isHidden {
                    viewToSave = View5
                }else if !View6.isHidden {
                    viewToSave = View6
                }else if !View7.isHidden {
                    viewToSave = View7
                }else if !View8.isHidden {
                    viewToSave = View8
                }else if !View9.isHidden {
                    viewToSave = View9
                }else if !View10.isHidden {
                    viewToSave = View10
                }else if !View11.isHidden {
                    viewToSave = View11
                }else if !View12.isHidden {
                    viewToSave = View12
                }else if !View13.isHidden {
                    viewToSave = View13
                }else if !View14.isHidden {
                    viewToSave = View14
                }
                if let viewToSave = viewToSave, let collageImage = convertViewToImage(view: viewToSave) {
                    UIImageWriteToSavedPhotosAlbum(collageImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    print("No view is currently visible, or failed to convert view to image.")
                }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            showAlert(title: "Done", message: "Image saved successfully!")
            print("Image saved successfully!")
        }
    }
    @IBAction func ShareButton(_ sender: Any) {
        var viewToShare: UIView?
        if !View1.isHidden {
               viewToShare = View1
           } else if !View2.isHidden {
               viewToShare = View2
           } else if !View3.isHidden {
               viewToShare = View3
           } else if !View4.isHidden {
               viewToShare = View4
           } else if !View5.isHidden {
               viewToShare = View5
           } else if !View6.isHidden {
               viewToShare = View6
           } else if !View7.isHidden {
               viewToShare = View7
           } else if !View8.isHidden {
               viewToShare = View8
           } else if !View9.isHidden {
               viewToShare = View9
           } else if !View10.isHidden {
               viewToShare = View10
           } else if !View11.isHidden {
               viewToShare = View11
           } else if !View12.isHidden {
               viewToShare = View12
           } else if !View13.isHidden {
               viewToShare = View13
           } else if !View14.isHidden {
               viewToShare = View14
           }
           if let viewToShare = viewToShare, let imageToShare = convertViewToImage(view: viewToShare) {
               shareImage(imageToShare, from: self)
           } else {
               print("No view is currently visible, or failed to convert view to image.")
           }
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension CollaegSetsViewController {
    func shareImage(_ image: UIImage, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .postToFlickr]
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
