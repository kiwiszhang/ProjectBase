//
//  UIView+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

extension UIImageView {
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    func loadGif(name: String, cropRect: CGRect? = nil, animated: Bool = false, duration: TimeInterval = 0.25) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let path = Bundle.main.path(forResource: name, ofType: "gif"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                  let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                return
            }

            let count = CGImageSourceGetCount(source)
            var images: [UIImage] = []
            var totalDuration: TimeInterval = 0

            // 读取每一帧
            for i in 0 ..< count {
                guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                    continue
                }
                
                // 如果指定了裁剪区域，进行裁剪
                let finalImage: CGImage
                if let rect = cropRect, let croppedImage = cgImage.cropping(to: rect) {
                    finalImage = croppedImage
                } else {
                    finalImage = cgImage
                }

                // 获取帧延迟时间
                guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                      let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                      let duration = gifInfo[kCGImagePropertyGIFDelayTime as String] as? Double else {
                    continue
                }

                totalDuration += duration
                images.append(UIImage(cgImage: finalImage))
            }
            let image = UIImage.animatedImage(with: images, duration: totalDuration)
            DispatchQueue.main.async {
                if animated {
                    UIView.transition(
                        with: self,
                        duration: duration,
                        options: [.transitionCrossDissolve, .curveEaseInOut, .allowUserInteraction]
                    ) {
                        self.image = image
                    }
                } else {
                    self.image = image
                }
            }
        }
    }
}
