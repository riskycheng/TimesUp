//
//  DetailsAddView.swift
//  TimesUp
//
//  Created by Jian Cheng on 2024/7/9.
//

import SwiftUI

struct DetailsAddView: View {
    @State private var title: String = ""
    @State private var url: String = ""
    @State private var date = Date()
    @State private var isReminderOn: Bool = false
    @State private var repeatDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                Form {
                    Section {
                        HStack {
                            Image(systemName: "circle.grid.3x3.fill")
                            TextField("Enter Title", text: $title)
                        }
                        HStack {
                            Image(systemName: "link")
                            TextField("Enter URL", text: $url)
                        }
                        HStack {
                            Image(systemName: "clock")
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                        }
                    }

                    Section(header: Text("Periodic Reminder")) {
                        Toggle(isOn: $isReminderOn) {
                            Text("Enable Reminder")
                        }
                        NavigationLink(destination: RepeatDaysView(repeatDays: $repeatDays)) {
                            HStack {
                                Text("Repeat")
                                Spacer()
                                Text(repeatDays.joined(separator: ", "))
                                    .foregroundColor(.blue)
                            }
                        }
                        NavigationLink(destination: TimePickerView(time: $date)) {
                            HStack {
                                Text("Reminder Time")
                                Spacer()
                                Text("\(date, formatter: timeFormatter)")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct RepeatDaysView: View {
    @Binding var repeatDays: [String]
    let allDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        List {
            ForEach(allDays, id: \.self) { day in
                MultipleSelectionRow(title: day, isSelected: self.repeatDays.contains(day)) {
                    if self.repeatDays.contains(day) {
                        self.repeatDays.removeAll { $0 == day }
                    } else {
                        self.repeatDays.append(day)
                    }
                }
            }
        }
        .navigationTitle("选择重复周期")
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct TimePickerView: View {
    @Binding var time: Date

    var body: some View {
        VStack {
            DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            Spacer()
        }
        .navigationTitle("选择提醒时间")
    }
}


#Preview {
    DetailsAddView()
}
