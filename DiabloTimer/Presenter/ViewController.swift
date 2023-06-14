//  ViewController.swift
//  DiabloTimer
//  Created by Adam West on 05.06.23.

import UIKit

protocol ViewControllerProtocol: AnyObject {
    var progressView: UIProgressView { get set }
    var datePicker: UIDatePicker { get set }
    var dateLabel: UILabel { get set }
    var totalAmountLabel: UILabel { get set }
    var plusAmountButton: UIButton { get set }
    var minusAmountButton: UIButton { get set }
    var plusTotalButton: UIButton { get set }
    var minusTotalButton: UIButton { get set }
    var leftFireImageView: UIImageView { get set }
    var rightFireImageView: UIImageView { get set }
    func enableButtons(start: Bool, pause: Bool, reset: Bool)
}

final class ViewController: UIViewController {
    
//MARK: - Variables
    
    //MARK: - ImageView
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Diablo4 1.jpg")
        return imageView
    }()
    
    //MARK: - Buttons for timer
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
                
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
                
        button.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 1
                
        button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - ProgressBar

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.progress = 1
        progressView.progressTintColor = .red
        progressView.trackTintColor = nil
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    //MARK: - DatePicker
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.red, forKey: "textColor")
        datePicker.sizeToFit()
        
        datePicker.addTarget(self, action: #selector(datePickerChange(datePicker:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    //MARK: - Labels
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "Diablo IV"
        dateLabel.font = UIFont.systemFont(ofSize: 70)
        dateLabel.textColor = .red
        dateLabel.textAlignment = .center
        dateLabel.shadowColor = .systemRed
        dateLabel.shadowOffset = CGSize(width: 2, height: 2)
        dateLabel.numberOfLines = 1
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    lazy var totalAmountLabel: UILabel = {
        let totalAmount = UILabel()
        totalAmount.text = "Hell"
        totalAmount.font = UIFont.systemFont(ofSize: 40)
        totalAmount.textColor = .red
        totalAmount.textAlignment = .center
        totalAmount.shadowColor = .systemRed
        totalAmount.shadowOffset = CGSize(width: 2, height: 2)
        totalAmount.numberOfLines = 1
        totalAmount.adjustsFontSizeToFitWidth = true
        totalAmount.sizeToFit()
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        return totalAmount
    }()
    
    //MARK: - Buttons for amount

    lazy var plusAmountButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.alpha = 1
        
        button.tag = 4
        button.addTarget(self, action: #selector(changingAmount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var minusAmountButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.alpha = 1
        
        button.tag = 5
        button.addTarget(self, action: #selector(changingAmount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Buttons for total amount

    lazy var plusTotalButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.alpha = 1
        
        button.tag = 6
        button.addTarget(self, action: #selector(changingTotal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var minusTotalButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.alpha = 1
        
        button.tag = 7
        button.addTarget(self, action: #selector(changingTotal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Fire ImageView
    
    lazy var leftFireImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "1")
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    lazy var rightFireImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
//MARK: - Delegate TimerLogic
    
    var timerLogic: TimerLogicProtocolDelegate?
    
//MARK: - Status bar style
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            .darkContent
    }
    
//MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLogic = TimerLogic(delegate: self)
                
        addToSubview(views: [imageView, startButton, pauseButton, resetButton, progressView, datePicker, dateLabel, totalAmountLabel, plusAmountButton, minusAmountButton, plusTotalButton, minusTotalButton, leftFireImageView, rightFireImageView])
        
        addConstraints(constants: [imageViewConstraints, startButtonConstraints, pauseButtonConstraints, resetButtonConstraints, progressViewConstraints, datePickerConstraints, dateLabelConstraints, totalAmountLabelConstraints, plusAmountButtonConstraints, minusAmountButtonConstraints, plusTotalButtonConstraints, minusTotalButtonConstraints, leftFireImageViewConstraints,  rightFireImageViewConstraints])
                        
        enableButtons(start: true, pause: false, reset: false)
        timerLogic?.elementIsHidden(datePicker: false, totalAmountLabel: true, plusAmountButton: true, minusAmountButton: true, plusTotalButton: true, minusTotalButton: true, leftFireImageView: true, rightFireImageView: true)
        leftFireImageView.isHidden = true
        rightFireImageView.isHidden = true
    }
    
//MARK: - Animate ImageView
    
    func animateImageView(imageView: UIImageView, start: Bool) {
        var images = [UIImage]()
        for n in 1...26 {
            images.append(UIImage(named: "\(n)")!)
            }
        imageView.animationImages = images
        imageView.animationDuration = 0.9
        if start {
            imageView.startAnimating() } else { imageView.stopAnimating()
                imageView.image = UIImage(named: "1")
            }
    }
    
//MARK: - Disable Buttons
        
        func enableButtons(start: Bool, pause: Bool, reset: Bool) {
            startButton.isEnabled = start
            pauseButton.isEnabled = pause
            resetButton.isEnabled = reset
        }
    
//MARK: - Add to view elements
    
    private func addToSubview(views: [UIView]) {
        views.forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func addConstraints(constants: [()->Void]) {
        constants.forEach { constant in
            constant()
        }
    }
    
//MARK: - Constraints
  
    private func imageViewConstraints() {
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.frame.standardized
        imageView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func startButtonConstraints() {
        NSLayoutConstraint.activate([
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 75),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func pauseButtonConstraints() {
        NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pauseButton.widthAnchor.constraint(equalToConstant: 75),
            pauseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func resetButtonConstraints() {
        NSLayoutConstraint.activate([
            resetButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            resetButton.widthAnchor.constraint(equalToConstant: 75),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func progressViewConstraints() {
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45),
            progressView.bottomAnchor.constraint(equalTo: pauseButton.topAnchor, constant: -20)
        ])
    }
    
    private func datePickerConstraints() {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10)
        ])
    }
    
    private func dateLabelConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -30)
        ])
    }
    
    private func totalAmountLabelConstraints() {
        NSLayoutConstraint.activate([
            totalAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalAmountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        ])
    }
    private func plusAmountButtonConstraints() {
        NSLayoutConstraint.activate([
            plusAmountButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            plusAmountButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70)
        ])
    }
    
    private func minusAmountButtonConstraints() {
        NSLayoutConstraint.activate([
            minusAmountButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 120),
            minusAmountButton.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -80)
        ])
    }
    
    private func plusTotalButtonConstraints() {
        NSLayoutConstraint.activate([
            plusTotalButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            plusTotalButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70)
        ])
    }
    
    private func minusTotalButtonConstraints() {
        NSLayoutConstraint.activate([
            minusTotalButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -110),
            minusTotalButton.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -80)
        ])
    }
    
    private func leftFireImageViewConstraints() {
        NSLayoutConstraint.activate([
            leftFireImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            leftFireImageView.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 15),
            leftFireImageView.widthAnchor.constraint(equalToConstant: 150),
            leftFireImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func rightFireImageViewConstraints() {
        NSLayoutConstraint.activate([
            rightFireImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            rightFireImageView.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 10),
            rightFireImageView.widthAnchor.constraint(equalToConstant: 150),
            rightFireImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
//MARK: - Selectors
    
    @objc func startTimer(button: UIButton) {
        timerLogic?.createTimer()
        
        enableButtons(start: false, pause: true, reset: true)
        timerLogic?.elementIsHidden(datePicker: true, totalAmountLabel: true, plusAmountButton: true, minusAmountButton: true, plusTotalButton: true, minusTotalButton: true, leftFireImageView: false, rightFireImageView: false)
        
        MusicHelper.sharedHelper.audioPlayer?.stop()
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        
        animateImageView(imageView: leftFireImageView, start: true)
        animateImageView(imageView: rightFireImageView, start: true)
    }
    
    @objc func pauseTimer(button: UIButton) {
        timerLogic?.timer.invalidate()
        enableButtons(start: true, pause: false, reset: true)
        
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        leftFireImageView.stopAnimating()
        rightFireImageView.stopAnimating()
    }
    
    @objc func resetTimer(button: UIButton) {
        timerLogic?.timer.invalidate()
        dateLabel.text = "You Died"
        progressView.progress = 1
        timerLogic?.seconds = Int(datePicker.countDownDuration)
        timerLogic?.progressSeconds = 1 / Float(datePicker.countDownDuration)
        
        enableButtons(start: true, pause: true, reset: false)
        
        timerLogic?.elementIsHidden(datePicker: false, totalAmountLabel: true, plusAmountButton: true, minusAmountButton: true, plusTotalButton: true, minusTotalButton: true, leftFireImageView: true, rightFireImageView: true)
        
        MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
    }
    
    @objc func datePickerChange(datePicker: UIDatePicker) {
        if datePicker.isEqual(self.datePicker) {
            timerLogic?.seconds = Int(datePicker.countDownDuration)
            timerLogic?.progressSeconds = 1 / Float(datePicker.countDownDuration)
        }
    }
    
    @objc func changingAmount(button: UIButton) {
        if button.tag == 4 {
            timerLogic?.timeAmountSegments(UpDown: true)
            MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        }
        if button.tag == 5 {
            timerLogic?.timeAmountSegments(UpDown: false)
            MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        }
    }
    
    @objc func changingTotal(button: UIButton) {
        if button.tag == 6 {
            timerLogic?.timeTotalSegments(UpDown: true)
            MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        }
        if button.tag == 7 {
            timerLogic?.timeTotalSegments(UpDown: false)
            MusicHelper.sharedHelper.playSystemMusic(nameOfTrack: "diablo_3_rift_sound")
        }
    }
    
    
}

//MARK: - Extensions

extension ViewController: ViewControllerProtocol {}


