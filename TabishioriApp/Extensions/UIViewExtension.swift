//
//  UIViewExtension.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/09/12.
//
//
import UIKit
import PDFKit

extension UIView {
    func toPDF() -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: self.bounds)
        return pdfRenderer.pdfData { context in
            context.beginPage()
            self.layer.render(in: context.cgContext)
        }
    }
}
