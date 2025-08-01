//
//  PackingListTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/31.
//

import UIKit

/// 持ち物リストセル
final class PackingListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    /// 持ち物ラベル
    @IBOutlet private weak var packingItemLabel: UILabel!
    
    // MARK: - View Life-Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - IBActions

    /// チェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Other Methods

    private func setupUI() {
        // タイトルのフォントを変更
        packingItemLabel.font = .setFontZenMaruGothic(size: 15)
        
        // セルの枠線を設定
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.clipsToBounds = true
    }
    
    func setup(packingItem: String?) {
        packingItemLabel.text = packingItem?.isEmpty == false ? packingItem : nil
    }
}
