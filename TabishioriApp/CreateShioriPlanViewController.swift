//
//  CreateShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/25.
//

import UIKit

/// 新しい予定作成画面
final class CreateShioriPlanViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// 新しい予定追加のタイトルラベル
    @IBOutlet private weak var titleLabel: UILabel!
    /// 日付ラベル
    @IBOutlet private weak var dateLabel: UILabel!
    /// 開始時間ラベル
    @IBOutlet private weak var startTimeLabel: UILabel!
    /// 終了時間ラベル
    @IBOutlet private weak var endTimeLabel: UILabel!
    /// 予定内容ラベル
    @IBOutlet private weak var planLabel: UILabel!
    /// 予約可否ラベル
    @IBOutlet private weak var reservationLabel: UILabel!
    /// 費用ラベル
    @IBOutlet private weak var costLabel: UILabel!
    /// URLラベル
    @IBOutlet private weak var urlLabel: UILabel!
    /// 画像挿入ボタン
    @IBOutlet private weak var insertImageButton: UIButton!
    /// 追加ボタン
    @IBOutlet private weak var addButton: UIButton!

    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
    }
    
    // MARK: - IBActions
    
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func insertImageButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        // 前の画面に戻る
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        titleLabel.font = .setFontZenMaruGothic(size: 24)
        titleLabel.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.masksToBounds = false
        
        // タイトル以外のラベルのフォントを設定
        let bodyfont = UIFont.setFontZenMaruGothic(size: 18)
        [dateLabel,startTimeLabel, endTimeLabel, planLabel, reservationLabel, costLabel, urlLabel].forEach {
            $0?.font = bodyfont
        }
        
        // 追加ボタンのフォントを設定
        let addButtonTitle = "追加"
        let addButtonFont = UIFont.setFontZenMaruGothic(size: 24)
        let addButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: addButtonFont,
            .foregroundColor: UIColor.white
        ]
        let addButtonAttributedTitle = NSAttributedString(string: addButtonTitle, attributes: addButtonAttributes)
        addButton.setAttributedTitle(addButtonAttributedTitle, for: .normal)
        
        // 画像挿入ボタンのフォントを設定
        let insertImageFont = UIFont.setFontZenMaruGothic(size: 18)
        let insertImageTitle = "画像を入れる"
        let insertImageAttributes: [NSAttributedString.Key: Any] = [
            .font:insertImageFont,
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let insertAttributeTitle = NSAttributedString(string: insertImageTitle, attributes: insertImageAttributes)
        insertImageButton.setAttributedTitle(insertAttributeTitle, for: .normal)
    }
}
