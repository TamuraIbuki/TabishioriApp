//
//  ShioriPlanTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/21.
//

import UIKit

// MARK: - Protocols

protocol ShioriPlanTableViewCellDelegate: AnyObject {
    func didTapRightButton(in cell: ShioriPlanTableViewCell)
}

// MARK: - Main Type

/// しおり予定セル
final class ShioriPlanTableViewCell: UITableViewCell {
    
    /// 日付をString型に変換
    private static let timeFormatter: DateFormatter = {
        let timeFormatt = DateFormatter()
        timeFormatt.locale = Locale(identifier: "ja_JP")
        timeFormatt.dateFormat = "HH:mm"
        return timeFormatt
    } ()
    
    // MARK: - Structs
    
    struct ScheduleItem {
        let startTime: Date
        let endTime: Date?
        let plan: String
        let isReserved: Bool
        let cost: Int?
        let hasURL: Bool
        let planImage: String?
    }
    /// 編集モード初期値
    private var isEditMode: Bool = false
    
    // MARK: - Stored Properties
    
    weak var delegate: ShioriPlanTableViewCellDelegate?
    
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
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "ic_check_box_in"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_check_box_out"), for: .normal)
        }
    }
    
    /// URLボタンをタップ
    @IBAction private func rightButtonTapped(_ sender: UIButton) {
        delegate?.didTapRightButton(in: self)
    }
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    /// 画像の型の変更
    private func convertToImage(from identifier: String) -> UIImage? {
        let trimmedIdentifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIdentifier.isEmpty else { return nil }
        
        if trimmedIdentifier.hasPrefix("data:image/"),
           let commaIndex = trimmedIdentifier.firstIndex(of: ",") {
            let base64String = String(trimmedIdentifier[trimmedIdentifier.index(after: commaIndex)...])
            if let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                return UIImage(data: data)
            }
        }
        if let data = Data(base64Encoded: trimmedIdentifier, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return UIImage(named: trimmedIdentifier)
    }
    
    /// 予定情報の表示
    func configurePlan(with item: ScheduleItem, isEditMode: Bool) {
        self.isEditMode = isEditMode
        let timeFormatt = Self.timeFormatter
        
        startTimeLabel.text = timeFormatt.string(from: item.startTime)
        
        endTimeLabel.text = item.endTime.map { timeFormatt.string(from: $0) }
        endTimeLabel.isHidden = item.endTime == nil
        
        timeRangeLabel.isHidden = item.endTime == nil
        
        planLabel.text = item.plan
        
        reservationLabel.isHidden = !item.isReserved
        checkBoxButton.isHidden = !item.isReserved
        
        // チェックボタンのUI設定
        checkBoxButton.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.background.backgroundColor = .clear
            button.configuration = configuration
        }
        
        // 費用
        if let cost = item.cost {
            costLabel.text = "¥\(cost)"
            costLabel.isHidden = false
        } else {
            costLabel.isHidden = true
        }
        
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
        if let id = item.planImage, let decodedImage = convertToImage(from: id){
            planImageView.image = decodedImage
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

