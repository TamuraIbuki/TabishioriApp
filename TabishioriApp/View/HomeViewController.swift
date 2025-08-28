//
//  HomeViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/01.
//

import UIKit
import RealmSwift

/// Home画面
final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    /// RealmManagerのシングルトンインスタンスを取得
    private let realmManager = RealmManager.shared
    /// 取得したデータの格納先
    private var data: Results<ShioriDataModel>?
    
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
        setBackground()
        configureTableView()
        tableView.delegate = self
        fetchData()
    }
    
    // MARK: - IBActions
    
    /// 新しいしおりを作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        let nextVC = CreateShioriViewController()
        nextVC.onSaved = { [weak self] in
            self?.fetchData()
            self?.tableView.reloadData()
        }
        let navi = UINavigationController(rootViewController: nextVC)
        navigationController?.present(navi, animated: true)
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
    
    private func configureTableView() {
        tableView.dataSource = self
        // カスタムセルを登録
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeTableViewCellID")
    }
    
    /// しおりデータを取得する
    private func fetchData() {
        let results = realmManager.getObjects(ShioriDataModel.self)
        data = results
        tableView.reloadData()
    }
    
    /// 日付をセットする
    private func setDate(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy.MM.dd"
        return "\(formatter.string(from: start))~\(formatter.string(from: end))"
    }
    
    /// 背景を設定
    private func setBackground(){
        if let bgImage = UIImage(named: "ic_home_background") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        }
    }
}

// MARK: - Extentions

extension HomeViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    /// セルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else { return UITableViewCell() }
        // カスタムセルを指定
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellID",
                                                 for: indexPath)as! HomeTableViewCell
        let item = data[indexPath.row]
        cell.setup(shioriName: item.shioriName,
                   shioriDate: setDate(start: item.startDate, end: item.endDate),
                   backgroundColorHex: item.backgroundColor)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    /// テーブルビューセルをタップした時しおり画面に遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shioriVC = ShioriViewController(nibName: "ShioriViewController", bundle: nil)
        if let data = data {
            shioriVC.selectedShiori = data[indexPath.row] // 単一のShioriDataModelを渡す
        }
        navigationController?.pushViewController(shioriVC, animated: true)
    }
}
