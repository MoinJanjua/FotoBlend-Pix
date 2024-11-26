//
//  ViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 27/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PryntTrimmerView
import AVKit
import Photos

class VideoTrimmerViewController: AssetSelectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectAssetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton! // Save button outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimmerView: TrimmerView!

    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    var videoURL: URL? // Variable to store the URL of the selected video

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientToButton(button: playButton)
        applyGradientToButton(button: selectAssetButton)
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
    }

    @IBAction func selectAsset(_ sender: Any) {
        showVideoOptions() // Show options to select or record video
    }

    @IBAction func play(_ sender: Any) {
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }

    // Action connected to "Save Button" in storyboard
    @IBAction func saveVideo(_ sender: Any) {
        saveVideoToGallery() // Save video to gallery
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func loadAsset(_ asset: AVAsset) {
        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset, playerView: playerView)
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(VideoTrimmerViewController.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspectFill
        playerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        playerView.layer.addSublayer(layer)
    }

    private func showVideoOptions() {
        let actionSheet = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Select from Gallery", style: .default, handler: { [weak self] _ in
            self?.presentVideoPicker(sourceType: .photoLibrary)
        }))

        actionSheet.addAction(UIAlertAction(title: "Record from Camera", style: .default, handler: { [weak self] _ in
            self?.presentVideoPicker(sourceType: .camera)
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    private func presentVideoPicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type not available.")
            return
        }

        let videoPicker = UIImagePickerController()
        videoPicker.delegate = self
        videoPicker.sourceType = sourceType
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        videoPicker.allowsEditing = false

        present(videoPicker, animated: true, completion: nil)
    }

    // Save the video to the gallery
    private func saveVideoToGallery() {
        guard let videoURL = videoURL else {
            showAlert(title: "Error", message: "First you need to upload an Video want to trim")
            print("No video URL to save.")
            return
        }

        UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    // Handle the result of the save operation
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: Any) {
        if let error = error {
            print("Error saving video: \(error.localizedDescription)")
        } else {
            showAlert(title: "Done", message: "Video saved successfully!")
            print("Video saved successfully!")
        }
    }

    // Handle selected or recorded video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let url = info[.mediaURL] as? URL {
            videoURL = url // Store the selected video URL
            let asset = AVAsset(url: url)
            loadAsset(asset)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
            if (player?.isPlaying != true) {
                player?.play()
            }
        }
    }

    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector: #selector(VideoTrimmerViewController.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {
        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
}

extension VideoTrimmerViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print(duration)
    }
}
