//
//  ViewController.swift
//  SeeFood2
//
//  Created by Hoang Vo on 9/18/17.
//  Copyright © 2017 Hoang Vo. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let apiKey = "b69fa4b71fc1a8ad3e5b4c178fb5ecf5a5fa8d71"
    let version = "2017-09-20"
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isHidden = true
        imagePicker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        cameraButton.isEnabled = false;
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            
            let imageData = UIImageJPEGRepresentation(image, 0.01)
            
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentURL?.appendingPathComponent("tempImage.jpg")
            
            try? imageData?.write(to: fileURL, options: [])
            
            visualRecognition.classify(imageFile: fileURL, success: {
                (classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].classification)
                }
                print(self.classificationResults)
                
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                    self.shareButton.isHidden = false
                    SVProgressHUD.dismiss()
                    
                }
                if self.classificationResults.contains("hotdog") {
                    Dispatchqueue.main.async {
                        self.navigationItem.title = "Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topImageView.image = UIImage(named: "hotdog")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topImageView.image = UIImage(named: "not-hotdog")
                    }
                }
            })
        } else {
            print("there was an error picking the image")
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("My food is \(navigationItem.title)")
            vc?.add(#imageLiteral(resourceName: "hotdogBackground"))
            present(vc, animated: true, completion: nil)
        } else {
            self.navigationItem.title = "Please log in to Twitter"
        }
    }
}

