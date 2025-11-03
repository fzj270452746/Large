//
//  LargeDataModel.swift
//  Large
//
//  Created by Zhao on 2025/10/30.
//

import Foundation
import UIKit

// MARK: - Mahjong Tile Data Structure
struct MahjongVesselTile {
    let vesselImage: UIImage
    let vesselRankValue: Int
    let vesselCategoryType: TileVesselCategory
    let vesselSpecialAbility: Bool // largetuB 8 has special ability to clear all tiles
    
    init(imageName: String, rankValue: Int, category: TileVesselCategory, isSpecial: Bool = false) {
        self.vesselImage = UIImage(named: imageName) ?? UIImage()
        self.vesselRankValue = rankValue
        self.vesselCategoryType = category
        self.vesselSpecialAbility = isSpecial
    }
}

enum TileVesselCategory: String {
    case bamboo = "Bamboo"
    case character = "Character"
    case dot = "Dot"
}

// MARK: - Game Mode
enum VesselGameMode: String, Codable {
    case normal = "Normal Mode"
    case fast = "Fast Mode"
    
    var spawnInterval: TimeInterval {
        switch self {
        case .normal:
            return 2.0
        case .fast:
            return 1.0
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .normal:
            return "Tiles spawn every 2 seconds"
        case .fast:
            return "Tiles spawn every 1 second"
        }
    }
}

// MARK: - Game Record Structure
struct MahjongVesselRecord: Codable {
    let recordTimestamp: Date
    let recordScore: Int
    let recordDuration: Int // in seconds
    let recordTilesCleared: Int
    let recordGameMode: VesselGameMode
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter.string(from: recordTimestamp)
    }
    
    var formattedDuration: String {
        let minutes = recordDuration / 60
        let seconds = recordDuration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Mahjong Vessel Manager
class MahjongVesselManager {
    static let shared = MahjongVesselManager()
    
    // All available tiles
    let allVesselTiles: [MahjongVesselTile] = [
        // Special tile (bianbian) - clears all tiles when tapped
        MahjongVesselTile(imageName: "bianbian", rankValue: 0, category: .bamboo, isSpecial: true),
        
        // Bamboo tiles (largetuB)
        MahjongVesselTile(imageName: "largetuB 1", rankValue: 1, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 2", rankValue: 2, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 3", rankValue: 3, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 4", rankValue: 4, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 5", rankValue: 5, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 6", rankValue: 6, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 7", rankValue: 7, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 8", rankValue: 8, category: .bamboo),
        MahjongVesselTile(imageName: "largetuB 9", rankValue: 9, category: .bamboo),
        
        // Character tiles (largetuM)
        MahjongVesselTile(imageName: "largetuM 1", rankValue: 1, category: .character),
        MahjongVesselTile(imageName: "largetuM 2", rankValue: 2, category: .character),
        MahjongVesselTile(imageName: "largetuM 3", rankValue: 3, category: .character),
        MahjongVesselTile(imageName: "largetuM 4", rankValue: 4, category: .character),
        MahjongVesselTile(imageName: "largetuM 5", rankValue: 5, category: .character),
        MahjongVesselTile(imageName: "largetuM 6", rankValue: 6, category: .character),
        MahjongVesselTile(imageName: "largetuM 7", rankValue: 7, category: .character),
        MahjongVesselTile(imageName: "largetuM 8", rankValue: 8, category: .character),
        MahjongVesselTile(imageName: "largetuM 9", rankValue: 9, category: .character),
        
        // Dot tiles (largetuN)
        MahjongVesselTile(imageName: "largetuN 1", rankValue: 1, category: .dot),
        MahjongVesselTile(imageName: "largetuN 2", rankValue: 2, category: .dot),
        MahjongVesselTile(imageName: "largetuN 3", rankValue: 3, category: .dot),
        MahjongVesselTile(imageName: "largetuN 4", rankValue: 4, category: .dot),
        MahjongVesselTile(imageName: "largetuN 5", rankValue: 5, category: .dot),
        MahjongVesselTile(imageName: "largetuN 6", rankValue: 6, category: .dot),
        MahjongVesselTile(imageName: "largetuN 7", rankValue: 7, category: .dot),
        MahjongVesselTile(imageName: "largetuN 8", rankValue: 8, category: .dot),
        MahjongVesselTile(imageName: "largetuN 9", rankValue: 9, category: .dot),
    ]
    
    func fetchRandomVesselTile() -> MahjongVesselTile {
        return allVesselTiles.randomElement()!
    }
    
    // Save game record
    func preserveVesselRecord(_ record: MahjongVesselRecord) {
        var records = retrieveAllVesselRecords()
        records.append(record)
        // Keep only last 100 records
        if records.count > 100 {
            records = Array(records.suffix(100))
        }
        
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "MahjongVesselRecords")
        }
    }
    
    // Retrieve all records
    func retrieveAllVesselRecords() -> [MahjongVesselRecord] {
        guard let data = UserDefaults.standard.data(forKey: "MahjongVesselRecords"),
              let records = try? JSONDecoder().decode([MahjongVesselRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.recordTimestamp > $1.recordTimestamp }
    }
    
    // Clear all records
    func eraseAllVesselRecords() {
        UserDefaults.standard.removeObject(forKey: "MahjongVesselRecords")
    }
    
    // Delete specific record
    func eraseVesselRecord(at index: Int) {
        var records = retrieveAllVesselRecords()
        guard index < records.count else { return }
        records.remove(at: index)
        
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "MahjongVesselRecords")
        }
    }
}