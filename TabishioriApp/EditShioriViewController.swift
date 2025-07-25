//
//  EditShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/08.
//

import UIKit

/// しおり修正画面
final class EditShioriViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// 画面タイトル
    @IBOutlet private weak var titleLabel: UILabel!
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: UILabel!
    /// 開始日ラベル
    @IBOutlet private weak var startDateLabel: UILabel!
    /// 終了日ラベル
    @IBOutlet private weak var endDateLabel: UILabel!
    /// 背景の色ラベル
    @IBOutlet private weak var backColorLabel: UILabel!
    /// 修正ボタン
    @IBOutlet private weak var updateButton: UIButton!
    /// ホワイトボタン
    @IBOutlet private weak var whiteColorButton: UIButton!
    /// 戻るボタン
    @IBOutlet private weak var leftArrowButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
    }
    
    // MARK: - IBActions
    
    /// 修正ボタンをタップ
    @IBAction private func updateButtonTapped(_ sender: UIButton) {
    }
    
    /// 左矢印ボタンをタップ
    @IBAction private func leftArrowButtonTapped(_ sender: UIButton) {
        // 前の画面に戻る
    }

    /// 赤を選択
    @IBAction private func redButtonTapped(_ sender: UIButton) {
    }
    
    /// ピンクを選択
    @IBAction private func pinkButtonTapped(_ sender: UIButton) {
    }
    
    /// 紫を選択
    @IBAction private func purpleButtonTapped(_ sender: UIButton) {
    }
    
    /// 青を選択
    @IBAction private func buleButtonTapped(_ sender: UIButton) {
    }
    
    /// 水色を選択
    @IBAction private func skyBuleButtonTapped(_ sender: UIButton) {
    }
    
    /// 緑を選択
    @IBAction private func greenButtonTapped(_ sender: UIButton) {
    }
    
    /// 黄緑色を選択
    @IBAction private func lightGreenButtonTapped(_ sender: UIButton) {
    }
    
    /// 黄色を選択
    @IBAction private func yellowButtonTapped(_ sender: UIButton) {
    }
    
    /// 橙を選択
    @IBAction private func orangeButtonTapped(_ sender: UIButton) {
    }
    
    /// 白を選択
    @IBAction private func whiteButtonTapped(_ sender: UIButton) {
    }

    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        titleLabel.font = .setFontZenMaruGothic(size: 24)
        // しおり名のフォントを変更
        shioriNameLabel.font = .setFontZenMaruGothic(size: 18)
        // 開始日のフォントを変更
        startDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 終了日のフォントを変更
        endDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 背景の色のフォントを変更
        backColorLabel.font = .setFontZenMaruGothic(size: 18)
        // 作成ボタンのフォントを変更
        let title = "修正"
        let font = UIFont.setFontZenMaruGothic(size: 24)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        updateButton.setAttributedTitle(attributedTitle, for: .normal)
        // 白の背景ボタンに黒い枠線をつける
        whiteColorButton.layer.borderWidth = 1
        whiteColorButton.layer.borderColor = UIColor.black.cgColor
    }
}
