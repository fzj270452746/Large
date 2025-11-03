//
//  VesselGameViewController.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

class VesselGameViewController: UIViewController {
    
    // MARK: - Properties
    let vesselBackgroundImageView = UIImageView()
    let vesselOverlayView = UIView()
    let vesselTopBarView = UIView()
    let vesselScoreLabel = UILabel()
    let vesselTimerLabel = UILabel()
    let vesselContainerView = UIView()
    let vesselPauseButton = UIButton()
    
    var vesselTileButtons: [VesselTileButton] = []
    var vesselCurrentScore = 0
    var vesselTimerSeconds = 0
    var vesselGameTimer: Timer?
    var vesselSpawnTimer: Timer?
    var vesselTilesCleared = 0
    var vesselGameActive = false
    var vesselGameMode: VesselGameMode = .normal
    
    let vesselMaxRows = 7
    let vesselMaxColumns = 6
    let vesselTilePadding: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVesselBackground()
        configureVesselUI()
        configureVesselConstraints()
        initiateVesselGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createVesselBackButton())
        title = vesselGameMode == .normal ? "Normal Mode" : "Fast Mode ⚡️"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        terminateVesselGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        arrangeVesselTileButtons()
    }
}

