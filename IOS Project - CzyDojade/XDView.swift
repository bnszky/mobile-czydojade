import SwiftUI
import Playgrounds

struct XDView : View {
    
    var imageUrl: String = "https://visitwroclaw.eu/wp-content/uploads/2025/07/Wroclaw-z-tramwajem-1.png"
    var title: String = "title"
    var description: String = "to jest tytuł"
    
    var body: some View {
        ZStack(){
            AsyncImage(url: URL(string: imageUrl)).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Apka")
                    NavigationLink("Start") {
                        DetailView()
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(
//                    AsyncImage(url: URL(string: imageUrl)).ignoresSafeArea()
                .clipped().ignoresSafeArea()
                
//                NavigationStack {
//                    VStack(spacing: 20) {
//                        Text("Ekran")
//                        
//                        NavigationLink("Przejdz") {
//                            DetailView()
//                        }.buttonStyle(.borderedProminent)
//                            .navigationTitle("Start")
//                    }
//                }
                //            HStack(spacing: 8){
                //                Text(title)
                //                Text(description)
                //            }
        }
    }
}

#Preview {
    XDView()
}

#Playground {
    _ = 1 + 2
}
