//
//  PackingListTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/31.
//

import UIKit

// MARK: - Protocols

protocol PackingListTableViewCellDelegate: AnyObject {
    func packingCell(_ cell: PackingListTableViewCell, didCommitText text: String)
    func packingCellDidToggleCheck(_ cell: PackingListTableViewCell, isChecked: Bool)
}

// MARK: - Main Type

/// 持ち物リストセル
final class PackingListTableViewCell: UITableViewCell {
    
    // MARK: - Stored Properties
    
    /// デリゲートのプロパティ
    weak var delegate: PackingListTableViewCellDelegate?
    /// チェックボックスの初期値
    private var isChecked = false //Stpred?
    
    // MARK: - IBOutlets
    
    /// 持ち物テキストフィールド
    @IBOutlet private weak var packingItemTextField: UITextField!
    /// チェックボックスボタン
    @IBOutlet private weak var checkBoxButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.cornerRadius = 0
        contentView.layer.maskedCorners = []
        contentView.layer.masksToBounds = true
        checkBoxButton.isSelected = false
    }
    
    // MARK: - IBActions
    
    /// チェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isChecked = sender.isSelected
        delegate?.packingCellDidToggleCheck(self, isChecked: isChecked)
    }
    
    // MARK: - Other Methods
    
    private func setupUI() {
        // タイトルのフォントを変更
        packingItemTextField.font = .setFontZenMaruGothic(size: 15)
        packingItemTextField.borderStyle = .none
        packingItemTextField.backgroundColor = .clear
        packingItemTextField.delegate = self
        packingItemTextField.returnKeyType = .done
        
        // セルの枠線を設定
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.clipsToBounds = true
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        
        // チェックボタンの画像をセット
        checkBoxButton.setImage(UIImage(named: "ic_check_box_out"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "ic_check_box_in"), for: .selected)

        // チェックボタンのUI設定
        checkBoxButton.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.background.backgroundColor = .clear
            button.configuration = configuration
        }
    }
    
    func setup(packingItem: String?, isFirst: Bool, isLast: Bool) {
        packingItemTextField.text = packingItem?.isEmpty == false ? packingItem : nil
        
        // デフォルトのセルのUI設定
        contentView.layer.cornerRadius = 0
        contentView.layer.maskedCorners = []
        contentView.layer.masksToBounds = true
        
        
        // 1セルしかない場合
        if isFirst && isLast {
            contentView.layer.cornerRadius = 8
            contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]
            return
        }
        // 一番最初のセルの上角を丸める
        if isFirst {
            contentView.layer.cornerRadius = 8
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return
        }
        // 一番最後のセルの下角を丸める
        if isLast {
            contentView.layer.cornerRadius = 8
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            return
        }
    }
    
    func beginEditing() {
        packingItemTextField.isUserInteractionEnabled = true
        packingItemTextField.becomeFirstResponder()
    }
    
    private func endEditingAndCommit() {
        let newText = (packingItemTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.packingCell(self, didCommitText: newText)
    }
}

// MARK: - Extentions

extension PackingListTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditingAndCommit()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
