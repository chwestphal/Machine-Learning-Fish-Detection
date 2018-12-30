//
//  ViewControllerHomeScreen.swift
//  Bei Fisch frag Chrisch
//
//  Created by Christian Westphal on 15/07/2018.
//  Copyright © 2018 Christian Westphal. All rights reserved.
//
//  Credits to these guys for the nice framework & support
//  TOCropViewController - https://github.com/TimOliver/TOCropViewController
//  Paper Onboarding - https://github.com/Ramotion/paper-onboarding
//  Apple - https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml

import UIKit
import CoreImage
import CropViewController
import CoreML
import Vision
import ImageIO

class ViewControllerHomeScreen: UIViewController,  CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public let imageView = UIImageView()
    private let blankImage: UIImage? = UIImage.init()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var backgroundColor =  UIColor(displayP3Red: 236/255, green: 240/255, blue: 245/255, alpha: 1)
    
    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var fishName: UILabel!
    @IBOutlet weak var prediction: UILabel!
    @IBOutlet weak var fishType: UILabel!
    @IBOutlet weak var closedPeriod: UILabel!
    @IBOutlet weak var minimumSize: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = backgroundColor
        view.addSubview(imageView)
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: frozen_model().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            return request
        } catch {
            fatalError("Model couldn't be loaded.")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
            } else {
                if let topClassifications = classifications.first {
                    let descriptions = topClassifications
                    let confidence = descriptions.confidence
                    let fishName = descriptions.identifier.capitalized
                    self.printLabels(name: fishName, confidence: confidence)
                    }
                }
            }
        }
    
    func updateClassifications(for image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Error: Cannot create image")}
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Cannot perform classification.")
            }
        }
    }
    
    // here it takes the image choosen from gallery or camera
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        self.image = image
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
    }
    
    // model predicition goes in here
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        self.updateClassifications(for: image)
        layoutImageView()
        // after clicking Done, getting the image
        cropViewController.dismissAnimatedFrom(self, withCroppedImage: blankImage, toView: imageView, toFrame: CGRect.zero, setup: { self.layoutImageView() }, completion: { self.imageView.isHidden = false })
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true
        imageView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        imageView.contentMode = .scaleAspectFit
    }
    
    // updating the image
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    @IBAction func openUpCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func openUpPhotoGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            self.present(imagePicker, animated: true, completion: nil)
            imageView.image = nil
        }
    }
    
    func printLabels(name: String, confidence: VNConfidence){
        let fishType = ["Raubfisch", "Friedfisch"]
        let closedPeriod = ["keine", "ganzjährig"]
        let minimumSize = ["-", "25 cm", "30 cm", "35 cm", "40 cm", "45 cm", "50 cm", "75 cm"]
        self.fishName.text = name
        self.prediction.text = "\(Int(confidence*100)) \("%")"
        
        switch name.capitalized {
        case "Aal"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = closedPeriod[0]; self.minimumSize.text = minimumSize[6]
        case "Bachforelle" :
            self.fishType.text = fishType[0]; self.closedPeriod.text = "1.10. - 30.4."; self.minimumSize.text = minimumSize[2]
        case "Barsch"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = closedPeriod[0]; self.minimumSize.text = minimumSize[0]
        case "Hecht"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = "1.1. - 30.4."; self.minimumSize.text = minimumSize[5]
        case "Karpfen"  :
            self.fishType.text = fishType[1]; self.closedPeriod.text = closedPeriod[0]; self.minimumSize.text = minimumSize[3]
        case "Rapfen"  :
            self.fishType.text = fishType[1]; self.closedPeriod.text = "1.4. - 30.6."; self.minimumSize.text = minimumSize[4]
        case "Stoer"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = closedPeriod[1]; self.minimumSize.text = minimumSize[0]
        case "Regenbogenforelle"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = "1.10. - 30.4."; self.minimumSize.text = minimumSize[1]
        case "Wels"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = closedPeriod[0]; self.minimumSize.text = minimumSize[7]
        case "Zander"  :
            self.fishType.text = fishType[0]; self.closedPeriod.text = "1.1. - 31.5."; self.minimumSize.text = minimumSize[5]
        default :
            print("Could not predict!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

