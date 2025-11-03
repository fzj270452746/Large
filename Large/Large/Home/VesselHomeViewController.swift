

import UIKit

class VesselHomeViewController: UIViewController {
    
    let vesselBackgroundImageView = UIImageView()
    let vesselOverlayView = UIView()
    let vesselTitleLabel = UILabel()
    let vesselPlayButton = UIButton()
    let vesselRecordsButton = UIButton()
    let vesselRulesButton = UIButton()
    let vesselStackView = UIStackView()
    var vesselSelectedMode: VesselGameMode = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVesselBackground()
        configureVesselUI()
        configureVesselConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        animateVesselEntrance()
    }
}

