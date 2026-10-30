import SwiftUI

enum AppTab {
    case map
    case list
}

struct AppTabBar: View {

    @Binding var selection: AppTab
    let onAdd: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabItem(.map, icon: "map", title: "Mapa")
            addButton
            tabItem(.list, icon: "list.bullet", title: "Lista")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.cream, in: Capsule())
        .padding(.horizontal, 20)
    }

    private func tabItem(_ tab: AppTab, icon: String, title: String) -> some View {
        Button {
            selection = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .frame(height: 22)
                Text(title)
                    .font(.system(size: 11))
            }
            .foregroundStyle(selection == tab ? Color.primary : Color.secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var addButton: some View {
        VStack(spacing: 4) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 26))
                    .foregroundStyle(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.cream, in: Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .buttonStyle(.plain)
            .padding(.vertical, -19)
            .offset(y: -22)

            Text("Dodaj")
                .font(.system(size: 11))
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var tab: AppTab = .map
    return AppTabBar(selection: $tab, onAdd: {})
        .padding(.top, 60)
}
