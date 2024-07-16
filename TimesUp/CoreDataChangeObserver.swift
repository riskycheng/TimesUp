import SwiftUI
import CoreData

struct CoreDataChangeObserver: ViewModifier {
    @Environment(\.managedObjectContext) private var viewContext
    let onChange: () -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewContext)) { _ in
                onChange()
            }
    }
}

extension View {
    func onCoreDataChange(perform action: @escaping () -> Void) -> some View {
        self.modifier(CoreDataChangeObserver(onChange: action))
    }
}
