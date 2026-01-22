//
//  Post.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/8.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostList: Codable { // 与json相对应：json中为post以list格式存在
    var list: [Post]
}

/* tip:
Data Model的key，要与json中保持一致；可以少，但是不能存在不同，不然解析会出错
*/

//Data Model
struct Post: Codable,Identifiable {
    //Property 属性
    //不可见的
    let id: Int
    let avatar: String// 用户头像
    let vip: Bool//是否为VIP true ， false
    let name: String
    let date: String
    
    var isFollowed: Bool //可变的
    
    let text: String
    let images: [String]
    
    var commentCount: Int
    var likeCount: Int
    var isLiked: Bool
    
}
extension Post:Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Post {
    var avatarImage: some View { loadImage(name: avatar) }
    
    //只读属性
    //计算属性：Calculated Property
    var commentCountText: String {
        if commentCount <= 0 {return "评论"}
        if commentCount < 1000 {return "\(commentCount)"}
        return String(format: "%.1fk", Double(commentCount)/1000)
    }
    
    //
    var likeCountText: String {
        if likeCount <= 0 {return "点赞"}
        if likeCount < 1000 {return "\(likeCount)"}
        return String(format: "%.1fk", Double(likeCount)/1000)
    }
}


//下载微博的数据文件
//
func loadPostListData(_ fileName: String)-> PostList {
    //由于 let url: URL? 是Optional 类型 要做error()判断
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Can not find \(fileName) in main bundle")
    }
    
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Can not load \(url)")
    }
    //解析json
    guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
        fatalError("Can not parse list json data")
    }
    
    return list
}
//加载图片
func loadImage(name: String) -> some View {
    WebImage(url: URL(string: NetworkAPIBaseURL + name)) { image in
        image.resizable()
    } placeholder: {
        Color.gray
    }
        
}

