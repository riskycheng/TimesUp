//
//  K.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/6.
//

import Foundation

class K {
    static let TAB_NAME_TAB_1: String = "抢购时钟"
    static let TAB_NAME_TAB_2: String = "待办事件"
    static let TAB_NAME_TAB_3: String = "设置"
    
    static func simulateData(number count : Int) -> [ActionItem] {
        var actions : [ActionItem] = []
        
        actions.append(ActionItem(mainTitle: "京东｜茅台", dueDate: Date(), link: "https://www.jd.com"))
        actions.append(ActionItem(mainTitle: "天猫｜茅台", dueDate: Date(), link: "https://www.tmall.com"))
        actions.append(ActionItem(mainTitle: "苏宁｜茅台", dueDate: Date(), link: "https://www.suning.com"))
        actions.append(ActionItem(mainTitle: "京东｜iPhone 15", dueDate: Date(), link: "https://www.jd.com"))
        actions.append(ActionItem(mainTitle: "京东｜vivo X fold 3 Pro", dueDate: Date(), link: "https://www.jd.com"))
        actions.append(ActionItem(mainTitle: "京东｜Lenovo笔记本", dueDate: Date(), link: "https://www.jd.com"))
        actions.append(ActionItem(mainTitle: "拼多多｜Xiaomi 14 Ultra", dueDate: Date(), link: "https://www.jd.com"))
        
        return actions
    }
}
