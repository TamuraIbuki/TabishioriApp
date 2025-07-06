//
//  HomeViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/01.
//

import UIKit

/// Home画面
final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    /// タイトルラベル
    @IBOutlet private weak var homeTitle: UILabel!
    /// しおり一覧テーブルビュー
    @IBOutlet private weak var tableView: UITableView!
    /// 新しいしおりを追加ボタン
    @IBOutlet private weak var createButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
    }
    
    // MARK: - IBActions
    
    // 新しいしおりを作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        if let homeTitle = self.homeTitle {
            homeTitle.font = .setFontZenMaruGothic(size: 32)
        } else {
            print("homeTitle is nil")
        }
        
        // 新しいしおり作成ボタンのフォントを変更
        if let createButton = self.createButton {
            let title = "新しいしおりを作成"
            let font = UIFont.setFontZenMaruGothic(size: 24)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            createButton.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            print("createButton is nil")
        }
    }
}
