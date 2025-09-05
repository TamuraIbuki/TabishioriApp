//
//  EditShioriViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/08.
//

import UIKit
import RealmSwift

// MARK: - Protocols

protocol EditShioriViewControllerDelegate: AnyObject {
    func didSaveNewShiori(_ updated: ShioriDataModel)
}

// MARK: - Main Type

/// しおり修正画面
final class EditShioriViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// しおり名
    private var selectedShioriName: String = ""
    /// 背景色
    private var selectedBackgroundColor: String = ""
    /// 開始日
    private var selectedStartDate: Date?
    /// 終了日
    private var selectedEndDate: Date?
    /// しおりデータ
    var dataModel: ShioriDataModel?
    /// デリゲートのプロパティ
    weak var delegate: EditShioriViewControllerDelegate?
    
    // MARK: - Computed Properties
    
    /// 日付・時間取得のフォーマット
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "yyyy年M月d日"
        return df
    }()
    
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
    /// 修正ボタン
    @IBOutlet private weak var updateButton: UIButton!
    /// 背景ボタン
    @IBOutlet private var colorButtons: [UIButton]!
    /// しおり名記入欄
    @IBOutlet private weak var shioriNameTextField: UITextField!
    /// 開始日記入欄
    @IBOutlet private weak var startDateTextField: UITextField!
    /// 終了日記入欄
    @IBOutlet private weak var endDateTextField: UITextField!
    
    // MARK: - Initializers
    
    init(dataModel: ShioriDataModel) {
        self.dataModel = dataModel
        super.init(nibName: "EditShioriViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable. Use init(dataModel:) instead.")
    }
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTextField()
        configureBarButtonItems()
        assignTagsIfNeeded()
        setShioriFromRealm()
        
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
    
    /// 修正ボタンをタップ
    @IBAction private func updateButtonTapped(_ sender: UIButton) {
        // しおり名を登録
        selectedShioriName = shioriNameTextField.text ?? ""
        validateShioriForm()
    }
    
    /// 左矢印ボタンをタップ
    @IBAction private func leftArrowButtonTapped(_ sender: UIButton) {
        // 前の画面に戻る
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
        // しおり名のフォントを変更
        shioriNameLabel.font = .setFontZenMaruGothic(size: 18)
        // 開始日のフォントを変更
        startDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 終了日のフォントを変更
        endDateLabel.font = .setFontZenMaruGothic(size: 18)
        // 背景の色のフォントを変更
        backColorLabel.font = .setFontZenMaruGothic(size: 18)
        // 作成ボタンのフォントを変更
        let title = "修正"
        let font = UIFont.setFontZenMaruGothic(size: 24)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        updateButton.setAttributedTitle(attributedTitle, for: .normal)
        // 白の背景ボタンに黒い枠線をつける
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
    
    private func configureBarButtonItems() {
        // 戻るボタン
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_left_arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Realmからしおりの情報をセット
    private func setShioriFromRealm() {
        guard let model = dataModel else {
            return
        }
        
        selectedShioriName = model.shioriName
        selectedStartDate = model.startDate
        selectedEndDate = model.endDate
        selectedBackgroundColor = model.backgroundColor
        // テキストフィールドに反映
        shioriNameTextField.text = selectedShioriName
        startDateTextField.text = dateFormatter.string(from: selectedStartDate!)
        endDateTextField.text = dateFormatter.string(from: selectedEndDate!)
        
        let normalized = (selectedBackgroundColor.isEmpty ? "#FFFFFF" : selectedBackgroundColor)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        if let button = setBackgroundColorHex(forHex: normalized) {
            selectBackgroundColorButton(button, hexColor: normalized)
        }
    }
    
    private func setBackgroundColorHex(forHex hex: String) -> UIButton? {
        let hexMap: [Int: String] = [
            1: "#FFA5A5", // 赤
            2: "#FFC1E4", // ピンク
            3: "#D1A0FF", // 紫
            4: "#B4B3FF", // 青
            5: "#A5FFF9", // 水色
            6: "#B8FFBF", // 緑
            7: "#E2FF0C", // 黄緑
            8: "#FFF755", // 黄
            9: "#F9D293", // 橙
            10: "#FFFFFF" // 白
        ]
        
        guard let (tag, _) = hexMap.first(where: { $0.value == hex}) else { return nil }
        return colorButtons.first(where: { $0.tag == tag })
    }
    
    private func assignTagsIfNeeded() {
        guard colorButtons.allSatisfy({ $0.tag == 0 }) else { return }
        let hexes = ["#FFA5A5","#FFC1E4","#D1A0FF","#B4B3FF",
                     "#A5FFF9","#B8FFBF","#E2FF0C","#FFF755",
                     "#F9D293","#FFFFFF"]
        for (i, tagValue) in colorButtons.enumerated() where i < hexes.count {
            tagValue.tag = i + 1
            tagValue.accessibilityIdentifier = hexes[i]
        }
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
            // 未入力項目がない場合、更新処理を行う
            let startDate = selectedStartDate!
            let endDate = selectedEndDate!
            update(startDate: startDate, endDate: endDate)
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
    
    /// しおりデータを更新する
    private func update(startDate: Date, endDate: Date) {
        guard let model = dataModel else { return }
        do {
            let realm = try Realm()
            try realm.write {
                model.shioriName = selectedShioriName
                model.startDate = startDate
                model.endDate = endDate
                model.backgroundColor = selectedBackgroundColor
            }
            
            // 成功時の処理
            DispatchQueue.main.async { [ weak self ] in
                guard let self = self else { return }
                print("Object added successfully")
                let alert = UIAlertController(title: "更新しました", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    let closeModal: () -> Void = {
                        if let nav = self.navigationController {
                            nav.dismiss(animated: true)
                            if let model = self.dataModel {
                                self.delegate?.didSaveNewShiori(model)
                            }
                    
                        } else {
                            self.dismiss(animated: true){
                                if let model = self.dataModel {
                                    self.delegate?.didSaveNewShiori(model)
                                }
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
        } catch {
            // 失敗時の処理
            print("Failed to add object to Realm: \(error)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlert(title: "更新に失敗しました")
            }
        }
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

extension EditShioriViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
