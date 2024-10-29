//
//  BannerView.swift
//  Timer
//
//  Created by Maxim Boykin on 29.10.24..
//

import UIKit

class BannerView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let shimmerLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let textStackView = UIStackView()
    private let imagesStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startShimmerAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        startShimmerAnimation()
    }
    
    private func setupView() {
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 12
        layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.text = "Try three days free trial"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        subtitleLabel.text = "Get all premium templates, additional stickers, no ads"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .white.withAlphaComponent(0.6)
        subtitleLabel.numberOfLines = 0
        
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        addSubview(textStackView)
        
        let image1 = UIImageView(image: UIImage(named: "flower.jpg"))
        let image2 = UIImageView(image: UIImage(named: "sea.jpg"))
        let image3 = UIImageView(image: UIImage(named: "sea.jpg"))
        let image4 = UIImageView(image: UIImage(named: "flower.jpg"))

        [image1, image2, image3, image4].forEach { view in
            view.layer.cornerRadius = 8
            view.clipsToBounds = true
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.white.cgColor
            
            view.widthAnchor.constraint(equalToConstant: 40).isActive = true
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        let leftStackView = UIStackView(arrangedSubviews: [image1, image3])
        leftStackView.axis = .vertical
        leftStackView.spacing = 4

        let rightStackView = UIStackView(arrangedSubviews: [image2, image4])
        rightStackView.axis = .vertical
        rightStackView.spacing = 4

        imagesStackView.axis = .horizontal
        imagesStackView.spacing = 4
        imagesStackView.addArrangedSubview(leftStackView)
        imagesStackView.addArrangedSubview(rightStackView)
        addSubview(imagesStackView)
        
        setupConstraints()
    }

    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: imagesStackView.leadingAnchor, constant: -16),
            
            imagesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imagesStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func startShimmerAnimation() {
        shimmerLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
        shimmerLayer.locations = [0.0, 0.5, 1.0]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmerLayer.frame = bounds
        shimmerLayer.cornerRadius = 12
        
        layer.addSublayer(shimmerLayer)
        
        let shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [-1.0, -0.5, 0.0]
        shimmerAnimation.toValue = [1.0, 1.5, 2.0]
        shimmerAnimation.duration = 2.0
        shimmerAnimation.repeatCount = .infinity
        
        shimmerLayer.add(shimmerAnimation, forKey: "shimmerAnimation")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        shimmerLayer.frame = bounds
    }
}

