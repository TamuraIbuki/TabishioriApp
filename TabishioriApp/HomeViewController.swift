//
//  HomeViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/01.
//

import UIKit

/// Home画面
final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// タイトルラベル
    @IBOutlet private weak var homeTitleLabel: UILabel!
    /// しおり一覧テーブルビュー
    @IBOutlet private weak var tableView: UITableView!
    /// 新しいしおりを追加ボタン
    @IBOutlet private weak var createButton: UIButton!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTableView()
    }
    
    // MARK: - IBActions
    
    /// 新しいしおりを作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        let nextVC = CreateShioriViewController()
        present(nextVC, animated: true)
    }
    
    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        homeTitleLabel.font = .setFontZenMaruGothic(size: 32)
        
        // シャドウ
        homeTitleLabel.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        homeTitleLabel.layer.shadowRadius = 2.0
        homeTitleLabel.layer.shadowOpacity = 1.0
        homeTitleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        homeTitleLabel.layer.masksToBounds = false
        
        // 新しいしおり作成ボタンのフォントを変更
        let title = "新しいしおりを作成"
        let font = UIFont.setFontZenMaruGothic(size: 24)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        createButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        // カスタムセルを登録
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeTableViewCellID")
    }
}

    // MARK: - Extentions
    extension HomeViewController: UITableViewDataSource {
        /// セルの数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        // セルを設定
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // カスタムセルを指定
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellID", for: indexPath)as! HomeTableViewCell
            // ここにセルに渡す処理を書く
            cell.setup(shioriName: "マレーシア旅行", shioriDate: "2025.07.24~2025.07.28")
            return cell
        }
    }
