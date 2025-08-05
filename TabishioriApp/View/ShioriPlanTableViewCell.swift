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
    /// 編集モード初期値
    private var isEditMode: Bool = false
    
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
    @IBOutlet private weak var rightButton: UIButton!
    /// 予定イメージビュー
    @IBOutlet private weak var planImageView: UIImageView!
    /// 予定イメージビューの高さ設定
    @IBOutlet private weak var planImageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    /// チェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
    }
    
    /// URLボタンをタップ
    @IBAction private func rightButtonTapped(_ sender: UIButton) {
        if isEditMode {
            let nextVC = EditShioriPlanDetailViewController()
            if let parentVC = self.parentViewController(),
               let nav = parentVC.navigationController {
                nav.pushViewController(nextVC, animated: true)
            }
        } else {
            if let url = URL(string: "https://ios-academia.com/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    /// 予定情報の表示
    func configurePlan(with item: ScheduleItem, isEditMode: Bool) {
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
        
        self.isEditMode = isEditMode
        if isEditMode{
            // 修正ボタンを表示
            rightButton.setImage(UIImage(named: "ic_edit"), for: .normal)
        } else {
            // URLボタンを表示
            rightButton.setImage(UIImage(named: "ic_url"), for: .normal)
            // URLがあるなら画像を表示
            if item.hasURL {
                rightButton.isHidden = false
            } else {
                rightButton.isHidden = true
            }
        }
        
        // 画像がある場合表示
        if item.hasImage {
            planImageView.image = UIImage(named: "ic_sample")
            planImageView.isHidden = false
            planImageHeightConstraint.constant = 120
        } else {
            planImageView.isHidden = true
            planImageHeightConstraint.constant = 0
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

// MARK: - Extentions

    extension UIResponder {
        func parentViewController() -> UIViewController? {
            var responder: UIResponder? = self
            while let next = responder?.next {
                if let vc = next as? UIViewController {
                    return vc
                }
                responder = next
            }
            return nil
        }
    }
