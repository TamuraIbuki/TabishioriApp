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
    @IBOutlet private weak var creaTitleLabel: UILabel!
    /// しおり名ラベル
    @IBOutlet private weak var shioriName: UILabel!
    /// 開始日ラベル
    @IBOutlet private weak var startDate: UILabel!
    /// 終了日ラベル
    @IBOutlet private weak var endDate: UILabel!
    /// 背景の色ラベル
    @IBOutlet private weak var backColor: UILabel!
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
    @IBAction private func tapCloseButton(_ sender: UIButton) {
        // 前の画面に戻る
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        creaTitleLabel.font = .setFontZenMaruGothic(size: 24)
        // しおり名のフォントを変更
        shioriName.font = .setFontZenMaruGothic(size: 18)
        // 開始日のフォントを変更
        startDate.font = .setFontZenMaruGothic(size: 18)
        // 終了日のフォントを変更
        endDate.font = .setFontZenMaruGothic(size: 18)
        // 背景の色のフォントを変更
        backColor.font = .setFontZenMaruGothic(size: 18)
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

