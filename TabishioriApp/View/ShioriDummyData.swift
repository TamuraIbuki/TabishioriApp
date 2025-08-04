//
//  ShioriDummyData.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/08/04.
//

import Foundation

/// 予定仮データ
final class ShioriDummyData {
    static let scheduleItems: [ShioriPlanTableViewCell.ScheduleItem] = [
        .init(startTime: "8:00",
              endTime: "16:00",
              plan: "飛行機でマレーシアに移動",
              isReserved: true,
              cost: 15000,
              hasURL: true,
              hasImage: true),
        .init(startTime: "17:00",
              endTime: nil,
              plan: "色鮮やかな寺院とナイトマーケット巡りをする",
              isReserved: false,
              cost: nil,
              hasURL: false,
              hasImage: false),
        .init(startTime: "19:00",
              endTime: "20:00",
              plan: "ホテルチェックイン",
              isReserved: false,
              cost: 8000,
              hasURL: true,
              hasImage: false)
    ]
}
