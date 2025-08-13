//
//  CreateShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/06.
//

import UIKit

/// 新しいしおり作成画面
final class CreateShioriViewController: UIViewController {
    
    // MARK: - Properties
    
    /// しおり名
    private var selectedShioriName: String = ""
    /// 背景色
    private var selectedBackgroundColor: String = ""
    
    // MARK: - IBOutlets
    
    /// 画面タイトル
    @IBOutlet private weak var titleLabel: UILabel!
    /// しおり名ラベル
    @IBOutlet private weak var shioriNameLabel: UILabel!
    /// 開始日ラベル
    @IBOutlet private weak var startDateLabel: UILabel!
    /// 終了日ラベル
    @IBOutlet private weak var endDateLabel: UILabel!
    /// 背景の色ラベル
    @IBOutlet private weak var backColorLabel: UILabel!
    /// 作成ボタン
    @IBOutlet private weak var createButton: UIButton!
    /// 背景ボタン
    @IBOutlet private var colorButtons: [UIButton]!
    /// しおり名記入欄
    @IBOutlet private weak var shioriNameTextField: UITextField!
    /// 開始日記入欄
    @IBOutlet private weak var startDateTextField: UITextField!
    /// 終了日記入欄
    @IBOutlet private weak var endDateTextField: UITextField!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTextField()
        configureNavigationBar()
    }
    
    // MARK: - IBActions
    
    /// 作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        // しおり名を登録
        selectedShioriName = shioriNameTextField.text ?? "しおり名"
        print("shioriNameの内容: \(selectedShioriName)")
        
        // TODO: あとでしおり名、開始日終了日、背景の色の保存処理を実装
    }
    
    /// 赤を選択
    @IBAction private func redButtonTapped(_ sender: UIButton) {
        let hex = "#FFA5A5"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// ピンクを選択
    @IBAction private func pinkButtonTapped(_ sender: UIButton) {
        let hex = "#FFC1E4"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 紫を選択
    @IBAction private func purpleButtonTapped(_ sender: UIButton) {
        let hex = "#D1A0FF"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 青を選択
    @IBAction private func buleButtonTapped(_ sender: UIButton) {
        let hex = "#B4B3FF"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 水色を選択
    @IBAction private func skyBuleButtonTapped(_ sender: UIButton) {
        let hex = "#A5FFF9"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 緑を選択
    @IBAction private func greenButtonTapped(_ sender: UIButton) {
        let hex = "#B8FFBF"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 黄緑色を選択
    @IBAction private func lightGreenButtonTapped(_ sender: UIButton) {
        let hex = "#E2FF0C"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 黄色を選択
    @IBAction private func yellowButtonTapped(_ sender: UIButton) {
        let hex = "#FFF755"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 橙を選択
    @IBAction private func orangeButtonTapped(_ sender: UIButton) {
        let hex = "#F9D293"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    /// 白を選択
    @IBAction private func whiteButtonTapped(_ sender: UIButton) {
        let hex = "#FFFFFF"
        selectBackColorButton(sender, hexColor: hex)
    }
    
    // MARK: - Other Methods
    
    private func setupFont() {
        // タイトルのフォントを変更
        titleLabel.font = .setFontZenMaruGothic(size: 24)
        titleLabel.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.masksToBounds = false
        // しおり名のフォントを変更
        shioriNameLabel.font = .setFontZenMaruGothic(size: 18)
        // 開始日のフォントを変更
        startDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 終了日のフォントを変更
        endDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 背景の色のフォントを変更
        backColorLabel.font = .setFontZenMaruGothic(size: 18)
        // 作成ボタンのフォントを変更
        let title = "作成"
        let font = UIFont.setFontZenMaruGothic(size: 24)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        createButton.setAttributedTitle(attributedTitle, for: .normal)
        // 背景ボタンに黒い枠線をつける
        colorButtons.forEach { buttons in
            buttons.layer.borderWidth = 1
            buttons.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func configureTextField() {
        // 各テキストフィールドに黒枠を設定
        let borderColor = UIColor.black.cgColor
        let borderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 8.0
        
        let textFieldLineSet: [UIView] = [
            shioriNameTextField,
            startDateTextField,
            endDateTextField,
        ]
        
        textFieldLineSet.forEach { view in
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        [shioriNameTextField, startDateTextField, endDateTextField].forEach {
            $0?.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func changeBackGroundColor(to color: UIColor) {
        // 確認用
        print("変更後の背景色: \(color)")
        
        // それぞれの背景色を変更
        if let packingListVC = self.navigationController?.viewControllers
            .first(where: { $0 is PackingListViewController }) as? PackingListViewController {
            packingListVC.view.backgroundColor = color
            
        }
        if let editShioriPlanVC = self.navigationController?.viewControllers
            .first(where: { $0 is EditShioriPlanViewController }) as? EditShioriPlanViewController {
            editShioriPlanVC.view.backgroundColor = color
        }
        if let shioriContentVC = self.navigationController?.viewControllers
            .first(where: { $0 is ShioriContentViewController }) as? ShioriContentViewController {
            shioriContentVC.view.backgroundColor = color
        }
    }
    
    private func selectBackColorButton(_ selectedButton: UIButton, hexColor: String) {
        colorButtons.forEach { buttons in
            // 他のボタンを選択時は黒枠線に戻す
            buttons.layer.borderWidth = 1
            buttons.layer.borderColor = UIColor.black.cgColor
        }
        
        // 選択時青い太い枠線を付ける
        selectedButton.layer.borderWidth = 3
        selectedButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        // 選択した色のHexをプロパティに保存
        selectedBackgroundColor = hexColor
        // 確認用
        print("変更後の背景色: \(hexColor)")
    }
}

// MARK: - Extensions

extension CreateShioriViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
