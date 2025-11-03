//
//  VesselRecordsViewController+UI.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

extension VesselRecordsViewController {
    
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
        // Table View
        vesselTableView.delegate = self
        vesselTableView.dataSource = self
        vesselTableView.backgroundColor = .clear
        vesselTableView.separatorStyle = .none
        vesselTableView.register(VesselRecordCell.self, forCellReuseIdentifier: "VesselRecordCell")
        view.addSubview(vesselTableView)
        vesselTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Empty Label
        vesselEmptyLabel.text = "No game records yet.\nStart playing to see your scores!"
        vesselEmptyLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        vesselEmptyLabel.textColor = .white
        vesselEmptyLabel.textAlignment = .center
        vesselEmptyLabel.numberOfLines = 0
        vesselEmptyLabel.isHidden = true
        view.addSubview(vesselEmptyLabel)
        vesselEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Clear All Button
        vesselClearAllButton.setTitle("Clear All Records", for: .normal)
        vesselClearAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        vesselClearAllButton.setTitleColor(.white, for: .normal)
        vesselClearAllButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        vesselClearAllButton.layer.cornerRadius = 15
        vesselClearAllButton.addTarget(self, action: #selector(vesselClearAllButtonTapped), for: .touchUpInside)
        view.addSubview(vesselClearAllButton)
        vesselClearAllButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureVesselConstraints() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let sidePadding: CGFloat = isIPad ? 40 : 20
        
        NSLayoutConstraint.activate([
            vesselBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            vesselOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vesselOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vesselOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            vesselTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            vesselTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            vesselTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            vesselTableView.bottomAnchor.constraint(equalTo: vesselClearAllButton.topAnchor, constant: -20),
            
            vesselEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vesselEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vesselEmptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            vesselEmptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            vesselClearAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            vesselClearAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            vesselClearAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            vesselClearAllButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createVesselBackButton() -> UIButton {
        let button = VesselReturnButton()
        button.addTarget(self, action: #selector(vesselBackButtonTapped), for: .touchUpInside)
        return button
    }
}

// MARK: - Table View Delegate & DataSource
extension VesselRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vesselRecordsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VesselRecordCell", for: indexPath) as! VesselRecordCell
        let record = vesselRecordsData[indexPath.row]
        cell.configureVesselRecord(record, rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteVesselRecord(at: indexPath.row)
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Record Cell
class VesselRecordCell: UITableViewCell {
    
    let vesselContainerView = UIView()
    let vesselRankLabel = UILabel()
    let vesselDateLabel = UILabel()
    let vesselScoreLabel = UILabel()
    let vesselTimeLabel = UILabel()
    let vesselTilesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureVesselCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVesselCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        vesselContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        vesselContainerView.layer.cornerRadius = 15
        vesselContainerView.layer.borderWidth = 2
        vesselContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        contentView.addSubview(vesselContainerView)
        vesselContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        vesselRankLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        vesselRankLabel.textColor = UIColor.yellow
        vesselRankLabel.textAlignment = .center
        vesselContainerView.addSubview(vesselRankLabel)
        vesselRankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vesselDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        vesselDateLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        vesselContainerView.addSubview(vesselDateLabel)
        vesselDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vesselScoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        vesselScoreLabel.textColor = .white
        vesselContainerView.addSubview(vesselScoreLabel)
        vesselScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vesselTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        vesselTimeLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        vesselContainerView.addSubview(vesselTimeLabel)
        vesselTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vesselTilesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        vesselTilesLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        vesselContainerView.addSubview(vesselTilesLabel)
        vesselTilesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vesselContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            vesselContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vesselContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vesselContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            vesselRankLabel.leadingAnchor.constraint(equalTo: vesselContainerView.leadingAnchor, constant: 15),
            vesselRankLabel.centerYAnchor.constraint(equalTo: vesselContainerView.centerYAnchor),
            vesselRankLabel.widthAnchor.constraint(equalToConstant: 50),
            
            vesselDateLabel.topAnchor.constraint(equalTo: vesselContainerView.topAnchor, constant: 12),
            vesselDateLabel.leadingAnchor.constraint(equalTo: vesselRankLabel.trailingAnchor, constant: 10),
            vesselDateLabel.trailingAnchor.constraint(equalTo: vesselContainerView.trailingAnchor, constant: -15),
            
            vesselScoreLabel.topAnchor.constraint(equalTo: vesselDateLabel.bottomAnchor, constant: 8),
            vesselScoreLabel.leadingAnchor.constraint(equalTo: vesselRankLabel.trailingAnchor, constant: 10),
            
            vesselTimeLabel.bottomAnchor.constraint(equalTo: vesselContainerView.bottomAnchor, constant: -12),
            vesselTimeLabel.leadingAnchor.constraint(equalTo: vesselRankLabel.trailingAnchor, constant: 10),
            
            vesselTilesLabel.bottomAnchor.constraint(equalTo: vesselContainerView.bottomAnchor, constant: -12),
            vesselTilesLabel.leadingAnchor.constraint(equalTo: vesselTimeLabel.trailingAnchor, constant: 20)
        ])
    }
    
    func configureVesselRecord(_ record: MahjongVesselRecord, rank: Int) {
        vesselRankLabel.text = "\(rank)"
        let modeIcon = record.recordGameMode == .fast ? "⚡️ " : ""
        vesselDateLabel.text = "\(modeIcon)\(record.formattedDate)"
        vesselScoreLabel.text = "Score: \(record.recordScore)"
        vesselTimeLabel.text = "⏱ \(record.formattedDuration)"
        vesselTilesLabel.text = "🀄︎ \(record.recordTilesCleared) tiles"
        
        // Special colors for top 3
        switch rank {
        case 1:
            vesselRankLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold
        case 2:
            vesselRankLabel.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) // Silver
        case 3:
            vesselRankLabel.textColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0) // Bronze
        default:
            vesselRankLabel.textColor = .white
        }
    }
}

