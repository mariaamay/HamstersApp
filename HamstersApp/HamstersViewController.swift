//
//  ViewController.swift
//  HamstersApp
//
//  Created by Maria Mayorova on 24.01.2026.
//

import UIKit

class HamstersViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose what hamster you are today!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: hamsters[currentIndex])
        return imageView
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.configuration = .glass()
        return btn
    }()
    
    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        btn.configuration = .glass()
        return btn
    }()
    
    private var currentIndex = Int.random(in: 0..<8)
    
    private let hamsters: [String] = [
        "beachHamster",
        "eatingHamster",
        "eatingHamster2",
        "sadHamster",
        "angryHamster",
        "sleepingHamster",
        "sleepingHamster2",
        "workingHamster"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        setupImageView()
        setupTitleLabel()
        setupButtonStack()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupImageView() {
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
        
    private func setupButtonStack() {
        buttonStack.addArrangedSubview(backButton)
        buttonStack.addArrangedSubview(nextButton)
        view.addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButtonTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func handleBackButtonTap() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = hamsters.count - 1
        }
        updateImage(isNext: false)
    }
    
    @objc private func handleNextButtonTap() {
        currentIndex += 1
        if currentIndex >= hamsters.count {
            currentIndex = 0
        }
        updateImage()
    }
    
    private func updateImage(isNext: Bool = true) {
        let imageName = hamsters[currentIndex]
        guard let newImage = UIImage(named: imageName) else { return }

        let newImageView = UIImageView(image: newImage)
        newImageView.contentMode = .scaleAspectFill
        newImageView.clipsToBounds = true
        newImageView.layer.cornerRadius = imageView.layer.cornerRadius
        newImageView.frame = imageView.frame
        newImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        newImageView.alpha = 0.5
        
        view.insertSubview(newImageView, belowSubview: imageView)

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveLinear, animations: {

            let translationX: CGFloat = isNext ? -self.view.bounds.width : self.view.bounds.width
            let rotationAngle: CGFloat = isNext ? -0.3 : 0.3

            self.imageView.transform = CGAffineTransform(translationX: translationX, y: 0).rotated(by: rotationAngle)
            self.imageView.alpha = 0

            newImageView.transform = .identity
            newImageView.alpha = 1
            
        }, completion: { _ in
            self.imageView.image = newImage
            self.imageView.transform = .identity
            self.imageView.alpha = 1
            newImageView.removeFromSuperview()
        })
    }
}

