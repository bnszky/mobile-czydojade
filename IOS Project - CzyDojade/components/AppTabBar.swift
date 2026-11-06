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
        .padding(.horizontal, Theme.Spacing.tabBarHorizontal)
        .padding(.vertical, Theme.Spacing.tabBarVertical)
        .background(Color.cream, in: Capsule())
        .padding(.horizontal, Theme.Spacing.tabBarOuter)
    }

    private func tabItem(_ tab: AppTab, icon: String, title: String) -> some View {
        Button {
            selection = tab
        } label: {
            VStack(spacing: Theme.Spacing.tabItem) {
                Image(systemName: icon)
                    .font(.system(size: Theme.FontSize.tabIcon))
                    .frame(height: Theme.FontSize.tabIcon)
                Text(title)
                    .font(.system(size: Theme.FontSize.tabLabel))
            }
            .foregroundStyle(selection == tab ? Color.primary : Color.secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var addButton: some View {
        VStack(spacing: Theme.Spacing.tabItem) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: Theme.FontSize.tabAddIcon))
                    .foregroundStyle(.black)
                    .frame(width: Theme.Size.tabAdd, height: Theme.Size.tabAdd)
                    .background(Color.cream, in: Circle())
                    .shadow(
                        color: .black.opacity(Theme.Shadow.lightOpacity),
                        radius: Theme.Shadow.lightRadius,
                        x: 0,
                        y: Theme.Shadow.y
                    )
            }
            .buttonStyle(.plain)
            .padding(.vertical, -19)
            .offset(y: -22)

            Text("Dodaj")
                .font(.system(size: Theme.FontSize.tabLabel))
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
