//
//  EditShioriPlanDetailViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/28.
//

import UIKit

// MARK: - Protocols

protocol EditShioriPlanDetailViewControllerDelegate: AnyObject {
    func didSavePlan(_ plan: PlanDataModel)
}

// MARK: - Main Type

/// しおり予定情報編集画面
final class EditShioriPlanDetailViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    /// 日付
    private var selectedDate: Date?
    /// 開始時間
    private var selectedStartTime: Date?
    /// 終了時間
    private var selectedEndTime: Date?
    /// 予定の内容
    private var selectedPlan: String = ""
    /// 予約可否
    private var selectedReservation: Bool = false
    /// 費用
    private var selectedCost: Int?
    /// URL
    private var selectedURL: String = ""
    /// 画像
    private var selectedImage: String?
    /// 日付ピッカー
    private let datePickerDate = UIDatePicker()
    /// 開始時間ピッカー
    private let datePickerStartTime = UIDatePicker()
    /// 終了時間ピッカー
    private let datePickerEndTime = UIDatePicker()
    /// しおり予定データ
    private var planDataModel: PlanDataModel?
    /// デリゲートのプロパティ
    weak var delegate: EditShioriPlanDetailViewControllerDelegate?
    /// RealmManagerのシングルトンインスタンスを取得
    let realmManager = RealmManager.shared
    
    // MARK: - Computed Properties
    
    /// 日付取得のフォーマット
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()
    
    /// 時間取得のフォーマット
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    // MARK: - IBOutlets
    
    /// 予定情報の修正ラベル
    @IBOutlet private weak var titleLabel: UILabel!
    /// 日付ラベル
    @IBOutlet private weak var dateLabel: UILabel!
    /// 開始時間ラベル
    @IBOutlet private weak var startTimeLabel: UILabel!
    /// 終了時間ラベル
    @IBOutlet private weak var endTimeLabel: UILabel!
    /// 予定内容ラベル
    @IBOutlet private weak var planLabel: UILabel!
    /// 予約可否ラベル
    @IBOutlet private weak var reservationLabel: UILabel!
    /// 費用ラベル
    @IBOutlet private weak var costLabel: UILabel!
    /// URLラベル
    @IBOutlet private weak var urlLabel: UILabel!
    /// 画像挿入ボタン
    @IBOutlet private weak var insertImageButton: UIButton!
    /// 修正ボタン
    @IBOutlet private weak var editButton: UIButton!
    /// 日付記入欄
    @IBOutlet private weak var dateTextField: UITextField!
    /// 開始時間記入欄
    @IBOutlet private weak var startTimeTextField: UITextField!
    /// 終了時間記入欄
    @IBOutlet private weak var endTimeTextField: UITextField!
    /// 予定内容記入欄
    @IBOutlet private weak var planTextView: UITextView!
    /// 予約可否ボタン
    @IBOutlet private weak var reservationCheckButton: UIButton!
    /// 費用記入欄
    @IBOutlet private weak var costTextField: UITextField!
    /// URL記入欄
    @IBOutlet private weak var urlTextField: UITextField!
    /// 画像プレビュー
    @IBOutlet private weak var planImageView: UIImageView!
    
    // MARK: - Initializers
    
    init(planDataModel: PlanDataModel) {
        self.planDataModel = planDataModel
        super.init(nibName: "EditShioriPlanDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFont()
        configureTextField()
        configureTextView()
        configureBarButtonItems()
        setPlanFromRealm()
        setReservationCheckBox()
        configureBarButtonItems()
        configureDatePicker()
    }
    
    // MARK: - IBActions
    
    /// 要予約のチェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedReservation = sender.isSelected
    }
    
    /// 画像をを挿入するボタンをタップ
    @IBAction private func insertImageButtonTapped(_ sender: UIButton) {
        // イメージピッカーを表示
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /// 「修正」ボタンをタップ
    @IBAction private func correctButtonTapped(_ sender: UIButton) {
        // 予定を登録
        selectedPlan = planTextView.text
        // 費用を登録
        selectedCost = Int(costTextField.text ?? "")
        // URLを登録
        selectedURL = urlTextField.text ?? ""
        validatePlanForm()
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
        
        // タイトル以外のラベルのフォントを設定
        let bodyfont = UIFont.setFontZenMaruGothic(size: 18)
        [dateLabel,startTimeLabel, endTimeLabel, planLabel, reservationLabel, costLabel, urlLabel].forEach {
            $0?.font = bodyfont
        }
        
        // 追加ボタンのフォントを設定
        let addButtonTitle = "修正"
        let addButtonFont = UIFont.setFontZenMaruGothic(size: 24)
        let addButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: addButtonFont,
            .foregroundColor: UIColor.white
        ]
        let addButtonAttributedTitle = NSAttributedString(string: addButtonTitle,
                                                          attributes: addButtonAttributes)
        editButton.setAttributedTitle(addButtonAttributedTitle, for: .normal)
        
        // 画像挿入ボタンのフォントを設定
        let insertImageFont = UIFont.setFontZenMaruGothic(size: 18)
        let insertImageTitle = "画像を入れる"
        let insertImageAttributes: [NSAttributedString.Key: Any] = [
            .font:insertImageFont,
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let insertAttributeTitle = NSAttributedString(string: insertImageTitle,
                                                      attributes: insertImageAttributes)
        insertImageButton.setAttributedTitle(insertAttributeTitle, for: .normal)
    }
    
    private func configureTextField() {
        // 各テキストフィールドに黒枠を設定
        let borderColor = UIColor.black.cgColor
        let borderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 8.0
        
        let textFieldLineSet: [UIView] = [
            dateTextField,
            startTimeTextField,
            endTimeTextField,
            costTextField,
            urlTextField
        ]
        
        textFieldLineSet.forEach { view in
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        [dateTextField, startTimeTextField, endTimeTextField, costTextField, urlTextField].forEach {
            $0?.delegate = self
        }
    }
    
    private func configureTextView() {
        // 各テキストフィールドに黒枠を設定
        planTextView.layer.borderColor = UIColor.black.cgColor
        planTextView.layer.borderWidth = 1.0
        planTextView.layer.cornerRadius = 8.0
        planTextView.layer.masksToBounds = true
        
        planTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func configureDatePicker() {
        [datePickerDate, datePickerStartTime, datePickerEndTime].forEach {
            $0.locale = .init(identifier: "ja_JP")
            $0.preferredDatePickerStyle = .wheels
        }
        
        let pickerToolbar = configureToolbar()
        
        datePickerDate.datePickerMode = .date
        datePickerDate.addTarget(self, action: #selector(dateChanged),  for: .valueChanged)
        dateTextField.inputView = datePickerDate
        dateTextField.inputAccessoryView = pickerToolbar
        
        datePickerStartTime.datePickerMode = .time
        datePickerStartTime.addTarget(self, action: #selector(startTimeChanged), for: .valueChanged)
        startTimeTextField.inputView = datePickerStartTime
        startTimeTextField.inputAccessoryView = pickerToolbar
        
        datePickerEndTime.datePickerMode = .time
        datePickerEndTime.addTarget(self, action: #selector(endTimeChanged),   for: .valueChanged)
        endTimeTextField.inputView = datePickerEndTime
        endTimeTextField.inputAccessoryView = pickerToolbar
    }
    
    @objc private func dateChanged() {
        dateTextField.text = dateFormat(datePickerDate.date, pattern: "yyyy年M月d日")
        // 日付を登録
        selectedDate = datePickerDate.date
    }
    
    @objc private func startTimeChanged() {
        startTimeTextField.text = dateFormat(datePickerStartTime.date, pattern: "HH:mm")
        // 開始時間を登録
        selectedStartTime = datePickerStartTime.date
        checkAndSwapTimes()
    }
    
    @objc private func endTimeChanged() {
        endTimeTextField.text = dateFormat(datePickerEndTime.date, pattern: "HH:mm")
        // 終了時間を登録
        selectedEndTime = datePickerEndTime.date
        checkAndSwapTimes()
    }
    
    private func dateFormat(_ date: Date, pattern: String) -> String {
        dateFormatter.dateFormat = pattern
        return dateFormatter.string(from: date)
    }
    
    /// ツールバーの設定
    private func configureToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "決定",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(title: "キャンセル",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelButtonTapped))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flex, doneButton]
        return toolbar
    }
    
    ///「決定」をタップ時
    @objc private func doneButtonTapped() {
        if dateTextField.isFirstResponder {
            dateChanged()
            dateTextField.resignFirstResponder()
        } else if startTimeTextField.isFirstResponder {
            startTimeChanged()
            startTimeTextField.resignFirstResponder()
        } else if endTimeTextField.isFirstResponder {
            endTimeChanged()
            endTimeTextField.resignFirstResponder()
        }
    }
    
    /// 「キャンセル」をタップ時
    @objc private func cancelButtonTapped() {
        // ピッカーを閉じる
        view.endEditing(true)
        // dateTextField.resignFirstResponder()
    }
    
    /// 開始終了時間の逆転をチェック
    private func checkAndSwapTimes() {
        // 開始日より終了日が前だったら逆転させる
        if let startTime = selectedStartTime,
           let endTime = selectedEndTime,
           startTime > endTime {
            selectedStartTime = endTime
            selectedEndTime = startTime
            
            datePickerStartTime.setDate(endTime, animated: true)
            datePickerEndTime.setDate(startTime, animated: true)
            
            startTimeTextField.text = dateFormat(endTime, pattern: "HH:mm")
            endTimeTextField.text   = dateFormat(startTime, pattern: "HH:mm")
            
            print("開始時間と終了時間を入れ替えました")
        }
    }
    
    /// Realmから予定の情報をセット
    private func setPlanFromRealm() {
        guard let model = planDataModel else {
            return
        }
        
        selectedDate = model.planDate
        selectedStartTime = model.startTime
        selectedEndTime = model.endTime
        selectedPlan = model.planContent
        selectedReservation = model.planReservation
        selectedCost = model.planCost
        selectedURL = model.planURL
        selectedImage = model.planImage
        
        dateTextField.text = dateFormatter.string(from: selectedDate!)
        startTimeTextField.text = timeFormatter.string(from: selectedStartTime!)
        endTimeTextField.text = timeFormatter.string(from: selectedEndTime!)
        planTextView.text = selectedPlan
        reservationCheckButton.isSelected = selectedReservation
        if let cost = selectedCost, cost != 0 {
            costTextField.text = String(cost)
        } else {
            costTextField.text = ""
        }
        urlTextField.text = selectedURL
        if let imageName =  selectedImage {
            planImageView.image = convertToImage(from: imageName)
        } else {
            planImageView.image = nil
        }
    }
    
    /// 予約チェックボックスの画像表示
    private func setReservationCheckBox() {
        reservationCheckButton.setImage(UIImage(named: "ic_check_box_out"), for: .normal)   // false用
        reservationCheckButton.setImage(UIImage(named: "ic_check_box_in"),  for: .selected) // true用
        reservationCheckButton.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.background.backgroundColor = .clear
            button.configuration = configuration
        }
    }
    
    /// 画像の型の変更
    private func convertToImage(from identifier: String) -> UIImage? {
        let trimmedIdentifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIdentifier.isEmpty else { return nil}
        
        if trimmedIdentifier.hasPrefix("data:image/"),
           let commaIdex = trimmedIdentifier.firstIndex(of: ",") {
            let base64String = String(trimmedIdentifier[trimmedIdentifier.index(after: commaIdex)...])
            if let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                return UIImage(data: data)
            }
        }
        if let data = Data(base64Encoded: trimmedIdentifier, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return UIImage(named: trimmedIdentifier)
    }
    
    /// バリデーション
    private func validatePlanForm() {
        var validateTitles: [String] = []
        let validateMessage = "%@は必須項目です"
        
        // 日付がない場合
        if selectedDate == nil {
            validateTitles.append("「日付」")
        }
        
        // 開始時間がない場合
        if selectedStartTime == nil {
            validateTitles.append("「開始時間」")
        }
        
        // 予定内容がない場合
        if selectedPlan.isEmpty {
            validateTitles.append("「内容」")
        }
        
        if validateTitles.isEmpty {
            // 日付と内容が記載されている場合、登録処理を行う
            let planDate = selectedDate!
            let startTime = selectedStartTime!
            updatePlan(planDate: planDate, startTime: startTime)
        } else {
            // 未入力項目がある場合、アラートを表示
            showAlert(title: String(format: validateMessage, validateTitles.joined(separator: "、")))
        }
    }
    
    /// 予定データを更新する
    private func updatePlan(planDate: Date, startTime: Date) {
        guard let model = planDataModel else { return }
        
        realmManager.update(
            onSuccess: {
                // 成功時の処理
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    print("Object added successfully")
                    let alert = UIAlertController(title: "更新しました", message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                            guard let self = self else { return }
                            self.delegate?.didSavePlan(model)
                            
                            let closeModal: () -> Void = {
                                if self.navigationController != nil {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.dismiss(animated: true)
                                }
                            }
                            alert.dismiss(animated: true, completion: closeModal)
                        }
                    }
                }
            }, onFailure: { [weak self] error in
                // 失敗時の処理
                print("Failed to add object to Realm: \(error)")
                DispatchQueue.main.async {
                    self?.showAlert(title: "更新に失敗しました")
                }
            })
        {
            model.planDate = planDate
            model.startTime = startTime
            model.endTime = selectedEndTime
            model.planContent = selectedPlan
            model.planReservation = selectedReservation
            model.planCost = selectedCost ?? 0
            model.planURL = selectedURL
            model.planImage = selectedImage
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
    
    /// Date型に変換
    private func parseDate(_ text: String?, with formatter: DateFormatter) -> Date? {
        guard let text, !text.isEmpty else { return nil }
        return formatter.date(from: text)
    }
}

// MARK: - Extensions

extension EditShioriPlanDetailViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    /// ピッカーを開いた時に今の設定時刻で選択スタートする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            if let currentSelectedDate = selectedDate ?? parseDate(dateTextField.text,
                                                                   with: dateFormatter) {
                datePickerDate.setDate(currentSelectedDate, animated: false)
            }
        } else if textField == startTimeTextField {
            if let currentSelectedStartTime = selectedStartTime ?? parseDate(startTimeTextField.text,
                                                                             with: timeFormatter) {
                datePickerStartTime.setDate(currentSelectedStartTime, animated: false)
            }
        } else if textField == endTimeTextField {
            if let currentSelectedEndTime = selectedEndTime ?? parseDate(endTimeTextField.text,
                                                                         with: timeFormatter) {
                datePickerEndTime.setDate(currentSelectedEndTime, animated: false)
            }
        }
    }
}

extension EditShioriPlanDetailViewController: UITextViewDelegate {
    /// returnキーを押された時のメソッド
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            // キーボードを閉じる
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension EditShioriPlanDetailViewController: UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                selectedImage = imageData.base64EncodedString()
                planImageView.image = image
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
