//  TimerLogic.swift
//  DiabloTimer
//  Created by Adam West on 05.06.23.

import UIKit

 protocol TimerLogicProtocolDelegate: AnyObject {
    var timer: Timer { get set }
    var seconds: Int { get set }
     var progressSeconds: Float { get set }
    func createTimer()
}

class TimerLogic {

//MARK: - Variables
    
    var timer = Timer()
    var seconds = 60
    var progressSeconds: Float = 1 / 60
    var totalAmountFromStart = 0
    
    weak var delegate: ViewControllerProtocol?
    var userDefaultsValues: UserDefaultsValues?
    
    init(delegate: ViewControllerProtocol) {
        self.delegate = delegate
        userDefaultsValues = UserDefaultsValues()
    }
    
//MARK: - Creation of timer

    func createTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateProgressDatePickerDateLabel),
            userInfo: nil,
            repeats: true)
    }
    
//MARK: - Selector

    @objc func updateProgressDatePickerDateLabel() {
        if seconds > 0 {
            self.seconds -= 1
            let seconds = self.seconds % 60
            let minutes = self.seconds / 60 % 60
            let hours = self.seconds / 60 / 60 % 60
            hours > 0 ? (delegate?.dateLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)) : (delegate?.dateLabel.text = String(format:"%02i:%02i", minutes, seconds))
            delegate?.progressView.progress -= progressSeconds
        } else {
            timer.invalidate()
            delegate?.dateLabel.text = "You Died"
            delegate?.progressView.progress = 1
            seconds = Int(delegate?.datePicker.countDownDuration ?? 60)
            progressSeconds = 1 / Float(delegate?.datePicker.countDownDuration ?? 60)
            
            delegate?.enableButtons(start: true, pause: false, reset: false)
            delegate?.datePicker.isHidden = false
            delegate?.totalAmount.isHidden = false
            
            addingTimeSegments()
            MusicHelper.sharedHelper.playBackgroundMusic(nameOfTrack: "ReaperOfSouls")
        }
    }

//MARK: - Logic for adding time segments

    func addingTimeSegments() {
        totalAmountFromStart += 1
        userDefaultsValues?.totalTimeSegments += 1
        guard let amount = userDefaultsValues?.totalTimeSegments else { return }
        delegate?.totalAmount.text! = "Today: \(totalAmountFromStart) Total: \(String(describing: amount))"
    }
}

extension TimerLogic: TimerLogicProtocolDelegate {}

