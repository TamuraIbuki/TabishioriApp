//
//  CalendarPopupHandler.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/14.
//

import UIKit

/// カレンダーポップアップのヘルパークラス
final class CalendarPopupHandler: NSObject, UITextFieldDelegate {
    
    // MARK: - Stored Properties
    
    weak var textField: UITextField?
    weak var parentView: UIView?
    private var onDateSelected: ((Date) -> Void)?
    private var dateStyle: DateFormatter.Style
    private var locale: Locale
    private var calendar: Calendar?
    private var containerView: UIView?
    private var backgroundView: UIView?
    private var datePicker: UIDatePicker?
    private var minimumDate: Date? {
        didSet { datePicker?.minimumDate = minimumDate }
    }
    
    // MARK: - Computed Properties
    
    private var effectiveCalendar: Calendar {
        calendar ?? .current
    }
    private func makeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateStyle = dateStyle
        formatter.calendar = effectiveCalendar
        formatter.timeStyle = .none
        return formatter
    }
    
    // MARK: - Initializers
    
    init(textField: UITextField,
         parentView: UIView,
         dateStyle: DateFormatter.Style,
         locale: Locale,
         calendar: Calendar?,
         minimumDate: Date? = nil,
         onDateSelected: ((Date) -> Void)?) {
        
        self.textField = textField
        self.parentView = parentView
        self.dateStyle = dateStyle
        self.locale = locale
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.onDateSelected = onDateSelected
    }
    
    // MARK: - Other Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        showCalendar()
    }
    
    private func showCalendar() {
        guard let parentView, let textField else { return }
        guard containerView == nil else { return }
        
        // カレンダーコンテナ作成
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.clipsToBounds = true
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        }
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // デフォルトは今日の日付をおき、今日以降の日付のみ選択可能にする
        let selectedCalendar = calendar ?? Calendar.current
        let todayStart = selectedCalendar.startOfDay(for: Date())
        let minDate = self.minimumDate ?? todayStart
        picker.minimumDate = minDate
        picker.timeZone = .current
        
        let formatter = makeFormatter()
        if let text = textField.text,
           let current = formatter.date(from: text) {
            picker.date = (current < minDate) ? minDate : current
        } else {
            picker.date = minDate
        }
        
        if (textField.text ?? "").isEmpty {
            textField.text = formatter.string(from: minDate)
            onDateSelected?(minDate)
        }

        container.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: container.topAnchor),
            picker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        self.datePicker = picker
        
        parentView.addSubview(container)
        self.containerView = container
        
        // 表示位置計算
        let tfFrame = textField.convert(textField.bounds, to: parentView)
        let width: CGFloat = 320
        let height: CGFloat = 320
        var x = tfFrame.origin.x
        var y = tfFrame.maxY + 4
        
        if x + width > parentView.bounds.width - 10 {
            x = parentView.bounds.width - width - 10
        }
        if y + height > parentView.bounds.height - 10 {
            y = tfFrame.minY - height - 4
        }
        container.frame = CGRect(x: max(10, x), y: max(10, y), width: width, height: height)
        
        // 背景タップで消す
        let bgView = UIView(frame: parentView.bounds)
        bgView.backgroundColor = .clear
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissCalendar))
        bgView.addGestureRecognizer(tap)
        parentView.insertSubview(bgView, belowSubview: container)
        self.backgroundView = bgView
    }
    
    @objc private func dismissCalendar() {
        containerView?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        containerView = nil
        backgroundView = nil
        datePicker = nil
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        guard let textField else { return }
        let formatter = makeFormatter()
        textField.text = formatter.string(from: sender.date)
        onDateSelected?(sender.date)
        dismissCalendar()
    }
}
