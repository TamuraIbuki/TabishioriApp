//
//  UIViewController+CalendarPopup.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/14.
//

import UIKit

extension UIViewController {
    
    /// カレンダーポップアップを取り付ける
    func attachCalendarPopup(to textField: UITextField,
                             dateStyle: DateFormatter.Style = .long,
                             locale: Locale = Locale(identifier: "ja_JP"),
                             calendar: Calendar? = nil,
                             onDateSelected: ((Date) -> Void)? = nil) {
        let handler = CalendarPopupHandler(
            textField: textField,
            parentView: self.view,
            dateStyle: dateStyle,
            locale: locale,
            calendar: calendar,
            onDateSelected: onDateSelected
        )
        
        textField.delegate = handler
        objc_setAssociatedObject(textField,
                                 "[CalendarPopupHandler]",
                                 handler,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
