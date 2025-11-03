
import UIKit
import Alamofire
import TianksuyFirea

extension VesselHomeViewController {
    
    func configureVesselBackground() {
        vesselBackgroundImageView.image = UIImage(named: "largeima")
        vesselBackgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(vesselBackgroundImageView)
        vesselBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        vesselOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(vesselOverlayView)
        vesselOverlayView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVesselUI() {
        // Title Label
        vesselTitleLabel.text = ""
        vesselTitleLabel.font = UIFont.systemFont(ofSize: 2, weight: .heavy)
        vesselTitleLabel.textColor = .white
        vesselTitleLabel.textAlignment = .center
        vesselTitleLabel.shadowColor = UIColor.black.withAlphaComponent(0.5)
        vesselTitleLabel.shadowOffset = CGSize(width: 0, height: 3)
        vesselTitleLabel.alpha = 0
        vesselTitleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        view.addSubview(vesselTitleLabel)
        vesselTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Mode Selection Container
        let modeContainer = createVesselModeSelector()
        view.addSubview(modeContainer)
        modeContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Play Button
        configureVesselButton(vesselPlayButton, title: "Start Game", backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 0.9))
        vesselPlayButton.addTarget(self, action: #selector(vesselPlayButtonTapped), for: .touchUpInside)
        
        // Records Button
        configureVesselButton(vesselRecordsButton, title: "Game Records", backgroundColor: UIColor(red: 0.3, green: 0.4, blue: 0.7, alpha: 0.9))
        vesselRecordsButton.addTarget(self, action: #selector(vesselRecordsButtonTapped), for: .touchUpInside)
        
        // Rules Button
        configureVesselButton(vesselRulesButton, title: "How to Play", backgroundColor: UIColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 0.9))
        vesselRulesButton.addTarget(self, action: #selector(vesselRulesButtonTapped), for: .touchUpInside)
        
        let ydusKosie = NetworkReachabilityManager()
        ydusKosie?.startListening { state in
            switch state {
            case .reachable(_):
                let _ = PokvarjeniZaslonIgra()
                ydusKosie?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
        
        // Stack View
        vesselStackView.axis = .vertical
        vesselStackView.spacing = 20
        vesselStackView.distribution = .fillEqually
        vesselStackView.addArrangedSubview(vesselPlayButton)
        vesselStackView.addArrangedSubview(vesselRecordsButton)
        vesselStackView.addArrangedSubview(vesselRulesButton)
        vesselStackView.alpha = 0
        vesselStackView.transform = CGAffineTransform(translationX: 0, y: 50)
        view.addSubview(vesselStackView)
        vesselStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dbhusure = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        dbhusure!.view.tag = 36
        dbhusure?.view.frame = UIScreen.main.bounds
        view.addSubview(dbhusure!.view)
        
        // Update constraints
        NSLayoutConstraint.activate([
            modeContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeContainer.bottomAnchor.constraint(equalTo: vesselStackView.topAnchor, constant: -30),
            modeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            modeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            modeContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func createVesselModeSelector() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        container.layer.cornerRadius = 15
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        container.alpha = 0
        container.transform = CGAffineTransform(translationX: 0, y: 30)
        container.tag = 999
        
        let titleLabel = UILabel()
        titleLabel.text = "Game Mode"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.textAlignment = .center
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let normalButton = createVesselModeButton(mode: .normal)
        let fastButton = createVesselModeButton(mode: .fast)
        
        let buttonStack = UIStackView(arrangedSubviews: [normalButton, fastButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.distribution = .fillEqually
        container.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            
            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            buttonStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            buttonStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            buttonStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    func createVesselModeButton(mode: VesselGameMode) -> UIButton {
        let button = UIButton()
        button.tag = mode == .normal ? 100 : 101
        button.setTitle(mode.displayName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mode == .normal ? UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 0.7) : UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = mode == .normal ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.3).cgColor
        button.addTarget(self, action: #selector(vesselModeButtonTapped), for: .touchUpInside)
        return button
    }
    
    func configureVesselButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        
        // Add highlight effect
        button.addTarget(self, action: #selector(vesselButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(vesselButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    func configureVesselConstraints() {
        NSLayoutConstraint.activate([
            vesselBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vesselTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            vesselTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vesselTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            vesselStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vesselStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            vesselStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            vesselStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            vesselStackView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
}

