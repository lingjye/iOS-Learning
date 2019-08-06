//
//  Additions.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/5.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    // Kingfisher
    func mk_setImage(urlString: String?, placeholaderIamge: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
            let url = URL(string: urlString)
            else {
                image = placeholaderIamge
                return
            }
        let processor = DownsamplingImageProcessor(size: self.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

extension UIImageView {
    /// 设置图片圆角
    func circleImage() {
        /// 建立上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        /// 获取当前上下文
        let ctx = UIGraphicsGetCurrentContext()
        /// 添加一个圆，并裁剪
        ctx?.addEllipse(in: self.bounds)
        ctx?.clip()
        /// 绘制图像
        self.draw(self.bounds)
        /// 获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        /// 关闭上下文
        UIGraphicsEndImageContext()
        DispatchQueue.global().async {
            self.image = image
        }
    }
    
}
