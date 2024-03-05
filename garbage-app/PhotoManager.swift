import UIKit

public class PhotoManager {
    fileprivate static let mediaDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "media")

    public static func setup() {
        do {
            try FileManager.default.createDirectory(at: PhotoManager.mediaDir, withIntermediateDirectories: true, attributes: nil)
            print("Created directory \(PhotoManager.mediaDir)")
        } catch {
            fatalError("Error creating media directory \(error.localizedDescription)")
        }
    }

    public static func addPhoto(image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "io.ecn.garbage-app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error encoding image as JPEG"])
        }

        let name = "\(UUID().uuidString).jpg"
        let path = PhotoManager.mediaDir.appending(path: name)
        try data.write(to: path)

        return name
    }

    public static func getPhoto(name: String?) -> UIImage? {
        if name == nil {
            return nil
        }

        let path = PhotoManager.mediaDir.appending(path: name!)

        guard let data = try? Data(contentsOf: path) else {
            print("No image with name \(name!)")
            return nil
        }

        return UIImage(data: data)
    }

    public static func deletePhoto(name: String?) {
        if name == nil {
            return
        }

        try? FileManager.default.removeItem(at: PhotoManager.mediaDir.appending(path: name!))
    }
}
