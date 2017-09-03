//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    
    let sounds = [ "note1", "note2", "note3", "note4", "note5", "note6", "note7" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notePressed(_ sender: UIButton) {
        playSound2(soundNum: sender.tag)
    }

    func playSound(soundNum: Int) {
        let soundString: String = sounds[soundNum-1]
        let soundURL = Bundle.main.url(forResource: soundString, withExtension: "wav")
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL! as CFURL, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    func playSound2(soundNum: Int) {
        let soundURL = Bundle.main.url(forResource: sounds[soundNum-1], withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.play()
        
    }
    
}

