import SwiftUI

struct IncidentRow: View {

    let incident: Incident

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.rowContent) {
            CategoryIcon(category: incident.category)

            VStack(alignment: .leading, spacing: Theme.Spacing.rowText) {
                header

                Text(incident.details)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                meta
            }
        }
        .contentShape(Rectangle())
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(incident.location)
                .font(.headline)
                .lineLimit(1)

            Spacer()

            Text(incident.relativeTimeText)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
    }

    private var meta: some View {
        HStack(spacing: Theme.Spacing.rowMeta) {
            Label(incident.line, systemImage: "tram.fill")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.Colors.accent)
                .padding(.horizontal, Theme.Spacing.badge)
                .padding(.vertical, Theme.Spacing.rowText)
                .background(
                    Theme.Colors.accentSoft,
                    in: RoundedRectangle(cornerRadius: Theme.Radius.lineBadge, style: .continuous)
                )

            if !incident.vehicleNumber.isEmpty {
                Text("Pojazd \(incident.vehicleNumber)")
            }

            Text(incident.category.title)
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
}

#Preview {
    List {
        ForEach(Incident.makeSamples()) { incident in
            IncidentRow(incident: incident)
        }
    }
}
