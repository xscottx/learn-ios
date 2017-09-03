//
//  StoryBank.swift
//  Destini
//
//  Created by Hoang Vo on 9/2/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation

class StoryBank {
    
    var stories = [Story]()
    
    init() {
        // Our strings
        let story4 = Story(num: 4,
                           txt: "What? Such a cop out! Did you know traffic accidents are the second leading cause of accidental death for most adult age groups?",
                           choiceA: nil,
                           choiceB: nil,
                           storyA: nil,
                           storyB: nil
        )
        let story5 = Story(num: 5,
                           txt: "As you smash through the guardrail and careen towards the jagged rocks below you reflect on the dubious wisdom of stabbing someone while they are driving a car you are in.",
                           choiceA: nil,
                           choiceB: nil,
                           storyA: nil,
                           storyB: nil
        )
        let story6 = Story(num: 6,
                           txt: "You bond with the murderer while crooning verses of \"Can you feel the love tonight\". He drops you off at the next town. Before you go he asks you if you know any good places to dump bodies. You reply: \"Try the pier.\"",
                           choiceA: nil,
                           choiceB: nil,
                           storyA: nil,
                           storyB: nil
        )
        let story3 = Story(num: 3,
                           txt: "As you begin to drive, the stranger starts talking about his relationship with his mother. He gets angrier and angrier by the minute. He asks you to open the glovebox. Inside you find a bloody knife, two severed fingers, and a cassette tape of Elton John. He reaches for the glove box.",
                           choiceA: "I love Elton John! Hand him the cassette tape.",
                           choiceB: "It\'s him or me! You take the knife and stab him.",
                           storyA: story6,
                           storyB: story5
        )
        let story2 = Story(num: 2,
                           txt: "He nods slowly, unphased by the question.",
                           choiceA: "At least he\'s honest. I\'ll climb in.",
                           choiceB: "Wait, I know how to change a tire.",
            storyA: story3,
            storyB: story4
        )
        let story1 = Story(num: 1,
                           txt: "Your car has blown a tire on a winding road in the middle of nowhere with no cell phone reception. You decide to hitchhike. A rusty pickup truck rumbles to a stop next to you. A man with a wide brimmed hat with soulless eyes opens the passenger door for you and asks: \"Need a ride, boy?\".",
                           choiceA: "I\'ll hop in. Thanks for the help!",
                           choiceB: "Better ask him if he\'s a murderer first.",
                           storyA: story3,
                           storyB: story2
        )
        
        
        stories.append(story1)
        stories.append(story2)
        stories.append(story3)
        stories.append(story4)
        stories.append(story5)
        stories.append(story6)
        

    }
}
