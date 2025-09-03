//
//  CreateShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/06.
//

import UIKit

// MARK: - Protocols

protocol CreateShioriViewControllerDelegate: AnyObject {
    func didSaveNewShiori()
}

// MARK: - Main Type

/// 新しいしおり作成画面
final class CreateShioriViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// しおり名
    private var selectedShioriName: String = ""
    /// 背景色
    private var selectedBackgroundColor: String = ""
    /// 開始日
    private var selectedStartDate: Date?
    /// 終了日
    private var selectedEndDate: Date?
    /// RealmManagerのシングルトンインスタンスを取得
    let realmManager = RealmManager.shared
    /// デリゲートのプロパティ
    weak var delegate: CreateShioriViewControllerDelegate?
    
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
        
        // 日付を取得
        attachCalendarPopup(to: startDateTextField) { [weak self] date in
            self?.selectedStartDate = date
            self?.checkAndSwapDates()
        }
        
        attachCalendarPopup(to: endDateTextField) { [weak self] date in
            self?.selectedEndDate = date
            self?.checkAndSwapDates()
        }
    }
    
    // MARK: - IBActions
    
    /// 作成ボタンをタップ
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        // しおり名を登録
        selectedShioriName = shioriNameTextField.text ?? "しおり名"
        validateShioriForm()
    }
    
    /// 赤を選択
    @IBAction private func redButtonTapped(_ sender: UIButton) {
        let hex = "#FFA5A5"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// ピンクを選択
    @IBAction private func pinkButtonTapped(_ sender: UIButton) {
        let hex = "#FFC1E4"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 紫を選択
    @IBAction private func purpleButtonTapped(_ sender: UIButton) {
        let hex = "#D1A0FF"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 青を選択
    @IBAction private func buleButtonTapped(_ sender: UIButton) {
        let hex = "#B4B3FF"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 水色を選択
    @IBAction private func skyBuleButtonTapped(_ sender: UIButton) {
        let hex = "#A5FFF9"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 緑を選択
    @IBAction private func greenButtonTapped(_ sender: UIButton) {
        let hex = "#B8FFBF"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 黄緑色を選択
    @IBAction private func lightGreenButtonTapped(_ sender: UIButton) {
        let hex = "#E2FF0C"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 黄色を選択
    @IBAction private func yellowButtonTapped(_ sender: UIButton) {
        let hex = "#FFF755"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 橙を選択
    @IBAction private func orangeButtonTapped(_ sender: UIButton) {
        let hex = "#F9D293"
        selectBackgroundColorButton(sender, hexColor: hex)
    }
    
    /// 白を選択
    @IBAction private func whiteButtonTapped(_ sender: UIButton) {
        let hex = "#FFFFFF"
        selectBackgroundColorButton(sender, hexColor: hex)
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
    
    private func selectBackgroundColorButton(_ selectedButton: UIButton, hexColor: String) {
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
    }
    
    /// バリデーション
    private func validateShioriForm() {
        var validateTitles: [String] = []
        let validateMessage = "%@がありません"
        
        // しおり名がない場合
        if selectedShioriName.isEmpty {
            validateTitles.append("「しおり名」")
        }
        
        // 開始日がない場合
        if selectedStartDate == nil {
            validateTitles.append("「開始日」")
        }
        
        // 終了日がない場合
        if selectedEndDate == nil {
            validateTitles.append("「終了日」")
        }
        
        if validateTitles.isEmpty {
            // 未入力項目がない場合、登録処理を行う
            let startDate = selectedStartDate!
            let endDate = selectedEndDate!
            createShiori(startDate: startDate, endDate: endDate)
        } else {
            // 未入力項目がある場合、アラートを表示
            showAlert(title: String(format: validateMessage, validateTitles.joined(separator: "、")))
        }
    }
    
    /// 開始日終了日の逆転をチェック
    private func checkAndSwapDates() {
        // 開始日より終了日が前だったら逆転させる
        if let startDate = selectedStartDate,
           let endDate = selectedEndDate,
           startDate > endDate {
            selectedStartDate = endDate
            selectedEndDate = startDate
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyyy年M月d日"
            
            startDateTextField.text = formatter.string(from: selectedStartDate!)
            endDateTextField.text = formatter.string(from: selectedEndDate!)
            
            print("開始日と終了日を入れ替えました")
        }
    }
    
    ///しおりを登録する
    private func createShiori(startDate: Date, endDate: Date) {
        
        // 背景色が未選択の場合は白を設定
        if selectedBackgroundColor.isEmpty {
            selectedBackgroundColor = "#FFFFFF"
        }
        
        let dataModel = ShioriDataModel()
        dataModel.shioriName = selectedShioriName
        dataModel.startDate = startDate
        dataModel.endDate = endDate
        dataModel.backgroundColor = selectedBackgroundColor
        
        realmManager.add(dataModel, onSuccess: { [weak self] in
            // 成功時の処理
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Object added successfully")
                let alert = UIAlertController(title: "登録しました", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else { return }
                    let closeModal: () -> Void = {
                        if let nav = self.navigationController {
                            nav.dismiss(animated: true)
                            self.delegate?.didSaveNewShiori()
                        } else {
                            self.dismiss(animated: true){
                                self.delegate?.didSaveNewShiori()
                            }
                        }
                    }
                    // 先にアラートを閉じてから戻る
                    if let presented = self.presentedViewController {
                        presented.dismiss(animated: true, completion: closeModal)
                    } else {
                        closeModal()
                    }
                }
            }
        }, onFailure: { [weak self] error in
            // 失敗時の処理
            print("Failed to add object to Realm: \(error)")
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: "登録に失敗しました")
            }
        })
    }
    
    /// アラートを表示
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title,
                                      message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
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
