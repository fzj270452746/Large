//
//  VesselRulesViewController.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

class VesselRulesViewController: UIViewController {
    
    let vesselBackgroundImageView = UIImageView()
    let vesselOverlayView = UIView()
    let vesselScrollView = UIScrollView()
    let vesselContentView = UIView()
    let vesselTitleLabel = UILabel()
    let vesselRulesTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVesselBackground()
        configureVesselUI()
        configureVesselConstraints()
        loadVesselRulesContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createVesselBackButton())
        title = "How to Play"
    }
    
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
        // Scroll View
        vesselScrollView.showsVerticalScrollIndicator = false
        view.addSubview(vesselScrollView)
        vesselScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Content View
        vesselScrollView.addSubview(vesselContentView)
        vesselContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        vesselTitleLabel.text = "Mahjong Vessel Rules"
        vesselTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        vesselTitleLabel.textColor = .white
        vesselTitleLabel.textAlignment = .center
        vesselTitleLabel.numberOfLines = 0
        vesselContentView.addSubview(vesselTitleLabel)
        vesselTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Rules Text View
        vesselRulesTextView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        vesselRulesTextView.textColor = .white
        vesselRulesTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        vesselRulesTextView.isEditable = false
        vesselRulesTextView.isScrollEnabled = false
        vesselRulesTextView.layer.cornerRadius = 15
        vesselRulesTextView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        vesselContentView.addSubview(vesselRulesTextView)
        vesselRulesTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVesselConstraints() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let sidePadding: CGFloat = isIPad ? 60 : 20
        
        NSLayoutConstraint.activate([
            vesselBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vesselScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            vesselContentView.topAnchor.constraint(equalTo: vesselScrollView.topAnchor),
            vesselContentView.leadingAnchor.constraint(equalTo: vesselScrollView.leadingAnchor),
            vesselContentView.trailingAnchor.constraint(equalTo: vesselScrollView.trailingAnchor),
            vesselContentView.bottomAnchor.constraint(equalTo: vesselScrollView.bottomAnchor),
            vesselContentView.widthAnchor.constraint(equalTo: vesselScrollView.widthAnchor),
            
            vesselTitleLabel.topAnchor.constraint(equalTo: vesselContentView.topAnchor, constant: 30),
            vesselTitleLabel.leadingAnchor.constraint(equalTo: vesselContentView.leadingAnchor, constant: sidePadding),
            vesselTitleLabel.trailingAnchor.constraint(equalTo: vesselContentView.trailingAnchor, constant: -sidePadding),
            
            vesselRulesTextView.topAnchor.constraint(equalTo: vesselTitleLabel.bottomAnchor, constant: 30),
            vesselRulesTextView.leadingAnchor.constraint(equalTo: vesselContentView.leadingAnchor, constant: sidePadding),
            vesselRulesTextView.trailingAnchor.constraint(equalTo: vesselContentView.trailingAnchor, constant: -sidePadding),
            vesselRulesTextView.bottomAnchor.constraint(equalTo: vesselContentView.bottomAnchor, constant: -30)
        ])
    }
    
    func loadVesselRulesContent() {
        let rulesText = """
        OBJECTIVE
        Clear mahjong tiles from the container before it fills up. Select the tiles with the minimum value to score points!
        
        
        HOW TO PLAY
        
        1️⃣ TILE APPEARANCE
        Mahjong tiles will continuously appear in the container, arranged in rows from top to bottom, left to right.
        
        2️⃣ ELIMINATION RULES
        • You must always select the tile(s) with the MINIMUM value
        • If multiple tiles have the same minimum value, you can tap any of them
        • Successfully eliminating a tile earns you 10 points
        
        3️⃣ SPECIAL TILE ✨
        • "Stool" is a SPECIAL tile with glowing effect
        • Tapping this tile will clear ALL tiles from the container
        • After clearing, 2 new tiles will appear
        • Bonus: Each tile cleared by the special tile earns 20 points!
        
        4️⃣ GAME OVER
        The game ends when the container is completely full (42 tiles maximum).
        
        
        TILE CATEGORIES
        
        🎋 BAMBOO (1-9)
        Character tiles with bamboo designs
        
        🀄︎ CHARACTER (1-9)
        Traditional Chinese character tiles
        
        ⚪️ DOT (1-9)
        Circular dot pattern tiles
        
        
        TIPS FOR SUCCESS
        
        ✓ Keep track of the minimum value tiles on screen
        ✓ Plan ahead - don't just tap randomly!
        ✓ Watch for the glowing "BianBian" special tile
        ✓ Use the special tile strategically when container is getting full
        ✓ Speed matters - tiles spawn every 2 seconds!
        
        
        SCORING SYSTEM
        
        • Normal tile elimination: +10 points
        • Special tile elimination: +20 points per tile
        • Game records track: Score, Time, Tiles Cleared
        
        
        Good luck and have fun! 🎉
        """
        
        vesselRulesTextView.text = rulesText
    }
    
    func createVesselBackButton() -> UIButton {
        let button = VesselReturnButton()
        button.addTarget(self, action: #selector(vesselBackButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc func vesselBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

