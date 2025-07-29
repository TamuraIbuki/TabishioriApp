//
//  EditShioriPlanDetailViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/28.
//

import UIKit

/// しおり予定情報編集画面
final class EditShioriPlanDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// 予定情報の修正ラベル
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
    /// 修正ボタン
    @IBOutlet private weak var editButton: UIButton!
    /// 日付記入欄
    @IBOutlet private weak var dateTextField: UITextField!
    /// 開始時間記入欄
    @IBOutlet private weak var startTimeTextField: UITextField!
    /// 終了時間記入欄
    @IBOutlet private weak var endTimeTextField: UITextField!
    /// 予定内容記入欄
    @IBOutlet private weak var planTextView: UITextView!
    /// 費用記入欄
    @IBOutlet private weak var costTextField: UITextField!
    /// URL記入欄
    @IBOutlet private weak var urlTextField: UITextField!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTextField()
        configureTextView()
        configureBarButtonItems()
    }
    
    // MARK: - IBActions
    
    /// 要予約のチェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
    }
    
    /// 画像をを挿入するボタンをタップ
    @IBAction private func insertImageButtonTapped(_ sender: UIButton) {
    }
    /// 「編集」ボタンをタップ
    @IBAction private func editButtonTapped(_ sender: UIButton) {
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
        let addButtonTitle = "修正"
        let addButtonFont = UIFont.setFontZenMaruGothic(size: 24)
        let addButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: addButtonFont,
            .foregroundColor: UIColor.white
        ]
        let addButtonAttributedTitle = NSAttributedString(string: addButtonTitle, attributes: addButtonAttributes)
        editButton.setAttributedTitle(addButtonAttributedTitle, for: .normal)
        
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
    
    private func configureTextField() {
        // 各テキストフィールドに黒枠を設定
        let borderColor = UIColor.black.cgColor
        let borderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 8.0
        
        let textFieldLineSet: [UIView] = [
            dateTextField,
            startTimeTextField,
            endTimeTextField,
            costTextField,
            urlTextField
        ]
        
        textFieldLineSet.forEach { view in
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        [dateTextField, startTimeTextField, endTimeTextField, costTextField, urlTextField].forEach {
            $0?.delegate = self
        }
    }
    
    private func configureTextView() {
        // 各テキストフィールドに黒枠を設定
        planTextView.layer.borderColor = UIColor.black.cgColor
        planTextView.layer.borderWidth = 1.0
        planTextView.layer.cornerRadius = 8.0
        planTextView.layer.masksToBounds = true
        
        planTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureBarButtonItems() {
        // 戻るボタン
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_left_arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension EditShioriPlanDetailViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

extension EditShioriPlanDetailViewController: UITextViewDelegate {
    /// returnキーを押された時のメソッド
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            // キーボードを閉じる
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
