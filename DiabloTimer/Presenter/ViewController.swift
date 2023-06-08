//  ViewController.swift
//  DiabloTimer
//  Created by Adam West on 05.06.23.

import UIKit

protocol ViewControllerProtocol: AnyObject {
    var progressView: UIProgressView { get set }
    var datePicker: UIDatePicker { get set }
    var dateLabel: UILabel { get set }
    var totalAmount: UILabel { get set }
    func enableButtons(start: Bool, pause: Bool, reset: Bool)
}

final class ViewController: UIViewController {
    
//MARK: - Variables
    
    private var startButton = UIButton()
    private var pauseButton = UIButton()
    private var resetButton = UIButton()
    private var imageView = UIImageView()
    
    var progressView = UIProgressView()
    var datePicker = UIDatePicker()
    var dateLabel = UILabel()
    var totalAmount = UILabel()
    
    var timerLogic: TimerLogicProtocolDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLogic = TimerLogic(delegate: self)
                
        createIMageView(imageView)
        createTotalAmountLabel(totalAmount)
        createDateLabel(dateLabel)
        createDatePicker(datePicker)
        createProgressBar(progressView)
        
        createStartButton(startButton)
        createPauseButton(pauseButton)
        createResetButton(resetButton)
        
        enableButtons(start: true, pause: false, reset: false)
    }
    
//MARK: - ImageView
    
    private func createIMageView(_ imageView: UIImageView) {
        imageView.image = UIImage(named: "Diablo4 1.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.frame.standardized
        
        view.addSubview(imageView)
    }
    
//MARK: - Labels
    
    private func createTotalAmountLabel(_ totalAmount: UILabel) {
        totalAmount.text = "Hell"
        totalAmount.font = UIFont.systemFont(ofSize: 40)
        totalAmount.textColor = .red
        totalAmount.textAlignment = .center
        totalAmount.shadowColor = .systemRed
        totalAmount.shadowOffset = CGSize(width: 2, height: 2)
        totalAmount.numberOfLines = 1
        
        totalAmount.adjustsFontSizeToFitWidth = true
        totalAmount.sizeToFit()
        totalAmount.frame = CGRect(x: 70, y: 150, width: 270, height: 150)
        
        view.addSubview(totalAmount)
    }
    
    private func createDateLabel(_ dateLabel: UILabel) {
        dateLabel.text = "Diablo IV"
        dateLabel.font = UIFont.systemFont(ofSize: 80)
        dateLabel.textColor = .red
        dateLabel.textAlignment = .center
        dateLabel.shadowColor = .systemRed
        dateLabel.shadowOffset = CGSize(width: 2, height: 2)
        dateLabel.numberOfLines = 0
        
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.frame = CGRect(x: 70, y: 450, width: 270, height: 150)
        
        view.addSubview(dateLabel)
    }
    
//MARK: - DatePicker
    
    private func createDatePicker(_ datePicker: UIDatePicker) {
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.red, forKey: "textColor")
        datePicker.sizeToFit()
        datePicker.frame = CGRect(x: 100, y: 600, width: 200, height: 100)
        
        view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerChange(datePicker:)), for: .valueChanged)
    }
        
//MARK: - ProgressBar
    
    private func createProgressBar(_ progressView: UIProgressView) {
        progressView.progressViewStyle = .bar
        progressView.progress = 1
        progressView.progressTintColor = .red
        progressView.trackTintColor = nil
        
        progressView.frame = CGRect(x: 50, y: 700, width: 300, height: 50)
        view.addSubview(progressView)
    }
    
//MARK: - Buttons
    
    private func createStartButton(_ button: UIButton) {
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
        
        button.frame = CGRect(x: 20, y: 750, width: 100, height: 50)
        button.layer.cornerRadius = 15
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    }
    
    private func createPauseButton(_ button: UIButton) {
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
        
        button.frame = CGRect(x: 140, y: 750, width: 100, height: 50)
        button.layer.cornerRadius = 15
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
    }
    
    private func createResetButton(_ button: UIButton) {
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
        
        button.frame = CGRect(x: 260, y: 750, width: 100, height: 50)
        button.layer.cornerRadius = 15
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
    }
    
//MARK: - Selectors
    
    @objc func startTimer() {
        timerLogic?.createTimer()
        datePicker.isHidden = true
        totalAmount.isHidden = true
        
        enableButtons(start: false, pause: true, reset: true)
        
        MusicHelper.sharedHelper.audioPlayer?.stop()
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
    }
    @objc func pauseTimer() {
        timerLogic?.timer.invalidate()
        enableButtons(start: true, pause: false, reset: true)
        
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
    }
    @objc func resetTimer() {
        timerLogic?.timer.invalidate()
        dateLabel.text = "You Died"
        progressView.progress = 1
        timerLogic?.seconds = Int(datePicker.countDownDuration)
        timerLogic?.progressSeconds = 1 / Float(datePicker.countDownDuration)
        
        enableButtons(start: true, pause: true, reset: false)
        
        totalAmount.isHidden = true
        datePicker.isHidden = false
        
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
    }
    
    @objc func datePickerChange(datePicker: UIDatePicker) {
        if datePicker.isEqual(self.datePicker) {
            timerLogic?.seconds = Int(datePicker.countDownDuration)
            timerLogic?.progressSeconds = 1 / Float(datePicker.countDownDuration)
        }
    }
    
//MARK: - Disable Buttons
    
    func enableButtons(start: Bool, pause: Bool, reset: Bool) {
        startButton.isEnabled = start
        pauseButton.isEnabled = pause
        resetButton.isEnabled = reset
    }
}

//MARK: - Extensions

extension ViewController: ViewControllerProtocol {}


