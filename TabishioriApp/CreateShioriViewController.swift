//
//  CreateShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/06.
//

import UIKit

/// 新しいしおり作成画面
final class CreateShioriViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    /// 新しいしおり作成画面のタイトル
    @IBOutlet private weak var titleLabel: UILabel!
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: UILabel!
    /// 開始日ラベル
    @IBOutlet private weak var startDateLabel: UILabel!
    /// 終了日ラベル
    @IBOutlet private weak var endDateLabel: UILabel!
    /// 背景の色ラベル
    @IBOutlet private weak var backColorLabel: UILabel!
    /// 作成ボタン
    @IBOutlet private weak var createButton: UIButton!
    /// ホワイトボタン
    @IBOutlet private weak var whiteColorButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
    }

    // MARK: - IBActions
    
    /// 作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
    }
    
    /// クローズボタンをタップ
    @IBAction private func tapCloseButtonTapped(_ sender: UIButton) {
        // 前の画面に戻る
        dismiss(animated: true, completion: nil)
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
    @IBAction private func skybuleButtonTapped(_ sender: UIButton) {
    }
    
    /// 緑を選択
    @IBAction private func greenButtonTapped(_ sender: UIButton) {
    }
    
    /// 黄緑色を選択
    @IBAction private func lightgreenButtonTapped(_ sender: UIButton) {
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
        let title = "作成"
        let font = UIFont.setFontZenMaruGothic(size: 24)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        createButton.setAttributedTitle(attributedTitle, for: .normal)
        // 白の背景ボタンに黒い枠線をつける
        whiteColorButton.layer.borderWidth = 1
        whiteColorButton.layer.borderColor = UIColor.black.cgColor
    }
}

