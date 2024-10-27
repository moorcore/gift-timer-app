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
        
        if let savedCountdownTime = UserDefaults.standard.value(forKey: "countdownTime") as? Int,
           let backgroundExitTime = UserDefaults.standard.object(forKey: "backgroundExitTime") as? Date {
            
            let elapsedTime = Date().timeIntervalSince(backgroundExitTime)
            countdownTime = max(savedCountdownTime - Int(elapsedTime), 0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        startTimer()
    }
    
    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        
        animationView.play()
    }

    func setupTimerLabel() {
        view.addSubview(timerLabel)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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
    
    @objc func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(countdownTime, forKey: "countdownTime")
        UserDefaults.standard.set(Date(), forKey: "backgroundExitTime")
    }

    @objc func applicationDidBecomeActive() {
        if let savedCountdownTime = UserDefaults.standard.value(forKey: "countdownTime") as? Int,
           let backgroundExitTime = UserDefaults.standard.object(forKey: "backgroundExitTime") as? Date {
            
            let elapsedTime = Date().timeIntervalSince(backgroundExitTime)
            
            countdownTime = max(savedCountdownTime - Int(elapsedTime), 0)
            
            if countdownTime <= 0 {
                countdownTime = 0
                updateTimerLabel()
            } else {
                startTimer()
            }
        }
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        displayLink?.invalidate()
    }
}
