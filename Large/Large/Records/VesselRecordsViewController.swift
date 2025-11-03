//
//  VesselRecordsViewController.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

class VesselRecordsViewController: UIViewController {
    
    let vesselBackgroundImageView = UIImageView()
    let vesselOverlayView = UIView()
    let vesselTableView = UITableView()
    let vesselEmptyLabel = UILabel()
    let vesselClearAllButton = UIButton()
    
    var vesselRecordsData: [MahjongVesselRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVesselBackground()
        configureVesselUI()
        configureVesselConstraints()
        loadVesselRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createVesselBackButton())
        title = "Game Records"
        loadVesselRecords()
    }
}

