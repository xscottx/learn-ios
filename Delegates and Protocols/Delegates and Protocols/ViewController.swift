//
//  ViewController.swift
//  Delegates and Protocols
//
//  Created by Hoang Vo on 9/8/17.
//  Copyright © 2017 Hoang Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CanReceive {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var dataDos = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "beamMeUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beamMeUp" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.data = textField.text!
            
            destinationVC.delegate = self
        }
    }
    
    func dataReceived(data: String) {
        label.text = data
    }
}

