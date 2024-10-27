//
//  ViewController.swift
//  Timer
//
//  Created by Maxim Boykin on 27.10.24..
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    var countdownTime: Int = 1514
    var endTime: Date?
    var displayLink: CADisplayLink?

    let animationView = AnimationView(name: "GiftAnimation")
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        setupTimerLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        startTimer()
    }
    
    func setupAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        view.addSubview(animationView)
        
        animationView.play()
    }

    func setupTimerLabel() {
        timerLabel.frame = CGRect(x: 0, y: animationView.frame.maxY + 20, width: self.view.frame.width, height: 50)
        view.addSubview(timerLabel)
        
        updateTimerLabel()
    }

    func startTimer() {
        endTime = Date().addingTimeInterval(TimeInterval(countdownTime))
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc func updateTimer() {
        guard let endTime = endTime else { return }
        
        let remainingTime = Int(endTime.timeIntervalSinceNow)
        
        if remainingTime > 0 {
            countdownTime = remainingTime
            updateTimerLabel()
        } else {
            displayLink?.invalidate()
            displayLink = nil
            countdownTime = 0
            updateTimerLabel()
        }
    }

    func updateTimerLabel() {
        let minutes = countdownTime / 60
        let seconds = countdownTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    @objc func applicationDidBecomeActive() {
        updateTimer()
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        displayLink?.invalidate()
    }
}
