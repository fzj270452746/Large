//
//  VesselNavigationController.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

class VesselNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVesselNavigationAppearance()
    }
    
    func configureVesselNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = true
    }
}

// MARK: - Custom Back Button
class VesselReturnButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureVesselReturnAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVesselReturnAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "arrow.left.circle.fill", withConfiguration: config)
        setImage(image, for: .normal)
        tintColor = .white
        
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        addShadowEffect()
    }
    
    func addShadowEffect() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
        }
    }
}

