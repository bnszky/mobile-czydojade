import SwiftUI
 
struct LandingView: View {
 
    @State private var viewModel = LandingViewModel()
 
    private let baseColor = Color(red: 0.05, green: 0.08, blue: 0.25)
 
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
 
                VStack(spacing: 12) {
                    Text(viewModel.title)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 3)
 
                    Text(viewModel.description)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 64)
 
                NavigationLink {
                    MapScreenView()
                } label: {
                    Text(viewModel.buttonTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.black)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color(red: 0.98, green: 0.84, blue: 0.5))
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    baseColor
 
                    AsyncImage(url: viewModel.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Color.clear
                        default:
                            ProgressView().tint(.white)
                        }
                    }
 
                    LinearGradient(
                        colors: [baseColor.opacity(0.55), baseColor.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            }
        }
    }
}
 
#Preview {
    LandingView()
}
