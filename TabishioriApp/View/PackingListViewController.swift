//
//  PackingListViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/29.
//

import UIKit

/// 持ち物リスト画面
final class PackingListViewController: UIViewController {
    
    // MARK: - Stored Properties
    /// RealmManagerのシングルトンインスタンスを取得
    private let realmManager = RealmManager.shared
    /// パッキングアイテムの配列
    private var items: [PackingItemDataModel] = []
    /// 背景色
    private var backgroundHex: String = ""
    
    // MARK: - IBOutlets
    
    /// タイトルラベル
    @IBOutlet private weak var titleLabel: UILabel!
    /// 説明ラベル
    @IBOutlet private weak var descriptionLabel: UILabel!
    /// 持ち物リストテーブルビュー
    @IBOutlet private weak var packingListTableView: UITableView!
    
    // MARK: - Initializers
    
    init(backgroundHex: String) {
        self.backgroundHex = backgroundHex
        super.init(nibName: "PackingListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        configureTableView()
        fetchItems()
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
        
        // 背景色の設定
        applyBackground(hex: backgroundHex)
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
        
        // キーボードを閉じる処理
        packingListTableView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingList))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func endEditingList() {
        view.endEditing(true)
    }
    
    private func fetchItems() {
        let results = realmManager.getObjects(PackingItemDataModel.self)
        items = Array(results)
        packingListTableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let dataModel = PackingItemDataModel()
        dataModel.name = ""
        dataModel.isChecked = false
        
        realmManager.add(dataModel) { [weak self] in
            guard let self = self else {
                return
            }
            
            let hadAtLeastOne = !self.items.isEmpty
            let previousLastIndexPath = IndexPath(row: max(self.items.count - 1, 0), section: 0)
            
            self.items.append(dataModel)
            let indexPath = IndexPath(row: self.items.count - 1, section: 0)
            
            // 追加時のセルの更新
            self.packingListTableView.performBatchUpdates({
                if hadAtLeastOne {
                    self.packingListTableView.reloadRows(at: [previousLastIndexPath], with: .none)
                }
                self.packingListTableView.insertRows(at: [indexPath], with: .automatic)
            })
        }
    }
    
    private func applyBackground(hex: String) {
        let color = UIColor(hex: hex)
        view.backgroundColor = color
    }
    
    private func configure(backgroundHex: String) {
        self.backgroundHex = backgroundHex
    }
}

// MARK: - Extentions

extension PackingListViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    /// セルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //カスタムセルを指定
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackingListCellID",
                                                 for: indexPath)as! PackingListTableViewCell
        
        // セルの最初と最後を確認
        let item = items[indexPath.row]
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == items.count - 1
        cell.setup(packingItem: item.name, isFirst: isFirstCell, isLast: isLastCell)
        cell.delegate = self
        return cell
    }
}

extension PackingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? PackingListTableViewCell)?.beginEditing()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    /// セルの削除
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { [weak self] _, _, done in
            guard let self = self else {
                return
            }
            let item = self.items[indexPath.row]
            
            // Realm から削除
            self.realmManager.delete(item, onSuccess: { [weak self] in
                guard let self = self else {
                    return
                }
                // ローカル配列からも除去してテーブル更新
                self.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                if let visible = tableView.indexPathsForVisibleRows {
                    tableView.reloadRows(at: visible, with: .none)
                }
                done(true)
                
            }, onFailure: { error in
                print("Delete failed: \(error)")
                done(false)
            })
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

extension PackingListViewController: PackingListTableViewCellDelegate {
    func packingCell(_ cell: PackingListTableViewCell, didCommitText text: String) {
        guard let indexPath = packingListTableView.indexPath(for: cell) else {
            return
        }
        let item = items[indexPath.row]
        // Realm更新
        realmManager.update {
            item.name = text
        }
    }
    
    func packingCellDidToggleCheck(_ cell: PackingListTableViewCell, isChecked: Bool) {
        guard let indexPath = packingListTableView.indexPath(for: cell) else {
            return
        }
        let item = items[indexPath.row]
        realmManager.update {
            item.isChecked = isChecked
        }
    }
}
