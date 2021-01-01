import SwiftUI

class ImageLoader: ObservableObject {
    @Published var downloadedData: Data?
    
    func downloadImage(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.downloadedData = data
            }
        }.resume()
    }
}

struct URLImage: View {
    let url: String
    let placeholder: String
    @ObservedObject var imageLoader = ImageLoader()
    init(url:String, placeholder: String = "placeholder"){
        self.url = url
        self.placeholder = placeholder
        self.imageLoader.downloadImage(url: self.url)
    }
    
    var body: some View {
        if let data = self.imageLoader.downloadedData {
            return Image(uiImage: UIImage(data: data)!).renderingMode(.original).resizable()
        } else {
            return Image("Color1")
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(url:"http://18.218.78.71:8080/images/5fdb9a03ae921a507c9785d5")
    }
}
