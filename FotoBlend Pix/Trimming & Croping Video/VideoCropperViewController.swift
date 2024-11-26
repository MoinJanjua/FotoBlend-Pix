//
//  VideoThumbnailSelectorViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 06/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import UIKit
import Photos
import PryntTrimmerView
import AVFoundation

class VideoCropperViewController: AssetSelectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var uploadbutton: UIButton!
    @IBOutlet weak var videoCropView: VideoCropView!
    @IBOutlet weak var selectThumbView: ThumbSelectorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientToButton(button: rotateButton)
        applyGradientToButton(button: cropButton)
        applyGradientToButton(button: uploadbutton)

        loadLibrary()
        videoCropView.setAspectRatio(CGSize(width: 3, height: 2), animated: false)
    }

    @IBAction func selectVideo(_ sender: Any) {
        presentVideoSourceSelection()
    }

    private func presentVideoSourceSelection() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie"] // Only videos

        let actionSheet = UIAlertController(title: "Select Video", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Record Video", style: .default, handler: { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        } else {
            print("Camera is not available.")
        }

        actionSheet.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let asset = videoCropView.asset else {
            showAlert(title: "Error", message: "First you need to upload the video ")
            print("No video asset available to save.")
            return
        }

        let tempDirectory = NSTemporaryDirectory()
        let tempFileURL = URL(fileURLWithPath: "\(tempDirectory)tempVideo.mp4")

        exportVideo(asset: asset, outputURL: tempFileURL) { success, error in
            if success {
                UISaveVideoAtPathToSavedPhotosAlbum(tempFileURL.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                print("Failed to export video: \(String(describing: error))")
            }
        }
    }

    private func exportVideo(asset: AVAsset, outputURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true

        exportSession?.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession?.status {
                case .completed:
                    completion(true, nil)
                case .failed:
                    completion(false, exportSession?.error)
                default:
                    completion(false, nil)
                }
            }
        }
    }

    @objc func video(_ videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving video: \(error.localizedDescription)")
        } else {
            showAlert(title: "Done", message: "Video saved successfully")
            print("Video saved successfully.")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let mediaType = info[.mediaType] as? String, mediaType == "public.movie" else { return }

        if let videoURL = info[.mediaURL] as? URL {
            let asset = AVAsset(url: videoURL)
            loadAsset(asset) // Set the asset to the videoCropView
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func loadAsset(_ asset: AVAsset) {
        selectThumbView.asset = asset
        selectThumbView.delegate = self
        videoCropView.asset = asset
    }

    func prepareAssetComposition() throws {
        guard let asset = videoCropView.asset, let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
            return
        }

        let assetComposition = AVMutableComposition()
        let frame1Time = CMTime(seconds: 0.2, preferredTimescale: asset.duration.timescale)
        let trackTimeRange = CMTimeRangeMake(start: .zero, duration: frame1Time)

        guard let videoCompositionTrack = assetComposition.addMutableTrack(withMediaType: .video,
                                                                           preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return
        }

        try videoCompositionTrack.insertTimeRange(trackTimeRange, of: videoTrack, at: CMTime.zero)

        if let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
            let audioCompositionTrack = assetComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid)
            try audioCompositionTrack?.insertTimeRange(trackTimeRange, of: audioTrack, at: CMTime.zero)
        }

        //1. Create the instructions
        let mainInstructions = AVMutableVideoCompositionInstruction()
        mainInstructions.timeRange = CMTimeRangeMake(start: .zero, duration: asset.duration)

        //2 add the layer instructions
        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)

        let renderSize = CGSize(width: 16 * videoCropView.aspectRatio.width * 18,
                                height: 16 * videoCropView.aspectRatio.height * 18)
        let transform = getTransform(for: videoTrack)

        layerInstructions.setTransform(transform, at: CMTime.zero)
        layerInstructions.setOpacity(1.0, at: CMTime.zero)
        mainInstructions.layerInstructions = [layerInstructions]

        //3 Create the main composition and add the instructions

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = renderSize
        videoComposition.instructions = [mainInstructions]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)

        let url = URL(fileURLWithPath: "\(NSTemporaryDirectory())TrimmedMovie.mp4")
        try? FileManager.default.removeItem(at: url)

        let exportSession = AVAssetExportSession(asset: assetComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.videoComposition = videoComposition
        exportSession?.outputURL = url
        exportSession?.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async {
                if let url = exportSession?.outputURL, exportSession?.status == .completed {
                    UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
                } else {
                    let error = exportSession?.error
                    print("error exporting video \(String(describing: error))")
                }
            }
        })
    }

    private func getTransform(for videoTrack: AVAssetTrack) -> CGAffineTransform {
        let renderSize = CGSize(width: 16 * videoCropView.aspectRatio.width * 18,
                                height: 16 * videoCropView.aspectRatio.height * 18)
        let cropFrame = videoCropView.getImageCropFrame()
        let renderScale = renderSize.width / cropFrame.width
        let offset = CGPoint(x: -cropFrame.origin.x, y: -cropFrame.origin.y)
        let rotation = atan2(videoTrack.preferredTransform.b, videoTrack.preferredTransform.a)

        var rotationOffset = CGPoint(x: 0, y: 0)

        if videoTrack.preferredTransform.b == -1.0 {
            rotationOffset.y = videoTrack.naturalSize.width
        } else if videoTrack.preferredTransform.c == -1.0 {
            rotationOffset.x = videoTrack.naturalSize.height
        } else if videoTrack.preferredTransform.a == -1.0 {
            rotationOffset.x = videoTrack.naturalSize.width
            rotationOffset.y = videoTrack.naturalSize.height
        }

        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: renderScale, y: renderScale)
        transform = transform.translatedBy(x: offset.x + rotationOffset.x, y: offset.y + rotationOffset.y)
        transform = transform.rotated(by: rotation)

        print("track size \(videoTrack.naturalSize)")
        print("preferred Transform = \(videoTrack.preferredTransform)")
        print("rotation angle \(rotation)")
        print("rotation offset \(rotationOffset)")
        print("actual Transform = \(transform)")
        return transform
    }

    @IBAction func rotate(_ sender: Any) {
        let newRatio = videoCropView.aspectRatio.width < videoCropView.aspectRatio.height ? CGSize(width: 3, height: 2) :
                                                                                            CGSize(width: 2, height: 3)
        videoCropView.setAspectRatio(newRatio, animated: true)
    }

    @IBAction func crop(_ sender: Any) {
        if let selectedTime = selectThumbView.selectedTime, let asset = videoCropView.asset {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.requestedTimeToleranceBefore = CMTime.zero
            generator.requestedTimeToleranceAfter = CMTime.zero
            generator.appliesPreferredTrackTransform = true
            var actualTime = CMTime.zero
            let image = try? generator.copyCGImage(at: selectedTime, actualTime: &actualTime)
            if let image = image {
                let selectedImage = UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up)
                let croppedImage = selectedImage.crop(in: videoCropView.getImageCropFrame())!
                UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
            }

            try? prepareAssetComposition()
        }
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension VideoCropperViewController: ThumbSelectorViewDelegate {
    func didChangeThumbPosition(_ imageTime: CMTime) {
        videoCropView.player?.seek(to: imageTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}

extension UIImage {
    func crop(in frame: CGRect) -> UIImage? {
        if let croppedImage = self.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: croppedImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
