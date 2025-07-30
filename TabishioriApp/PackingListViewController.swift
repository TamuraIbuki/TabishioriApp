//
//  PackingListViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/29.
//

import UIKit

final class PackingListViewController: UIViewController {

    // MARK: - IBOutlets
    /// タイトルラベル
    @IBOutlet private weak var titleLabel: UILabel!
    /// 説明ラベル
    @IBOutlet private weak var descriptionLabel: UILabel!
    /// 持ち物リストテーブルビュー
    @IBOutlet private weak var PackingListTableView: UITableView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
    }
    
    // MARK: - Other Methods
    
    private func setupUI() {
        // タイトルラベルのフォント設定
        titleLabel.font = .setFontZenMaruGothic(size: 24)
        // シャドウ
        titleLabel.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.masksToBounds = false
        
        // 説明ラベルのフォント設定
        descriptionLabel.font = .setFontZenMaruGothic(size: 13)
        
        // テーブルビューに黒い枠線をつける
        PackingListTableView.layer.borderWidth = 1
        PackingListTableView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func configureNavigationBar() {
        // 閉じるボタン
        let closeButton = UIBarButtonItem(image: UIImage(named: "ic_close"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        closeButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = closeButton
        
    }
    
    /// 編集画面の閉じるボタンをタップ
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
