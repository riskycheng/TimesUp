//
//  ListContentView.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/6.
//

import SwiftUI

struct ListContentView: View {
    
    @State private var selectedTab = 0
    
    let actionItems = [
        ActionItem(mainTitle: "京东｜茅台", dueDate: Date(), link: "https://www.jd.com"),
        ActionItem(mainTitle: "天猫｜茅台", dueDate: Date(), link: "https://www.tmall.com"),
        ActionItem(mainTitle: "苏宁｜茅台", dueDate: Date(), link: "https://www.suning.com"),
        ActionItem(mainTitle: "京东｜iPhone 15", dueDate: Date(), link: "https://www.jd.com"),
        ActionItem(mainTitle: "京东｜vivo X fold 3 Pro", dueDate: Date(), link: "https://www.jd.com"),
        ActionItem(mainTitle: "京东｜Lenovo笔记本", dueDate: Date(), link: "https://www.jd.com"),
        ActionItem(mainTitle: "拼多多｜Xiaomi 14 Ultra", dueDate: Date(), link: "https://www.jd.com")
    ]
    
    var filteredItems: [ActionItem] {
            switch selectedTab {
            case 1:
                return actionItems.filter { !$0.isOutOfDate }
            case 2:
                return actionItems.filter { $0.isOutOfDate }
            default:
                return actionItems
            }
        }
    
    
    var body: some View {
            NavigationView {
                VStack {
                    Text("代办事件")
                        .font(.largeTitle)
                        .bold()
                    Picker("", selection: $selectedTab) {
                        Text("全部").tag(0)
                        Text("待进行").tag(1)
                        Text("已完成").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    List(filteredItems) { item in
                        ActionItemRow(actionItem: item)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(UIColor.systemGroupedBackground))
                }
                .navigationBarHidden(true)
            }
        }
}



struct ActionItemRow: View {
    var actionItem: ActionItem

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }

    var body: some View {
        HStack {
            ZStack {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                    .fill(Color.blue)
                    .frame(width: 24)
                    .padding(EdgeInsets(top: 20, leading: -10, bottom: 20, trailing: 0))
                
                Text("进行中")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .frame(width: 20, alignment: .center)
                    .font(.system(size: 12))
                    .bold()
                    .padding(.leading, -10)
            }
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(actionItem.mainTitle)
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "doc.text")
                        Text(actionItem.isOutOfDate ? "已过期" : "进行中")
                            .font(.caption)
                            .foregroundColor(actionItem.isOutOfDate ? .red : .green)
                    }
                    HStack {
                        Image(systemName: "link")
                        Text(actionItem.link)
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    HStack {
                        Image(systemName: "calendar")
                        Text("\(actionItem.dueDate, formatter: dateFormatter)")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: Text("详细信息")) {

                    }
                }
                .fixedSize()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
        }
        .padding([.top, .bottom], 5)
    }
}


#Preview {
    ListContentView()
}
