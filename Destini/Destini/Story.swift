//
//  Story.swift
//  Destini
//
//  Created by Hoang Vo on 9/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation

class Story {
    let number: Int
    let text : String
    let answerA : String?
    let storyA : Story?
    let answerB : String?
    let storyB : Story?
    
    init(num: Int, txt: String, choiceA: String?, choiceB: String?, storyA: Story?, storyB: Story?) {
        number = num
        text = txt
        answerA = choiceA
        answerB = choiceB
        self.storyA = storyA
        self.storyB = storyB
    }
}
