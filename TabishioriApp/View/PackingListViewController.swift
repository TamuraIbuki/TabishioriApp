//
//  PackingListViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/29.
//

import UIKit

/// 持ち物リスト画面
final class PackingListViewController: UIViewController {

    // MARK: - IBOutlets
    
    /// タイトルラベル
    @IBOutlet private weak var titleLabel: UILabel!
    /// 説明ラベル
    @IBOutlet private weak var descriptionLabel: UILabel!
    /// 持ち物リストテーブルビュー
    @IBOutlet private weak var packingListTableView: UITableView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        configureTableView()
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
    
    private func configureTableView() {
        packingListTableView.dataSource = self
        packingListTableView.delegate = self
        // カスタムセルを登録
        let nib = UINib(nibName: "PackingListTableViewCell", bundle: nil)
        packingListTableView.register(nib, forCellReuseIdentifier: "PackingListCellID")
        packingListTableView.separatorColor = .black
        
        // テーブルビューの高さ設定
        packingListTableView.rowHeight = UITableView.automaticDimension
        packingListTableView.estimatedRowHeight = 100
    }
}


// MARK: - Extentions

extension PackingListViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /// セルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //カスタムセルを指定
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackingListCellID", for: indexPath)as! PackingListTableViewCell
        cell.setup(packingItem: "パスポート")
        
        // セルの最初と最後を確認
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.setupCorner(isFirst: isFirstCell, isLast: isLastCell)
        
        return cell
    }
}

extension PackingListViewController: UITableViewDelegate {
    /// セクションフッターを設定
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "ic_addlist"), for: .normal)
        //addButton.tintColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 25),
            addButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            addButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc private func addButtonTapped() {
    }
}
