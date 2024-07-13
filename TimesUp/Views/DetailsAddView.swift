import SwiftUI
import CoreData

struct DetailsAddView: View {
    @State private var title: String = ""
    @State private var url: String = ""
    @State private var date = Date()
    @State private var isReminderOn: Bool = false
    @State private var repeatDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    var actionItem: ActionItemEntity?
    
    init(isPresented: Binding<Bool>, actionItem: ActionItemEntity? = nil) {
        self._isPresented = isPresented
        self.actionItem = actionItem
        if let actionItem = actionItem {
            _title = State(initialValue: actionItem.mainTitle ?? "")
            _url = State(initialValue: actionItem.link ?? "")
            _date = State(initialValue: actionItem.dueDate ?? Date())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                }.toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                            isPresented = false
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(actionItem == nil ? "Add" : "Save") {
                            if let actionItem = actionItem {
                                updateItem(actionItem)
                            } else {
                                saveNewItem()
                            }
                            self.presentationMode.wrappedValue.dismiss()
                            isPresented = false
                        }
                    }
                    ToolbarItemGroup(placement: .principal) {
                        Text(actionItem == nil ? "新建事件" : "编辑事件")
                            .font(.headline)
                    }
                }
                
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
                        .navigationBarBackButtonHidden(true)
                        
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
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func saveNewItem() {
        let newItem = ActionItemEntity(context: viewContext)
        newItem.mainTitle = title
        newItem.link = url
        newItem.dueDate = date
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func updateItem(_ item: ActionItemEntity) {
        item.mainTitle = title
        item.link = url
        item.dueDate = date
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct RepeatDaysView: View {
    @Binding var repeatDays: [String]
    let allDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @Environment(\.presentationMode) var presentationMode
    
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
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItemGroup(placement: .principal) {
                Text("选择重复周期")
                    .font(.headline)
            }
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItemGroup(placement: .principal) {
                Text("选择提醒时间")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    DetailsAddView(isPresented: .constant(true))
}
