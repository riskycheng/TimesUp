import SwiftUI
import CoreData

struct ListContentView: View {
    @State var selectedPicker = 0
    @State private var selectedItem: ActionItemEntity?
    @State private var isAddingNewItem = false
    @State private var refreshID = UUID()

    @FetchRequest(
        entity: ActionItemEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ActionItemEntity.dueDate, ascending: true)]
    ) var actionItems: FetchedResults<ActionItemEntity>

    @Environment(\.managedObjectContext) private var viewContext

    var filteredItems: [ActionItemEntity] {
        switch selectedPicker {
        case 1:
            return actionItems.filter { $0.dueDate ?? Date() > Date() }
        case 2:
            return actionItems.filter { $0.dueDate ?? Date() <= Date() }
        default:
            return Array(actionItems)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ListHeaderView()

                VStack {
                    Picker("", selection: $selectedPicker) {
                        Text("全部").tag(0)
                        Text("待进行").tag(1)
                        Text("已完成").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    List {
                        ForEach(filteredItems) { item in
                            ActionItemRow(actionItem: item, selectedItem: $selectedItem, isAddingNewItem: $isAddingNewItem)
                                .listRowBackground(Color.clear)
                                .padding(.vertical, 10)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteItems)
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
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedItem = nil
                            isAddingNewItem = true
                            print("Adding New Item")
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            )
            .sheet(isPresented: $isAddingNewItem) {
                DetailsAddView(isPresented: $isAddingNewItem, actionItem: selectedItem)
                    .environment(\.managedObjectContext, viewContext)
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                if newValue != nil {
                    isAddingNewItem = true
                }
            }
            .onCoreDataChange {
                refresh()
            }
            .id(refreshID)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredItems[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: viewContext)
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func refresh() {
        // This will cause the view to re-fetch the data and refresh the list
        refreshID = UUID()
    }
}

struct ActionItemRow: View {
    var actionItem: ActionItemEntity
    @Binding var selectedItem: ActionItemEntity?
    @Binding var isAddingNewItem: Bool

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }

    var body: some View {
        Menu {
            Button(action: {
                selectedItem = actionItem
                isAddingNewItem = true
            }) {
                Text("编辑此条")
                Image(systemName: "pencil.circle")
                    .foregroundColor(.blue)
            }

            Button(action: {
                if let urlString = actionItem.link, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    print("Invalid URL")
                }
            }) {
                Text("跳转链接")
                Image(systemName: "link.circle")
                    .foregroundColor(.blue)
            }
        } label: {
            HStack {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                        .fill(actionItem.dueDate ?? Date() > Date() ? Color("ActionItem_Ongoing") : Color("ActionItem_Ended"))
                        .frame(width: 24)
                        .padding(EdgeInsets(top: 20, leading: -10, bottom: 20, trailing: 0))
                    
                    Text(actionItem.dueDate ?? Date() > Date() ? "进行中" : "已过期")
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
                            Text(actionItem.mainTitle ?? "")
                                .font(.headline)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text(actionItem.dueDate ?? Date() > Date() ? "进行中" : "已过期")
                                .font(.caption)
                                .foregroundColor(actionItem.dueDate ?? Date() > Date() ? .green : .red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer(minLength: 20)
                        
                        HStack {
                            Image(systemName: "link.circle.fill")
                                .foregroundColor(.blue)
                            Text(actionItem.link ?? "")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer(minLength: -10)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text("\(actionItem.dueDate ?? Date(), formatter: dateFormatter)")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(minWidth: 200)
                    
                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(.trailing, 0)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
            }
            .padding([.top, .bottom], 5)
            .contentShape(Rectangle()) // Ensures the whole row is tappable, but does not trigger the button
        }
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
