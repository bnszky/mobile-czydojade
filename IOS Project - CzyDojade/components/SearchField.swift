import SwiftUI

struct SearchField: View {

    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: Theme.Spacing.rowMeta) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Wyczyść wyszukiwanie")
            }
        }
        .padding(.horizontal, Theme.Spacing.chipHorizontal)
        .frame(height: Theme.Size.searchField)
        .background(Theme.Colors.fieldBackground, in: Capsule())
    }
}

#Preview {
    @Previewable @State var text = ""
    SearchField(placeholder: "Adres, linia lub numer pojazdu", text: $text)
        .padding()
}
