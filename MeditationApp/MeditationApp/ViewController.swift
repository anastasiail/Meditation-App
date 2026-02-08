//
//  ViewController.swift
//  MeditationApp
//
//  Created by Anastasia Ilasova on 04.02.2026.
//

import UIKit

class ViewController: UIViewController {
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.text = "Breath Deep And Relax"
        label.textAlignment = .center
        label.textColor = UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1)
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1)
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Meditation", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add note", for: .normal)
        button.setTitleColor(UIColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressView = ProgressView()
    
    private var timer: Timer?
    private var timerProgress: CGFloat = 0
    private var timerDuration: Double = 300
    private var elapsedTime: Double = 0
    private var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupActions()
        updateTimerLabel()
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor(red: 125/255, green: 255/255, blue: 227/255, alpha: 1)
        
        view.addSubview(appLabel)
        view.addSubview(progressView)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        view.addSubview(notesButton)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            appLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            appLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            progressView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 40),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            
            startButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 220),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            notesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 310),
            notesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            notesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        notesButton.addTarget(self, action: #selector(notesButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        if isRunning {
            pauseTimer()
            startButton.setTitle("Continue", for: .normal)
        } else {
            if elapsedTime >= timerDuration {
                resetTimer()
            }
            startTimer()
            startButton.setTitle("Pause", for: .normal)
        }
        isRunning.toggle()
    }
    
    @objc private func resetButtonTapped() {
        resetTimer()
        if isRunning {
            timer?.invalidate()
            isRunning = false
            startButton.setTitle("Start Meditation", for: .normal)
        }
    }
    
    @objc private func notesButtonTapped() {
        let notesVC = NotesViewController()
        navigationController?.pushViewController(notesVC, animated: true)
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }
    
    private func resetTimer() {
        elapsedTime = 0
        timerProgress = 0
        updateTimerLabel()
        progressView.resetProgress()
        startButton.setTitle("Start Meditation", for: .normal)
    }
    
    @objc private func updateTimer() {
        elapsedTime += 0.1
        
        if elapsedTime >= timerDuration {
            timer?.invalidate()
            isRunning = false
            elapsedTime = timerDuration
            startButton.setTitle("Start Meditation", for: .normal)
        }
        
        timerProgress = CGFloat(elapsedTime / timerDuration)
        progressView.drawProgress(with: timerProgress)
        updateTimerLabel()
    }
    
    private func updateTimerLabel() {
        let remainingTime = max(0, timerDuration - elapsedTime)
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

class ProgressView: UIView {
    
    private let defaultCircleLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    private let bigDotLayer = CAShapeLayer()
    private let dotLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {

        defaultCircleLayer.strokeColor = CGColor(gray: 255/255, alpha: 0.7)
        defaultCircleLayer.lineWidth = 20
        defaultCircleLayer.strokeEnd = 1
        defaultCircleLayer.fillColor = nil
        defaultCircleLayer.lineCap = .round
        
        circleLayer.strokeColor = CGColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1)
        circleLayer.lineWidth = 20
        circleLayer.strokeEnd = 0
        circleLayer.fillColor = nil
        circleLayer.lineCap = .round
        
        bigDotLayer.strokeColor = CGColor(red: 13/255, green: 89/255, blue: 37/255, alpha: 1)
        bigDotLayer.lineCap = .round
        bigDotLayer.lineWidth = 20
        
        dotLayer.strokeColor = CGColor(gray: 255/255, alpha: 1)
        dotLayer.lineCap = .round
        dotLayer.lineWidth = 8
        
        layer.addSublayer(defaultCircleLayer)
        layer.addSublayer(circleLayer)
        layer.addSublayer(bigDotLayer)
        layer.addSublayer(dotLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }
    
    private func updatePaths() {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = -CGFloat.pi * 7 / 6
        let endAngle = CGFloat.pi * 1 / 6
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius - 10,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        defaultCircleLayer.path = circlePath.cgPath
        circleLayer.path = circlePath.cgPath
        
        updateDotPosition(progress: circleLayer.strokeEnd)
    }
    
    func drawProgress(with percent: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = circleLayer.strokeEnd
        animation.toValue = percent
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        circleLayer.strokeEnd = percent
        circleLayer.add(animation, forKey: "strokeEndAnimation")
        
        updateDotPosition(progress: percent)
    }
    
    private func updateDotPosition(progress: CGFloat) {
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let totalAngle = CGFloat.pi * (7/6 + 1/6)
        let currentAngle = -CGFloat.pi * 7/6 + totalAngle * progress
        
        let dotX = cos(currentAngle) * radius + center.x
        let dotY = sin(currentAngle) * radius + center.y
        let dotPoint = CGPoint(x: dotX, y: dotY)
        
        let bigDotPath = UIBezierPath()
        bigDotPath.move(to: dotPoint)
        bigDotPath.addLine(to: dotPoint)
        
        let dotPath = UIBezierPath()
        dotPath.move(to: dotPoint)
        dotPath.addLine(to: dotPoint)
        
        bigDotLayer.path = bigDotPath.cgPath
        dotLayer.path = dotPath.cgPath
        
        let dotAnimation = CABasicAnimation(keyPath: "path")
        dotAnimation.duration = 0.1
        dotAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        bigDotLayer.add(dotAnimation, forKey: "dotMovement")
        dotLayer.add(dotAnimation, forKey: "dotMovement")
    }
    
    func resetProgress() {
        circleLayer.removeAllAnimations()
        bigDotLayer.removeAllAnimations()
        dotLayer.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.strokeEnd = 0
        CATransaction.commit()
        
        updateDotPosition(progress: 0)
    }
}
