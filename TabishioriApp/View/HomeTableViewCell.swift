//
//  HomeTableViewCell.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/10.
//

import UIKit

/// Home画面のしおりセル
final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: StrokeLabel!
    /// 日付ラベル
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(shioriName: String, shioriDate: String, backgroundColorHex: String) {
        let font = UIFont.setFontKiwiMaru(size: 24)
        
        // 日付ラベル処理
        let wrappedDate = shioriDate.replacingOccurrences(of: "~", with: "\n~")
        dateLabel.text = wrappedDate
        
        // 背景色
        let bgColor = UIColor(hex: backgroundColorHex)
        contentView.backgroundColor = bgColor
        
        // 背景が白の場合はテキストを黒色にする
        let textColor: UIColor
        if backgroundColorHex.uppercased() == "#FFFFFF" {
            textColor = .black
        } else {
            textColor = bgColor
        }
        
        // ストローク付きラベル設定
        shioriNameLabel.font = font
        shioriNameLabel.text = shioriName
        shioriNameLabel.textColor = textColor
        shioriNameLabel.strokeColor = .white
        shioriNameLabel.strokeWidth = 6.0  // 縁取りの太さを調整
        
    }
}
