//
//  VesselGameViewController+Logic.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

extension VesselGameViewController {
    
    func initiateVesselGame() {
        vesselGameActive = true
        vesselCurrentScore = 0
        vesselTimerSeconds = 0
        vesselTilesCleared = 0
        
        updateVesselScoreDisplay()
        updateVesselTimerDisplay()
        
        // Spawn initial 4 tiles
        for _ in 0..<4 {
            spawnVesselTile()
        }
        
        // Start timers
        vesselGameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.incrementVesselTimer()
        }
        
        let spawnInterval = vesselGameMode.spawnInterval
        vesselSpawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.spawnVesselTile()
        }
    }
    
    func terminateVesselGame() {
        vesselGameTimer?.invalidate()
        vesselSpawnTimer?.invalidate()
        vesselGameActive = false
    }
    
    func incrementVesselTimer() {
        guard vesselGameActive else { return }
        vesselTimerSeconds += 1
        updateVesselTimerDisplay()
    }
    
    func updateVesselScoreDisplay() {
        vesselScoreLabel.text = "Score: \(vesselCurrentScore)"
        
        // Animate score change
        UIView.animate(withDuration: 0.2) {
            self.vesselScoreLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.vesselScoreLabel.transform = .identity
            }
        }
    }
    
    func updateVesselTimerDisplay() {
        let minutes = vesselTimerSeconds / 60
        let seconds = vesselTimerSeconds % 60
        vesselTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func spawnVesselTile() {
        guard vesselGameActive else { return }
        
        // Check if container is full
        if vesselTileButtons.count >= vesselMaxRows * vesselMaxColumns {
            concludeVesselGame()
            return
        }
        
        let tile = MahjongVesselManager.shared.fetchRandomVesselTile()
        let button = VesselTileButton()
        button.configureVesselTile(tile)
        button.addTarget(self, action: #selector(vesselTileButtonTapped), for: .touchUpInside)
        
        // Calculate position
        let index = vesselTileButtons.count
        button.vesselRowIndex = index / vesselMaxColumns
        button.vesselColumnIndex = index % vesselMaxColumns
        
        vesselTileButtons.append(button)
        vesselContainerView.addSubview(button)
        
        // Animate appearance
        button.alpha = 0
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        arrangeVesselTileButtons()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            button.alpha = 1.0
            button.transform = .identity
        }
    }
    
    func arrangeVesselTileButtons() {
        guard !vesselTileButtons.isEmpty else { return }
        
        let containerWidth = vesselContainerView.bounds.width - vesselTilePadding * 2
        let containerHeight = vesselContainerView.bounds.height - vesselTilePadding * 2
        
        let tileWidth = (containerWidth - vesselTilePadding * CGFloat(vesselMaxColumns - 1)) / CGFloat(vesselMaxColumns)
        let tileHeight = (containerHeight - vesselTilePadding * CGFloat(vesselMaxRows - 1)) / CGFloat(vesselMaxRows)
        
        for button in vesselTileButtons {
            let x = vesselTilePadding + CGFloat(button.vesselColumnIndex) * (tileWidth + vesselTilePadding)
            let y = vesselTilePadding + CGFloat(button.vesselRowIndex) * (tileHeight + vesselTilePadding)
            button.frame = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
        }
    }
    
    @objc func vesselTileButtonTapped(_ sender: VesselTileButton) {
        guard vesselGameActive, let tappedTile = sender.vesselTileData else { return }
        
        // Check if it's a special tile
        if tappedTile.vesselSpecialAbility {
            eliminateAllVesselTiles()
            return
        }
        
        // Find minimum rank value
        let minRank = vesselTileButtons.compactMap { $0.vesselTileData?.vesselRankValue }.min() ?? 0
        
        // Check if tapped tile is minimum
        if tappedTile.vesselRankValue == minRank {
            eliminateVesselTile(sender)
        } else {
            // Show error feedback
            showVesselErrorFeedback(on: sender)
        }
    }
    
    func eliminateVesselTile(_ button: VesselTileButton) {
        guard let index = vesselTileButtons.firstIndex(of: button) else { return }
        
        vesselTileButtons.remove(at: index)
        vesselTilesCleared += 1
        vesselCurrentScore += 10
        updateVesselScoreDisplay()
        
        // Animate removal
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 0
            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5).rotated(by: .pi / 4)
        }) { _ in
            button.removeFromSuperview()
        }
        
        // Rearrange remaining tiles
        rearrangeVesselRemainingTiles()
    }
    
    func eliminateAllVesselTiles() {
        let count = vesselTileButtons.count
        vesselTilesCleared += count
        vesselCurrentScore += count * 20 // Bonus for special tile
        updateVesselScoreDisplay()
        
        for (index, button) in vesselTileButtons.enumerated() {
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.05, options: .curveEaseOut, animations: {
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: .pi)
            }) { _ in
                button.removeFromSuperview()
            }
        }
        
        vesselTileButtons.removeAll()
        
        // Spawn 2 new tiles after clearing all tiles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            for _ in 0..<2 {
                self?.spawnVesselTile()
            }
        }
    }
    
    func rearrangeVesselRemainingTiles() {
        // Update indices
        for (index, button) in vesselTileButtons.enumerated() {
            button.vesselRowIndex = index / vesselMaxColumns
            button.vesselColumnIndex = index % vesselMaxColumns
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
            self.arrangeVesselTileButtons()
        }
    }
    
    func showVesselErrorFeedback(on button: VesselTileButton) {
        // Shake animation
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        button.layer.add(animation, forKey: "shake")
        
        // Flash red
        let originalBackgroundColor = button.backgroundColor
        UIView.animate(withDuration: 0.2, animations: {
            button.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                button.backgroundColor = originalBackgroundColor
            }
        }
    }
    
    func concludeVesselGame() {
        terminateVesselGame()
        
        // Save record
        let record = MahjongVesselRecord(
            recordTimestamp: Date(),
            recordScore: vesselCurrentScore,
            recordDuration: vesselTimerSeconds,
            recordTilesCleared: vesselTilesCleared,
            recordGameMode: vesselGameMode
        )
        MahjongVesselManager.shared.preserveVesselRecord(record)
        
        // Show game over alert
        let alert = UIAlertController(title: "Game Over", message: "Container is full!\n\nScore: \(vesselCurrentScore)\nTime: \(vesselTimerLabel.text ?? "00:00")\nTiles Cleared: \(vesselTilesCleared)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.restartVesselGame()
        })
        
        alert.addAction(UIAlertAction(title: "Main Menu", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    func restartVesselGame() {
        // Clear all tiles
        for button in vesselTileButtons {
            button.removeFromSuperview()
        }
        vesselTileButtons.removeAll()
        
        // Restart game
        initiateVesselGame()
    }
    
    @objc func vesselPauseButtonTapped() {
        let isPaused = !vesselGameActive
        vesselGameActive = !vesselGameActive
        
        if isPaused {
            vesselPauseButton.setImage(UIImage(named: "stopImage"), for: .normal)
            vesselGameTimer?.invalidate()
            vesselSpawnTimer?.invalidate()
            initiateVesselGame()
        } else {
            vesselPauseButton.setImage(UIImage(named: "stopImage"), for: .normal)
            vesselGameTimer?.invalidate()
            vesselSpawnTimer?.invalidate()
            
            // Show pause overlay
            showVesselPauseOverlay()
        }
    }
    
    func showVesselPauseOverlay() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlay.tag = 999
        view.addSubview(overlay)
        
        let label = UILabel()
        label.text = "PAUSED"
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        overlay.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let resumeButton = UIButton()
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        resumeButton.setTitleColor(.white, for: .normal)
        resumeButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 0.9)
        resumeButton.layer.cornerRadius = 15
        resumeButton.addTarget(self, action: #selector(vesselResumeButtonTapped), for: .touchUpInside)
        overlay.addSubview(resumeButton)
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: -50),
            
            resumeButton.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            resumeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            resumeButton.widthAnchor.constraint(equalToConstant: 200),
            resumeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func vesselResumeButtonTapped() {
        if let overlay = view.viewWithTag(999) {
            overlay.removeFromSuperview()
        }
        vesselGameActive = true
        vesselPauseButton.setImage(UIImage(named: "stopImage"), for: .normal)
        
        vesselGameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.incrementVesselTimer()
        }
        
        let spawnInterval = vesselGameMode.spawnInterval
        vesselSpawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.spawnVesselTile()
        }
    }
    
    @objc func vesselBackButtonTapped() {
        let alert = UIAlertController(title: "Leave Game?", message: "Your progress will be lost.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}

