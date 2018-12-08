//
//  NeuralStyleTransferService.swift
//  AIFactory
//
//  Created by Yaroslav Spirin on 12/8/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

import Foundation
import UIKit

class NeuralStyleTransferService {
    
    typealias FilteringCompletion = ((UIImage?) -> ())
    
    static func process(input: UIImage, modelName: String, completion: @escaping FilteringCompletion) {
        
        // Initialize the NST model
        switch modelName {
        case "Udnie":
            let udnie = Udnie()
            runUdnieModel(input, udnie, completion)
        case "Mosaic":
            let mosaic = Mosaic()
            runMosaicModel(input, mosaic, completion)
        case "Scream":
            let scream = Scream()
            runScreamModel(input, scream, completion)
        case "Candy":
            let candy = Candy()
            runCandyModel(input, candy, completion)
        default:
            return
        }
    }
    
    static func runUdnieModel(_ input: UIImage, _ model: Udnie, _ completion: @escaping FilteringCompletion) {
        // Next steps are pretty heavy, better process them on a background thread
        DispatchQueue.global().async {
            
            // 1 - Transform our UIImage to a PixelBuffer of appropriate size
            let width = 720 // Int(input.size.width)
            let height = 720 //Int(input.size.height)
            
            guard let cvBufferInput = input.pixelBuffer(width: width, height: height) else {
                print("UIImage to PixelBuffer failed")
                completion(nil)
                return
            }
            
            // 2 - Feed that PixelBuffer to the model
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                print("Model prediction failed")
                completion(nil)
                return
            }
            
            // 3 - Transform PixelBuffer output to UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                print("PixelBuffer to UIImage failed")
                completion(nil)
                return
            }
            
            // 4 - Resize result to the original size, then hand it back to the main thread
            let finalImage = outputImage.resize(to: input.size)
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
    
    static func runMosaicModel(_ input: UIImage, _ model: Mosaic, _ completion: @escaping FilteringCompletion) {
        // Next steps are pretty heavy, better process them on a background thread
        DispatchQueue.global().async {
            
            // 1 - Transform our UIImage to a PixelBuffer of appropriate size
            let width = 720 // Int(input.size.width)
            let height = 720 //Int(input.size.height)
            
            guard let cvBufferInput = input.pixelBuffer(width: width, height: height) else {
                print("UIImage to PixelBuffer failed")
                completion(nil)
                return
            }
            
            // 2 - Feed that PixelBuffer to the model
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                print("Model prediction failed")
                completion(nil)
                return
            }
            
            // 3 - Transform PixelBuffer output to UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                print("PixelBuffer to UIImage failed")
                completion(nil)
                return
            }
            
            // 4 - Resize result to the original size, then hand it back to the main thread
            let finalImage = outputImage.resize(to: input.size)
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
    
    static func runScreamModel(_ input: UIImage, _ model: Scream, _ completion: @escaping FilteringCompletion) {
        // Next steps are pretty heavy, better process them on a background thread
        DispatchQueue.global().async {
            
            // 1 - Transform our UIImage to a PixelBuffer of appropriate size
            let width = 720 // Int(input.size.width)
            let height = 720 //Int(input.size.height)
            
            guard let cvBufferInput = input.pixelBuffer(width: width, height: height) else {
                print("UIImage to PixelBuffer failed")
                completion(nil)
                return
            }
            
            // 2 - Feed that PixelBuffer to the model
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                print("Model prediction failed")
                completion(nil)
                return
            }
            
            // 3 - Transform PixelBuffer output to UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                print("PixelBuffer to UIImage failed")
                completion(nil)
                return
            }
            
            // 4 - Resize result to the original size, then hand it back to the main thread
            let finalImage = outputImage.resize(to: input.size)
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
    
    static func runCandyModel(_ input: UIImage, _ model: Candy, _ completion: @escaping FilteringCompletion) {
        // Next steps are pretty heavy, better process them on a background thread
        DispatchQueue.global().async {
            
            // 1 - Transform our UIImage to a PixelBuffer of appropriate size
            let width = 720 // Int(input.size.width)
            let height = 720 //Int(input.size.height)
            
            guard let cvBufferInput = input.pixelBuffer(width: width, height: height) else {
                print("UIImage to PixelBuffer failed")
                completion(nil)
                return
            }
            
            // 2 - Feed that PixelBuffer to the model
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                print("Model prediction failed")
                completion(nil)
                return
            }
            
            // 3 - Transform PixelBuffer output to UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                print("PixelBuffer to UIImage failed")
                completion(nil)
                return
            }
            
            // 4 - Resize result to the original size, then hand it back to the main thread
            let finalImage = outputImage.resize(to: input.size)
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
}
