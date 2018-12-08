//
//  CameraViewController.swift
//  AIFactory
//
//  Created by Yaroslav Spirin on 12/8/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func takePhotoTouchUpInside(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func photoLibraryButtonTouchUpInside(_ sender: UIButton) {
        guard let photoLibraryController = photoLibraryController else {
            return
        }
        
        present(photoLibraryController, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var currentImage: UIImage?
    var photoLibraryController: UIImagePickerController?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupPhotoLibraryController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? FilterViewController else {
            return
        }
        
        vc.originalImage = currentImage
    }
    
    // MARK: - Setup
    
    private func setupSession() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            guard let capturePhotoOutput = capturePhotoOutput,
                let captureSession = captureSession else {
                return
            }
            
            captureSession.addOutput(capturePhotoOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            previewImageView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    private func setupPhotoLibraryController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            photoLibraryController = UIImagePickerController()
            
            guard let photoLibraryController = photoLibraryController else {
                return
            }
            
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = .photoLibrary
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            currentImage = image
        }
        
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "FilterSegue", sender: self)
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        currentImage = UIImage.init(data: imageData , scale: 1.0)
        
        performSegue(withIdentifier: "FilterSegue", sender: self)
    }
}
