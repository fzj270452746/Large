//
//  VesselRecordsViewController+Actions.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import UIKit

extension VesselRecordsViewController {
    
    func loadVesselRecords() {
        vesselRecordsData = MahjongVesselManager.shared.retrieveAllVesselRecords()
        vesselTableView.reloadData()
        
        vesselEmptyLabel.isHidden = !vesselRecordsData.isEmpty
        vesselClearAllButton.isHidden = vesselRecordsData.isEmpty
        
        if !vesselRecordsData.isEmpty {
            animateVesselTableView()
        }
    }
    
    func deleteVesselRecord(at index: Int) {
        MahjongVesselManager.shared.eraseVesselRecord(at: index)
        
        vesselRecordsData.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        vesselTableView.deleteRows(at: [indexPath], with: .fade)
        
        if vesselRecordsData.isEmpty {
            vesselEmptyLabel.isHidden = false
            vesselClearAllButton.isHidden = true
        }
    }
    
    @objc func vesselClearAllButtonTapped() {
        let alert = UIAlertController(title: "Clear All Records?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { [weak self] _ in
            self?.clearAllVesselRecords()
        })
        
        present(alert, animated: true)
    }
    
    func clearAllVesselRecords() {
        MahjongVesselManager.shared.eraseAllVesselRecords()
        vesselRecordsData.removeAll()
        vesselTableView.reloadData()
        
        vesselEmptyLabel.isHidden = false
        vesselClearAllButton.isHidden = true
        
        // Animate empty label appearance
        vesselEmptyLabel.alpha = 0
        vesselEmptyLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.vesselEmptyLabel.alpha = 1.0
            self.vesselEmptyLabel.transform = .identity
        }
    }
    
    @objc func vesselBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func animateVesselTableView() {
        vesselTableView.reloadData()
        
        let cells = vesselTableView.visibleCells
        let tableViewHeight = vesselTableView.bounds.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = .identity
            })
        }
    }
}

