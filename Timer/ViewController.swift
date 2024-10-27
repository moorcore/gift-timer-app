//
//  ViewController.swift
//  Timer
//
//  Created by Maxim Boykin on 27.10.24..
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    var timer: Timer?
    var countdownTime: Int = 1514
    
    let animationView = AnimationView(name: "GiftAnimation")
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        setupTimerLabel()
        startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if countdownTime > 0 {
            countdownTime -= 1
            updateTimerLabel()
        } else {
            timer?.invalidate()
        }
    }

    func updateTimerLabel() {
        let minutes = countdownTime / 60
        let seconds = countdownTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func applicationDidBecomeActive() {
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
