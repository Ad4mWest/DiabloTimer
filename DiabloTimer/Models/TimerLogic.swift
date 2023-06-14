//  TimerLogic.swift
//  DiabloTimer
//  Created by Adam West on 05.06.23.

import UIKit

 protocol TimerLogicProtocolDelegate: AnyObject {
    var timer: Timer { get set }
    var seconds: Int { get set }
    var progressSeconds: Float { get set }
    var totalAmountFromStart: UInt { get set }
    func createTimer()
    func timeAmountSegments(UpDown: Bool)
    func timeTotalSegments(UpDown: Bool)
    func elementIsHidden(datePicker: Bool, totalAmountLabel: Bool, plusAmountButton: Bool, minusAmountButton: Bool, plusTotalButton: Bool, minusTotalButton: Bool, leftFireImageView: Bool, rightFireImageView: Bool)
}

final class TimerLogic {

//MARK: - Variables
    
    var timer = Timer()
    var seconds = 60
    var progressSeconds: Float = 1 / 60
    var totalAmountFromStart: UInt = 0
    
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
            
            elementIsHidden(datePicker: false, totalAmountLabel: false, plusAmountButton: false, minusAmountButton: false, plusTotalButton: false, minusTotalButton: false, leftFireImageView: false, rightFireImageView: false)
            
            addingTimeSegments()
            MusicHelper.sharedHelper.playBackgroundMusic(nameOfTrack: "ReaperOfSouls")
        }
    }

//MARK: - Logic for adding time segments

    private func addingTimeSegments() {
        totalAmountFromStart += 1
        userDefaultsValues?.totalTimeSegments += 1
        guard let amount = userDefaultsValues?.totalTimeSegments else { return }
        delegate?.totalAmountLabel.text! = "Today: \(totalAmountFromStart) Total: \(String(describing: amount))"
    }
    
//MARK: - Function for hidden
    
    func elementIsHidden(datePicker: Bool, totalAmountLabel: Bool, plusAmountButton: Bool, minusAmountButton: Bool, plusTotalButton: Bool, minusTotalButton: Bool, leftFireImageView: Bool, rightFireImageView: Bool) {
        delegate?.datePicker.isHidden = datePicker
        delegate?.totalAmountLabel.isHidden = totalAmountLabel
        delegate?.plusAmountButton.isHidden = plusAmountButton
        delegate?.minusAmountButton.isHidden = minusAmountButton
        delegate?.plusTotalButton.isHidden = plusTotalButton
        delegate?.minusTotalButton.isHidden = minusTotalButton
        delegate?.leftFireImageView.isHidden = leftFireImageView
        delegate?.rightFireImageView.isHidden = rightFireImageView
    }
    
//MARK: - Logic for changing time segments
    
    func timeAmountSegments(UpDown: Bool) {
        if UpDown {
            totalAmountFromStart += 1
            userDefaultsValues?.totalTimeSegments += 1
        } else {
            if totalAmountFromStart > 0 {
                totalAmountFromStart -= 1
                userDefaultsValues?.totalTimeSegments -= 1
            }
        }
        guard let text = delegate?.totalAmountLabel.text else { return }
        guard let userDefaultsValues = userDefaultsValues?.totalTimeSegments else { return }
        var textArray = text.components(separatedBy: " ")
        textArray[1] = "\(totalAmountFromStart)"
        textArray[3] = "\(userDefaultsValues)"
        let newText = textArray.joined(separator: " ")
        delegate?.totalAmountLabel.text! = newText
    }
    
    func timeTotalSegments(UpDown: Bool) {
        if UpDown {
            userDefaultsValues?.totalTimeSegments += 1
        } else {
            if userDefaultsValues?.totalTimeSegments ?? 1 > 0 {
                userDefaultsValues?.totalTimeSegments -= 1
            }
        }
        guard let text = delegate?.totalAmountLabel.text else { return }
        guard let userDefaultsValues = userDefaultsValues?.totalTimeSegments else { return }
        var textArray = text.components(separatedBy: " ")
        textArray[3] = "\(userDefaultsValues)"
        let newText = textArray.joined(separator: " ")
        delegate?.totalAmountLabel.text! = newText
    }
}

extension TimerLogic: TimerLogicProtocolDelegate {}

