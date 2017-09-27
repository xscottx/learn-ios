//
//  ViewController.swift
//  WhatFlower
//
//  Created by Hoang Vo on 9/21/17.
//  Copyright © 2017 Hoang Vo. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
        
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("cannot convert to CIImage.")
            }
            detect(image: ciImage)
            
            
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapCamera(_ sender: UIBarButtonItem) {
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func getWikiInfo(flowerName: String) {
        let wikipediaURL = "https://en.wikipedia.org/w/api.php"
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exinfo" : "",
            "explaintext" : "json",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        
        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let flowerJson : JSON = JSON(response.result.value!)
                let pageId = flowerJson["query"]["pageids"][0].stringValue
                let description = flowerJson["query"]["pages"][pageId]["extract"].stringValue
                self.label.text = description
                let thumbnailUrl = flowerJson["query"]["pages"][pageId]["thumbnail"]["source"].stringValue
                self.image.sd_setImage(with: URL(string: thumbnailUrl))
            }
            else {
                print("was not successful")
            }
        }
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("cannot import model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image")
            }
            
            self.navigationItem.title = classification.identifier.capitalized
            self.getWikiInfo(flowerName: self.navigationItem.title!)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

}

