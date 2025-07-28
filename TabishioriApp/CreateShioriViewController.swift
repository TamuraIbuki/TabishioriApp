//
//  CreateShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/06.
//

import UIKit

/// 新しいしおり作成画面
final class CreateShioriViewController: UIViewController {
    
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
    /// 作成ボタン
    @IBOutlet private weak var createButton: UIButton!
    /// ホワイトボタン
    @IBOutlet private weak var whiteColorButton: UIButton!
    /// しおり名記入欄
    @IBOutlet private weak var shioriNameTextField: UITextField!
    /// 開始日記入欄
    @IBOutlet private weak var startDateTextField: UITextField!
    /// 終了日記入欄
    @IBOutlet private weak var endDateTextField: UITextField!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTextField()
    }
    
    // MARK: - IBActions
    
    /// 作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
    }
    
    /// クローズボタンをタップ
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
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
        titleLabel.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.masksToBounds = false
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
    
    private func configureTextField() {
        // 各テキストフィールドに黒枠を設定
        let borderColor = UIColor.black.cgColor
        let borderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 8.0
        
        let textFieldLineSet: [UIView] = [
            shioriNameTextField,
            startDateTextField,
            endDateTextField,
        ]
        
        textFieldLineSet.forEach { view in
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        [shioriNameTextField, startDateTextField, endDateTextField].forEach {
            $0?.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Extensions

extension CreateShioriViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
