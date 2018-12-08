//
//  FilterViewController.swift
//  AIFactory
//
//  Created by Yaroslav Spirin on 12/8/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

import UIKit
import SVProgressHUD

class FilterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet var filterViews: [FilterView]!
    @IBOutlet weak var noFilterImageView: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func shareButtonTouchUpInside(_ sender: UIButton) {
        guard let image = previewImageView.image else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
       // performSegue(withIdentifier: "CameraSegue", sender: self)
    }
    
    // Sorry for these hardcoded button actions
    // It's needed here to speed up development
    
    @IBAction func noFilterTouchUpInside(_ sender: UIButton) {
        isProcessing = true
        previewImageView.image = originalImage
        isProcessing = false
    }
    
    @IBAction func mosaicFilterTouchUpInside(_ sender: UIButton) {
        isProcessing = true
        
        guard let image = originalImage else {
            return
        }
        
        NeuralStyleTransferService.process(input: image, modelName: "Mosaic") { (resultImage) in
            DispatchQueue.main.async {
                self.previewImageView.image = resultImage
                self.isProcessing = false
            }
        }
    }
    
    @IBAction func candyFilterTouchUpInside(_ sender: UIButton) {
        isProcessing = true
        
        guard let image = originalImage else {
            return
        }
        
        NeuralStyleTransferService.process(input: image, modelName: "Candy") { (resultImage) in
            DispatchQueue.main.async {
                self.previewImageView.image = resultImage
                self.isProcessing = false
            }
        }
    }
    
    @IBAction func screamFilterTouchUpInside(_ sender: UIButton) {
        isProcessing = true
        
        guard let image = originalImage else {
            return
        }
        
        NeuralStyleTransferService.process(input: image, modelName: "Scream") { (resultImage) in
            DispatchQueue.main.async {
                self.previewImageView.image = resultImage
                self.isProcessing = false
            }
        }
    }
    
    @IBAction func udnieFilterTouchUpInside(_ sender: UIButton) {
        isProcessing = true
        
        guard let image = originalImage else {
            return
        }
        
        NeuralStyleTransferService.process(input: image, modelName: "Udnie") { (resultImage) in
            DispatchQueue.main.async {
                self.previewImageView.image = resultImage
                self.isProcessing = false
            }
        }
    }
    
    // MARK: - Properties
    
    var originalImage: UIImage?
    var isProcessing: Bool = false {
        didSet {
            if isProcessing {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = originalImage
        noFilterImageView.image = originalImage
    }

}
