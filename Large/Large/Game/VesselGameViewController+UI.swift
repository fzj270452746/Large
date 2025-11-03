//
//  VesselGameViewController+UI.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

extension VesselGameViewController {
    
    func configureVesselBackground() {
        vesselBackgroundImageView.image = UIImage(named: "largeima")
        vesselBackgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(vesselBackgroundImageView)
        vesselBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        vesselOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(vesselOverlayView)
        vesselOverlayView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVesselUI() {
        // Top Bar
        vesselTopBarView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        vesselTopBarView.layer.cornerRadius = 15
        view.addSubview(vesselTopBarView)
        vesselTopBarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Score Label
        vesselScoreLabel.text = "Score: 0"
        vesselScoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        vesselScoreLabel.textColor = .white
        vesselScoreLabel.textAlignment = .left
        vesselTopBarView.addSubview(vesselScoreLabel)
        vesselScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Timer Label
        vesselTimerLabel.text = "00:00"
        vesselTimerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        vesselTimerLabel.textColor = .white
        vesselTimerLabel.textAlignment = .center
        vesselTopBarView.addSubview(vesselTimerLabel)
        vesselTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Pause Button
        vesselPauseButton.setImage(UIImage(named: "stopImage"), for: .normal)
        vesselPauseButton.imageView?.contentMode = .scaleAspectFit
        vesselPauseButton.tintColor = .white
        vesselPauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        vesselPauseButton.layer.cornerRadius = 20
        vesselPauseButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        vesselPauseButton.addTarget(self, action: #selector(vesselPauseButtonTapped), for: .touchUpInside)
        vesselTopBarView.addSubview(vesselPauseButton)
        vesselPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Container View
        vesselContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        vesselContainerView.layer.cornerRadius = 20
        vesselContainerView.layer.borderWidth = 3
        vesselContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.addSubview(vesselContainerView)
        vesselContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVesselConstraints() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let topPadding: CGFloat = isIPad ? 30 : 20
        let sidePadding: CGFloat = isIPad ? 40 : 20
        let containerTopPadding: CGFloat = isIPad ? 30 : 20
        
        NSLayoutConstraint.activate([
            vesselBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselTopBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            vesselTopBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            vesselTopBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            vesselTopBarView.heightAnchor.constraint(equalToConstant: 60),
            
            vesselScoreLabel.leadingAnchor.constraint(equalTo: vesselTopBarView.leadingAnchor, constant: 20),
            vesselScoreLabel.centerYAnchor.constraint(equalTo: vesselTopBarView.centerYAnchor),
            
            vesselTimerLabel.centerXAnchor.constraint(equalTo: vesselTopBarView.centerXAnchor),
            vesselTimerLabel.centerYAnchor.constraint(equalTo: vesselTopBarView.centerYAnchor),
            
            vesselPauseButton.trailingAnchor.constraint(equalTo: vesselTopBarView.trailingAnchor, constant: -10),
            vesselPauseButton.centerYAnchor.constraint(equalTo: vesselTopBarView.centerYAnchor),
            vesselPauseButton.widthAnchor.constraint(equalToConstant: 40),
            vesselPauseButton.heightAnchor.constraint(equalToConstant: 40),
            
            vesselContainerView.topAnchor.constraint(equalTo: vesselTopBarView.bottomAnchor, constant: containerTopPadding),
            vesselContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            vesselContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            vesselContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -topPadding)
        ])
    }
    
    func createVesselBackButton() -> UIButton {
        let button = VesselReturnButton()
        button.addTarget(self, action: #selector(vesselBackButtonTapped), for: .touchUpInside)
        return button
    }
}

// MARK: - Tile Button
class VesselTileButton: UIButton {
    var vesselTileData: MahjongVesselTile?
    var vesselRowIndex: Int = 0
    var vesselColumnIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureVesselAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVesselAppearance() {
        backgroundColor = .clear
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        clipsToBounds = true
    }
    
    func configureVesselTile(_ tile: MahjongVesselTile) {
        vesselTileData = tile
        setImage(tile.vesselImage, for: .normal)
        
        // Apply corner radius to image
        imageView?.layer.cornerRadius = 3
        imageView?.clipsToBounds = true
        
        // Special tile glow effect
        if tile.vesselSpecialAbility {
            addVesselGlowEffect()
        }
    }
    
    func addVesselGlowEffect() {
        layer.shadowColor = UIColor.yellow.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.8
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.layer.shadowOpacity = 0.3
        }
    }
}

