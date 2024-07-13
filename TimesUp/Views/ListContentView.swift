//
//  ListContentView.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/6.
//

import SwiftUI

struct ListContentView: View {
    
    @State private var selectedTab = 0
    @State private var selectedItem: ActionItem?
    
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
                ListHeaderView()
                
                VStack {
                    Picker("", selection: $selectedTab) {
                        Text("全部").tag(0)
                        Text("待进行").tag(1)
                        Text("已完成").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List(filteredItems.indices, id: \.self) { index in
                        ActionItemRow(actionItem: filteredItems[index], selectedItem: $selectedItem)
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 10)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
                .background(.white)
                .cornerRadius(20.0)
                .padding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }
}



struct ActionItemRow: View {
    var actionItem: ActionItem
    @Binding var selectedItem: ActionItem?

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
                    .multilineTextAlignment(.leading)
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.blue)
                        Text(actionItem.isOutOfDate ? "已过期" : "进行中")
                            .font(.caption)
                            .foregroundColor(actionItem.isOutOfDate ? .red : .green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.blue)
                        Text(actionItem.link)
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer(minLength: -10)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("\(actionItem.dueDate, formatter: dateFormatter)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(minWidth: 200)
                
                Spacer()
                
                NavigationLink(destination: DetailsAddView(actionItem: actionItem)) {
                
                }
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



struct ListHeaderView: View {
    var body: some View {
        HStack {
            Text("待办事件")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(alignment: .center)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 0))
            Spacer()
            GIFImageView(gifName: "mailbox_anim")
                .frame(width: 100, height: 100)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.mainContentHeaderBlue)
    }
}


#Preview {
    ListContentView()
}
