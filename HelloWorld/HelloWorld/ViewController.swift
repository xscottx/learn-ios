//
//  ViewController.swift
//  HelloWorld
//
//  Created by Hoang Vo on 9/25/16.
//  Copyright © 2016 Hoang Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myLabel2: UILabel! // optional ! means myLabel2, unwrapped could be nil but confident it is not nil.  if nil, then will have issues
                                          // optional ? means it could be wrapped
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myLabel3: UILabel!
    @IBOutlet weak var myTextFieldResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // myTextField.delegate = self
        
    }
    
    @IBAction func didTapTextButton(_ sender: AnyObject) {
        let name = myTextField.text!   // since text is nillable, u want to put ! for optional
        myTextFieldResult.text = "Hi \(name)!"
        myTextField.resignFirstResponder()
        myTextField.text = "Enter Name"
        //myTextFieldResult.text = myTextField.text + " - modified";
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myTextField.resignFirstResponder()
        return false
    }
    
    @IBAction func didTapButton(_ sender: AnyObject) {
        myLabel.text = "Changed with swift!"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

