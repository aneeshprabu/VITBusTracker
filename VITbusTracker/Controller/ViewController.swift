//
//  ViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 18/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var welcomeText: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.welcomeText.alpha = 1.0
            self.logoImageView.alpha = 1.0

            
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                self.loginBtn.alpha = 1.0
                self.registerBtn.alpha = 1.0
            
            })
        }
    }
    
    
    
    
    //MARK: - Login button tapped

    @IBAction func loginTapped(_ sender: UIButton) {
        
        //MARK: - Animation
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.welcomeText.transform = self.welcomeText.transform.translatedBy(x: 0, y: -200)
            self.welcomeText.alpha = 0
            
            self.logoImageView.transform = self.logoImageView.transform.translatedBy(x: 0, y: -200)
            self.logoImageView.alpha = 0
            
            self.loginBtn.transform = self.loginBtn.transform.translatedBy(x: 0, y: -200)
            self.loginBtn.alpha = 0
            
            self.registerBtn.transform = self.registerBtn.transform.translatedBy(x: 0, y: -200)
            self.registerBtn.alpha = 0
        }) { (_) in
            
            //MARK: - Animation for logo
            
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                
                
                self.performSegue(withIdentifier: "goToLogin", sender: self)
                
            })
        }
  
    }
}

