//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var questionNumber : Int = 0
    var score : Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextQuestion()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        var pickedAnswer : Bool = false
        if sender.tag == 1 {
            pickedAnswer = true
        }
        else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer(guessedAnswer: pickedAnswer)
        
        questionNumber += 1
        
        nextQuestion()
    }
    
    
    func updateUI() {
        questionLabel.text = allQuestions.list[questionNumber].questionText
        progressLabel.text = "\(questionNumber+1)/13"
        scoreLabel.text = "Score: \(score)"
        progressBar.frame.size.width = (view.frame.size.width) / 13 * CGFloat(questionNumber+1)
    }
    

    func nextQuestion() {
        if questionNumber > 12 {
            print("End of quiz")
            let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over?", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in
                self.startOver()
            })
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            updateUI()
        }
    }
    
    
    func checkAnswer(guessedAnswer: Bool) {
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if correctAnswer == guessedAnswer {
            score += 1
            print("You got it")
            ProgressHUD.showSuccess("Correct")
        }
        else {
            print("Wrong")
            ProgressHUD.showError("Wrong")
        }
    }
    
    
    func startOver() {
        questionNumber = 0
        score = 0
        
        updateUI()
    }
    
}
