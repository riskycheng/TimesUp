import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1 // Default to the 2nd tab

    var body: some View {
        TabView(selection: $selectedTab) {
            // TAB - A
            VStack {
                MainContentView(selectedTab: $selectedTab)
            }
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text(K.TAB_NAME_TAB_1)
                }
            }
            .tag(1)

            // TAB - B
            VStack {
                ListContentView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "alarm.fill")
                    Text(K.TAB_NAME_TAB_2)
                }
            }
            .tag(2)

            // TAB - C
            VStack {
                SettingsContentView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "gearshape.fill")
                    Text(K.TAB_NAME_TAB_3)
                }
            }
            .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
