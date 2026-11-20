import UIKit

enum ImageCompressor {

    enum Limits {
        static let maxDimension: CGFloat = 1600
        static let jpegQuality: CGFloat = 0.8
    }

    static func compressedJPEG(from data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        let longestSide = max(image.size.width, image.size.height)
        let scale = min(1, Limits.maxDimension / longestSide)
        let targetSize = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )

        let resized = image.preparingThumbnail(of: targetSize) ?? image
        return resized.jpegData(compressionQuality: Limits.jpegQuality)
    }
}
