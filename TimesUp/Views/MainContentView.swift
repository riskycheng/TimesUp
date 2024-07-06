import SwiftUI

struct MainContentView: View {
    var body: some View {
        VStack {
            HeaderView()
            TimerView()
            ControlButton()
            SettingsGrid()
            Spacer()
        }
        .padding()
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("抢购时钟")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "timer")
                .resizable()
                .frame(width: 40, height: 40)
        }
        .padding()
    }
}

struct TimerView: View {
    @State private var currentTime = Date()
    
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
            
            HStack {
                ZStack {
                    Image("CalendarEmpty")
                        .resizable()
                        .frame(width: 90, height: 90) // Increase size of the calendar icon
                    Text(currentDayFormatted)
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(.leading, -10)
                
                Text(currentTimeFormatted)
                    .font(.system(size: 30, weight: .medium, design: .monospaced))
            }
            .padding()
            .foregroundColor(.white)
        }
        .padding()
        .onReceive(timer) { input in
            self.currentTime = input
        }
    }
    
    private var currentTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.S"
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
    @State private var toggleState_countDown = true
    @State private var toggleState_isLand = true
    var body: some View {
        VStack(spacing: 60) {
            HStack(spacing: 20) {
                
                SettingsItem(icon: .custom(name: "SettingsDisplayMode"), title: "显示内容", subtitle: "时钟",
                             buttonType: .customImageButton("OptionsMenu", [
                                SettingsItem.MenuItem(title: "Speed", icon: .system(name: "speedometer"), action: { print("Speed option clicked") }),
                                SettingsItem.MenuItem(title: "Refresh", icon: .system(name: "arrow.clockwise"), action: { print("Refresh option clicked") }),
                                SettingsItem.MenuItem(title: "Clock", icon: .system(name: "clock"), action: { print("Clock option clicked") })
                             ]))
                
                SettingsItem(icon: .custom(name: "SettingsClock"), title: "时钟格式", subtitle: "格式|时:分:秒:毫秒",
                             buttonType: .customImageButton("OptionsMenu", [
                                SettingsItem.MenuItem(title: "MS", icon: .custom(name: "SettingsClock"), action: { print("MS option clicked") }),
                                SettingsItem.MenuItem(title: "SS-MS", icon: .custom(name: "SettingsClock"), action: { print("SS-MS option clicked") }),
                                SettingsItem.MenuItem(title: "MM-SS-MS", icon: .custom(name: "SettingsClock"), action: { print("MM-SS-MS option clicked") }),
                                SettingsItem.MenuItem(title: "HH-MM-SS-MS", icon: .custom(name: "SettingsClock"), action: { print("HH-MM-SS-MS option clicked") })
                             ]))
                
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
        case customImageButton(String, [MenuItem])
    }
    
    struct MenuItem {
        let title: String
        let icon: IconType?
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
                case .customImageButton(let imageName, let menuItems):
                    Menu {
                        ForEach(menuItems, id: \.title) { item in
                            Button(action: item.action) {
                                if let icon = item.icon {
                                    switch icon {
                                    case .system(let name):
                                        Label(item.title, systemImage: name)
                                    case .custom(let name):
                                        HStack {
                                            Image(name)
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Text(item.title)
                                        }
                                    }
                                } else {
                                    Text(item.title)
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
