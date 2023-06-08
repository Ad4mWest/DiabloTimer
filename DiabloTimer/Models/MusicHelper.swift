//  MusicHelper.swift
//  DiabloTimer
//  Created by Adam West on 06.06.23.

import Foundation
import AVFoundation

class MusicHelper {
  
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?

//MARK: - Functions for playing music
    func playBackgroundMusic(nameOfTrack: String) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: nameOfTrack, ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func playSystemMusic(nameOfTrack: String) {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: nameOfTrack, ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = 0
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}

