//
//  ShioriPlanTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/21.
//

import UIKit

/// しおり予定セル
final class ShioriPlanTableViewCell: UITableViewCell {
    
    // MARK: - Structs
    
    struct ScheduleItem {
        let startTime: String?
        let endTime: String?
        let plan: String
        let isReserved: Bool
        let cost: Int?
        let hasURL: Bool
        let hasImage: Bool
    }
    
    // MARK: - IBOutlets
    
    /// 開始時間ラベル
    @IBOutlet private weak var startTimeLabel: UILabel!
    /// 終了時間ラベル
    @IBOutlet private weak var endTimeLabel: UILabel!
    /// 時間範囲ラベル
    @IBOutlet private weak var timeRangeLabel: UILabel!
    /// 予定ラベル
    @IBOutlet private weak var planLabel: UILabel!
    /// チェックボックスボタン
    @IBOutlet private weak var checkBoxButton: UIButton!
    /// 予約ラベル
    @IBOutlet private weak var reservationLabel: UILabel!
    /// 費用ラベル
    @IBOutlet private weak var costLabel: UILabel!
    /// URLボタン
    @IBOutlet private weak var urlButton: UIButton!
    /// 予定イメージビュー
    @IBOutlet private weak var planImageView: UIImageView!
    /// 予定イメージビューの高さ設定
    @IBOutlet private weak var planImageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    /// チェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
    }
    
    /// URLボタンをタップ
    @IBAction private func urlButtonTapped(_ sender: UIButton) {
    }
    
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    /// 予定情報の表示
    func configurePlan(with item: ScheduleItem) {
        startTimeLabel.text = item.startTime
        startTimeLabel.isHidden = item.startTime == nil
        
        endTimeLabel.text = item.endTime
        endTimeLabel.isHidden = item.endTime == nil
        
        timeRangeLabel.isHidden = item.endTime == nil
        
        planLabel.text = item.plan
        
        reservationLabel.isHidden = !item.isReserved
        checkBoxButton.isHidden = !item.isReserved
        
        // 費用
        if let cost = item.cost {
            costLabel.text = "¥\(cost)"
            costLabel.isHidden = false
        } else {
            costLabel.isHidden = true
        }
        
        // URLがあるなら画像を表示
        if item.hasURL {
            urlButton.isHidden = false
        } else {
            urlButton.isHidden = true
        }
        
        // 画像がある場合表示
        if item.hasImage {
            planImageView.image = UIImage(named: "ic_sample")
            planImageView.isHidden = false
            planImageHeightConstraint.constant = 120
        } else {
            planImageView.isHidden = true
            planImageHeightConstraint.constant = 0
            
            layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        // フォントを設定
        let font = UIFont.setFontKiwiMaru(size: 15)
        [startTimeLabel, endTimeLabel, timeRangeLabel, planLabel, reservationLabel, costLabel].forEach {
            $0?.font = font
        }
    }
}
