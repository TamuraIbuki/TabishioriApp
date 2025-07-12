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
    
    @IBOutlet private weak var shioriNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Other Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(shioriName: String, shioridate: String) {
        shioriNameLabel.text = shioriName
        dateLabel.text = shioridate
        // 日付を二行で表示
        let wrappedDate = shioridate.replacingOccurrences(of: "~", with: "\n~")
        dateLabel.text = wrappedDate
        // 背景色を設定
        contentView.backgroundColor = UIColor(hex: "#FF9D00", alpha: 0.3)
        /// しおり名のフォントを設定
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setFontKiwiMaru(size: 24),
            .foregroundColor: UIColor(hex: "#FF9D00"),
            .strokeColor: UIColor.white,
            .strokeWidth: -8.0,
        ]
        let attributedText = NSAttributedString(string: shioriName, attributes: attributes)
        shioriNameLabel.attributedText = attributedText
    }
}
