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

    let backgroundCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 130
        view.clipsToBounds = true
        return view
    }()
    
    let animationView = AnimationView(name: "GiftAnimation")
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .regular)
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundCircle()
        setupAnimation()
        setupTimerLabel()
        
        if let savedCountdownTime = UserDefaults.standard.value(forKey: "countdownTime") as? Int,
           let backgroundExitTime = UserDefaults.standard.object(forKey: "backgroundExitTime") as? Date {
            
            let elapsedTime = Date().timeIntervalSince(backgroundExitTime)
            countdownTime = max(savedCountdownTime - Int(elapsedTime), 0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let bannerView = BannerView()
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bannerView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        startTimer()
    }
    
    func setupBackgroundCircle() {
        view.addSubview(backgroundCircleView)
        
        backgroundCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundCircleView.widthAnchor.constraint(equalToConstant: 260),
            backgroundCircleView.heightAnchor.constraint(equalToConstant: 260),
            backgroundCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
    
    func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        backgroundCircleView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            animationView.centerXAnchor.constraint(equalTo: backgroundCircleView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: backgroundCircleView.centerYAnchor, constant: -20)
        ])
        
        animationView.play(fromFrame: 10, toFrame: animationView.animation?.endFrame ?? 0)
    }

    func setupTimerLabel() {
        backgroundCircleView.addSubview(timerLabel)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 5),
            timerLabel.centerXAnchor.constraint(equalTo: backgroundCircleView.centerXAnchor),
            timerLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundCircleView.leadingAnchor, constant: 20),
            timerLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundCircleView.trailingAnchor, constant: -20),
            timerLabel.heightAnchor.constraint(equalToConstant: 20)
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
        let hours = countdownTime / 3600
        let minutes = countdownTime / 60
        let seconds = countdownTime % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
