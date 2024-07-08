import SwiftUI

struct MainContentView: View {
    @State private var selectedClockFormat: String? = "HH-MM-SS-MS"
    @State private var selectedDisplayMode: String? = "Clock"
    
    var body: some View {
        VStack {
            HeaderView()
            
            VStack {
                TimerView(selectedFormat: $selectedClockFormat)
                ControlButton()
                SettingsGrid(selectedClockFormat: $selectedClockFormat, selectedDisplayMode: $selectedDisplayMode)
                Spacer()
            }
            .background(.white)
            .cornerRadius(20.0)
            .padding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .background(.gray)
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("抢购时钟")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(alignment: .center)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 0))
            Spacer()
            GIFImageView(gifName: "stopwatch_anim")
                            .frame(width: 100, height: 100)
                            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(.mainContentHeaderCyran)
    }
}

struct TimerView: View {
    @State private var currentTime = Date()
    @Binding var selectedFormat: String?
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(height: 120)
                .shadow(radius: 10)
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Spacer()
                        ZStack {
                            Image("CalendarEmpty")
                                .resizable()
                                .frame(width: 90, height: 90)
                            Text(currentDayFormatted)
                                .font(.system(size: 30, weight: .bold, design: .monospaced))
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    VStack {
                        Text(currentTimeFormatted)
                            .font(.system(size: 30, weight: .medium, design: .monospaced))
                    }
                    .frame(width: geometry.size.width * 0.6, alignment: .center)
                }
                .foregroundColor(.white)
                .frame(alignment: .center)
            }
        }
        .padding()
        .onReceive(timer) { input in
            self.currentTime = input
        }
        .frame(height: 160, alignment: .center)
    }
    
    private var currentTimeFormatted: String {
        let formatter = DateFormatter()
        switch selectedFormat {
        case "SS-MS":
            formatter.dateFormat = "ss.S"
        case "MM-SS-MS":
            formatter.dateFormat = "mm:ss.S"
        case "HH-MM-SS-MS":
            formatter.dateFormat = "HH:mm:ss.S"
        default:
            formatter.dateFormat = "HH:mm:ss.S"
        }
        return formatter.string(from: currentTime)
    }
    
    private var currentDayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: currentTime)
    }
}

struct ControlButton: View {
    var body: some View {
        Button(action: {
            // Action for button
        }) {
            Text("启动悬浮时间")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct SettingsGrid: View {
    @Binding var selectedClockFormat: String?
    @Binding var selectedDisplayMode: String?
    @State private var toggleState_countDown = true
    @State private var toggleState_isLand = true
    
    var body: some View {
        VStack(spacing: 60) {
            HStack(spacing: 20) {
                SettingsItem(icon: .custom(name: "SettingsDisplayMode"), title: "显示内容", subtitle: "时钟",
                             buttonType: .customImageButton("OptionsMenu", [
                                SettingsItem.MenuItem(id: "Speed", title: "实时速率", action: {
                                    selectedDisplayMode = "Speed"
                                    print("Speed option clicked") }),
                                SettingsItem.MenuItem(id: "Refresh", title: "实时刷新率", action: {
                                    selectedDisplayMode = "Refresh"
                                    print("Refresh option clicked") }),
                                SettingsItem.MenuItem(id: "Clock", title: "时钟", action: {
                                    selectedDisplayMode = "Clock"
                                    print("Clock option clicked") })
                             ], $selectedDisplayMode))
                
                SettingsItem(icon: .custom(name: "SettingsClock"), title: "时钟格式", subtitle: "格式|时:分:秒:毫秒",
                             buttonType: .customImageButton("OptionsMenu", [
                                SettingsItem.MenuItem(id: "SS-MS", title: "秒:毫秒", action: { selectedClockFormat = "SS-MS" }),
                                SettingsItem.MenuItem(id: "MM-SS-MS", title: "分:秒:毫秒", action: { selectedClockFormat = "MM-SS-MS" }),
                                SettingsItem.MenuItem(id: "HH-MM-SS-MS", title: "时:分:秒:毫秒", action: { selectedClockFormat = "HH-MM-SS-MS" })
                             ], $selectedClockFormat))
            }
            
            HStack(spacing: 20) {
                SettingsItem(icon: .custom(name: "SettingsHourglass"), title: "倒计时", subtitle: "最近事件|茅台",
                             buttonType: .toggle($toggleState_countDown))
                
                SettingsItem(icon: .custom(name: "SettingsIsland"), title: "灵动岛", subtitle: "设备状态|支持",
                             buttonType: .toggle($toggleState_isLand))
            }
        }
        .padding(.top, 40)
    }
}

struct SettingsItem: View {
    var icon: IconType
    var title: String
    var subtitle: String
    var buttonType: ButtonType

    enum IconType {
        case system(name: String)
        case custom(name: String)
    }

    enum ButtonType {
        case toggle(Binding<Bool>)
        case systemImageButton(String, () -> Void)
        case customImageButton(String, [MenuItem], Binding<String?>)
    }
    
    struct MenuItem: Identifiable {
        let id: String
        let title: String
        let action: () -> Void
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                switch icon {
                case .system(let name):
                    Image(systemName: name)
                        .resizable()
                        .frame(width: 40, height: 40)
                case .custom(let name):
                    Image(name)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Spacer()
                switch buttonType {
                case .toggle(let isOn):
                    Toggle("", isOn: isOn)
                        .labelsHidden()
                case .systemImageButton(let imageName, let action):
                    Button(action: action) {
                        Image(systemName: imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                case .customImageButton(let imageName, let menuItems, let selectedOption):
                    Menu {
                        ForEach(menuItems) { item in
                            Button(action: {
                                item.action()
                                selectedOption.wrappedValue = item.id
                            }) {
                                HStack {
                                    Text(item.title)
                                    Spacer()
                                    if selectedOption.wrappedValue == item.id {
                                        Image("Check")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray6)))
        .shadow(radius: 5)
        .frame(width: 160, height: 100)
    }
}



#Preview {
    MainContentView()
}
