//
//  PostImageCell.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/12.
//

import SwiftUI
//控制图片间距
private let kImageSapce: CGFloat = 6

struct PostImageCell: View {
    let images: [String]
    let width: CGFloat
    
    var body: some View {
        Group {
            if images.count == 1 {
                loadImage(name: images[0])
//                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width * 0.75)
                    .clipped()
            } else if images.count == 2 {
                PostImageCellRow(images: images, width: width)
            } else if images.count == 3 {
                PostImageCellRow(images: images, width: width)
            } else if images.count == 4 {
                VStack(spacing: kImageSapce) {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...3]), width: width)
                }
            } else if images.count == 5 {
                VStack(spacing: kImageSapce) {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...4]), width: width)
                }
            } else if images.count == 6 {
                VStack(spacing: kImageSapce){
                    PostImageCellRow(images: Array(images[0...2]), width: width)
                    PostImageCellRow(images: Array(images[3...5]), width: width)
                }
            }
            else {
                // 超过 6 张的逻辑（如果需要可以继续扩展）
                Text("更多图片...")
            }
        }
    }
}

struct PostImageCellRow: View {
    let images: [String]
    let width: CGFloat

    var body: some View {
        HStack(spacing: kImageSapce) {
            ForEach(images, id: \.self) { image in
                loadImage(name: image)
//                    .resizable()
                    .scaledToFill()
                    .frame(width: (self.width - 6 * CGFloat(self.images.count - 1)) /
                           CGFloat(self.images.count), height: (self.width - 6 * CGFloat(self.images.count - 1))
                           / CGFloat(self.images.count))
                    .clipped()
            }
        }
    }
    
}

#Preview {
    let userData = UserData.testData
    let images = userData.recommendPostList.list[0].images
    //后面处理UIScreen.main
    let width = UIScreen.main.bounds.width
    return Group {
//        PostImageCell(images: Array(images[0...0]), width: width)
//        PostImageCell(images: Array(images[0...1]), width: width)
        PostImageCell(images: Array(images[0...2]), width: width)
//        PostImageCell(images: Array(images[0...3]), width: width)
//        PostImageCell(images: Array(images[0...4]), width: width)
//        PostImageCell(images: Array(images[0...5]), width: width)
    }
    
}
