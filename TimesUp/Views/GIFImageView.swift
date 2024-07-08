import SwiftUI
import SwiftyGif

struct GIFImageView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView() // Create a container UIView
        containerView.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Ensure the content mode is set to scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        containerView.addSubview(imageView)
        
        // Set constraints to ensure the imageView fills the containerView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let gifData = NSDataAsset(name: gifName)?.data {
            do {
                let gifImage = try UIImage(gifData: gifData)
                if let imageView = uiView.subviews.first as? UIImageView {
                    imageView.setGifImage(gifImage)
                }
            } catch {
                print("Failed to load GIF: \(error)")
            }
        } else {
            print("GIF file not found in assets")
        }
    }
}

struct GIFImageView_Previews: PreviewProvider {
    static var previews: some View {
        GIFImageView(gifName: "Anim_StopWatch") // Use the name without the .gif extension
    }
}
