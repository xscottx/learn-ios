//
//  ViewController.swift
//  Todo-List
//
//  Created by Hoang Vo on 10/1/16.
//  Copyright © 2016 Hoang Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var myNewTodo: UITextField!
    @IBOutlet weak var myTodoView: UITextView!
    
    var items:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItemToList(_ sender: AnyObject) {
        if !(myNewTodo.text! == "") {
            items.append(myNewTodo.text!)
            let currentDateTime = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let formattedDateTime = dateFormatter.string(from: currentDateTime)
            myTodoView.text.append("\(formattedDateTime)\t\t\(items[items.count-1])\n")
            myNewTodo.resignFirstResponder()
            myNewTodo.text = ""
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myNewTodo.resignFirstResponder()
        return false
    }
}

