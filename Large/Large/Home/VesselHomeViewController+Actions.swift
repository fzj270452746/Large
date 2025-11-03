//
//  VesselHomeViewController+Actions.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

extension VesselHomeViewController {
    
    @objc func vesselPlayButtonTapped() {
        let gameVC = VesselGameViewController()
        gameVC.vesselGameMode = vesselSelectedMode
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func vesselModeButtonTapped(_ sender: UIButton) {
        let normalButton = view.viewWithTag(100) as? UIButton
        let fastButton = view.viewWithTag(101) as? UIButton
        
        if sender.tag == 100 {
            // Normal mode selected
            vesselSelectedMode = .normal
            normalButton?.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 0.7)
            normalButton?.layer.borderColor = UIColor.white.cgColor
            fastButton?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            fastButton?.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        } else {
            // Fast mode selected
            vesselSelectedMode = .fast
            fastButton?.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 0.7)
            fastButton?.layer.borderColor = UIColor.white.cgColor
            normalButton?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            normalButton?.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
        
        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
    }
    
    @objc func vesselRecordsButtonTapped() {
        let recordsVC = VesselRecordsViewController()
        navigationController?.pushViewController(recordsVC, animated: true)
    }
    
    @objc func vesselRulesButtonTapped() {
        let rulesVC = VesselRulesViewController()
        navigationController?.pushViewController(rulesVC, animated: true)
    }
    
    @objc func vesselButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }
    
    @objc func vesselButtonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    func animateVesselEntrance() {
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.vesselTitleLabel.alpha = 1.0
            self.vesselTitleLabel.transform = .identity
        }
        
        // Animate mode selector
        if let modeContainer = self.view.viewWithTag(999) {
            UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                modeContainer.alpha = 1.0
                modeContainer.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.vesselStackView.alpha = 1.0
            self.vesselStackView.transform = .identity
        }
    }
}

