//
//  WelcomeUserLoginViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 22/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class WelcomeUserLoginViewController: UIViewController {
    
    //Setup UI
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    let userName: String = "Aneesh"

    fileprivate func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.text = "Welcome, \(userName) to VIT Bus Tracker"
        titleLabel.font = UIFont(name: "Futura", size: 34)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Never miss your bus."
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.spacing = 10
        
        //Enables auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        setupStackView()
        
        //Animations
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimations)))

    }
    
    @objc fileprivate func handleTapAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -200)
                self.titleLabel.alpha = 0
                
            })
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                
                self.bodyLabel.transform = self.bodyLabel.transform.translatedBy(x: 0, y: -200)
                self.bodyLabel.alpha = 0
                
                self.performSegue(withIdentifier: "goToBusNumber", sender: self)
                
            })
        }
    }
    

}
