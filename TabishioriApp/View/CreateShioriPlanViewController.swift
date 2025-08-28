//
//  CreateShioriPlanViewController.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/25.
//

import UIKit

// MARK: - Protocols

protocol CreateShioriPlanViewControllerDelegate: AnyObject {
    func didSaveNewPlan(for date: Date)
}

// MARK: - Main Type
/// 新しい予定作成画面
final class CreateShioriPlanViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 事前に選択された日付
    var preselectedDate: Date?
    /// 日付
    private var selectedDate: Date?
    /// 開始時間
    private var selectedStartTime: Date?
    /// 終了時間
    private var selectedEndTime: Date?
    /// 予定の内容
    private var selectedPlan: String = ""
    /// 予約要否
    private var selectedReservation: Bool = false
    /// 費用
    private var selectedCost: Int?
    /// URL
    private var selectedURL: String = ""
    /// 画像
    private var selectedImage: String = ""
    /// 日付ピッカー
    private let datePickerDate = UIDatePicker()
    /// 開始時間ピッカー
    private let datePickerStartTime = UIDatePicker()
    /// 終了時間ピッカー
    private let datePickerEndTime = UIDatePicker()
    /// RealmManagerのシングルトンインスタンスを登録
    private let realmManager = RealmManager.shared
    /// デリゲートのプロパティ
    weak var delegate: CreateShioriPlanViewControllerDelegate?
    
    // MARK: - Computed Properties
    
    /// 日付・時間取得のフォーマット
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - IBOutlets
    
    /// 新しい予定追加のタイトルラベル
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
    /// 追加ボタン
    @IBOutlet private weak var addButton: UIButton!
    /// 日付記入欄
    @IBOutlet private weak var dateTextField: UITextField!
    /// 開始時間記入欄
    @IBOutlet private weak var startTimeTextField: UITextField!
    /// 終了時間記入欄
    @IBOutlet private weak var endTimeTextField: UITextField!
    /// 予定内容記入欄
    @IBOutlet private weak var planTextView: UITextView!
    /// 費用記入欄
    @IBOutlet private weak var costTextField: UITextField!
    /// URL記入欄
    @IBOutlet private weak var urlTextField: UITextField!
    /// 画像プレビュー
    @IBOutlet private weak var planImageView: UIImageView!
    
    // MARK: - View Life-Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った日付を初期値としてセット
        if let date = preselectedDate {
            selectedDate = date
            dateTextField.text = dateFormat(date, pattern: "yyyy年M月d日")
            datePickerDate.date = date
        }
        setupFont()
        configureTextField()
        configureTextView()
        configureNavigationBar()
        configureDatePicker()
    }
    
    // MARK: - IBActions
    
    /// 要予約のチェックボックスをタップ
    @IBAction private func checkBoxButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedReservation = sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "ic_check_box_in"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_check_box_out"), for: .normal)
        }
    }
    
    /// 画像をを挿入するボタンをタップ
    @IBAction private func insertImageButtonTapped(_ sender: UIButton) {
        // イメージピッカーを表示
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
     }
    
    /// 追加ボタンをタップ
    @IBAction private func addButtonTapped(_ sender: UIButton) {
        // 予定を登録
        selectedPlan = planTextView.text
        // 費用を登録
        selectedCost = Int(costTextField.text ?? "")
        // URLを登録
        selectedURL = urlTextField.text ?? ""
        validatePlanForm()
        
        // 確認用
        print("selectedDate: \(String(describing: selectedDate))")
        print("selectedStartTime: \(String(describing: selectedStartTime))")
        print("selectedEndTime: \(String(describing: selectedEndTime))")
        print("selectedPlan: \(selectedPlan)")
        print("selectedReservation: \(selectedReservation)")
        print("selectedCost: \(selectedCost?.description ?? "nil")")
        print("selectedURL: \(selectedURL)")
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
        let addButtonTitle = "追加"
        let addButtonFont = UIFont.setFontZenMaruGothic(size: 24)
        let addButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: addButtonFont,
            .foregroundColor: UIColor.white
        ]
        let addButtonAttributedTitle = NSAttributedString(string: addButtonTitle, attributes: addButtonAttributes)
        addButton.setAttributedTitle(addButtonAttributedTitle, for: .normal)
        
        // 画像挿入ボタンのフォントを設定
        let insertImageFont = UIFont.setFontZenMaruGothic(size: 18)
        let insertImageTitle = "画像を入れる"
        let insertImageAttributes: [NSAttributedString.Key: Any] = [
            .font:insertImageFont,
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let insertAttributeTitle = NSAttributedString(string: insertImageTitle, attributes: insertImageAttributes)
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
            savePlanData(planDate: planDate, startTime: startTime)
        } else {
            // 未入力項目がある場合、アラートを表示
            showAlert(title: String(format: validateMessage, validateTitles.joined(separator: "、")))
        }
    }
    
    /// データを保存する
    private func savePlanData(planDate: Date, startTime: Date) {
        let planDataModel = PlanDataModel()
        planDataModel.planDate = planDate
        planDataModel.startTime = startTime
        planDataModel.endTime = selectedEndTime
        planDataModel.planContent = selectedPlan
        planDataModel.planReservation = selectedReservation
        planDataModel.planCost = selectedCost ?? 0
        planDataModel.planURL = selectedURL
        planDataModel.planImage = selectedImage
        
        realmManager.add(planDataModel, onSuccess: { [weak self] in
            // 成功時の処理
            DispatchQueue.main.async {
                print("Object added successfully")
                guard let self = self else { return }
                let alert = UIAlertController(title: "登録しました", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    self.presentingViewController?.dismiss(animated: true) { [weak self] in
                        self?.delegate?.didSaveNewPlan(for: planDataModel.planDate)
                    }
                })
                self.present(alert, animated: true)
            }
        }, onFailure: { [weak self] error in
            // 失敗の処理
            DispatchQueue.main.async {
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

extension CreateShioriPlanViewController: UITextFieldDelegate {
    /// returnキーを押された時のメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

extension CreateShioriPlanViewController: UITextViewDelegate {
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

extension CreateShioriPlanViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
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
