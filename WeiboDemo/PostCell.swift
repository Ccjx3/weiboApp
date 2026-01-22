//
//  PostCell.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/8.
//

import SwiftUI

struct PostCell: View {
    //
    let post:Post
    //添加一个只读属性
    var bindingPost: Post {
        userData.post(forId: post.id)!
    }

    @State var presentComment: Bool = false
    
    @EnvironmentObject var userData: UserData
    
    
    var body: some View {
        var post = bindingPost
        return  VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 5) {
                        post.avatarImage
//                            .resizable()
                            .scaledToFit()
                            .frame(width: 50 , height: 50)
                            .clipShape(Circle())
                            .overlay(
                                PostVIPBage(vip: post.vip)
                                    .offset(x:16,y:16)
                            )
                        
                        VStack(alignment: .leading , spacing: 5 ) {
                            Text(post.name)
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(red: 242 / 255, green: 99 / 255, blue: 4 / 255))
                                .lineLimit(1)
                            
                            Text(post.date).font(.system(size: 11))
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        Button(action : {
                            /*还没做与json同步*/
                            if post.isFollowed {
                                post.isFollowed = false
                            } else{
                                post.isFollowed = true
                            }
                            self.userData.update(post)
                            // 这里通常会触发关注逻辑，改变 post.isFollowed 的状态
                        }) {
                            Text(post.isFollowed ? "已关注" : "关注") // 如果需要文字也改变，可以加这一行
                                .font(.system(size: 14))
                                // 1. 动态设置文字颜色
                                .foregroundColor(post.isFollowed ? .gray : .orange)
                                .frame(width: 50, height: 26)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        // 2. 动态设置边框颜色
                                        .stroke(post.isFollowed ? Color.gray : Color.orange, lineWidth: 1)
                                )
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Text(post.text)
                        .font(.system(size: 17))
                        .padding(.top, 8)
                        
                    //展示图片写法
                    if !post.images.isEmpty {
                        PostImageCell(images: post.images, width: UIScreen.main.bounds.width - 30)
                    }
                    
                    //添加一个分隔线
                    Divider()
                    //添加评论按钮和点赞按钮
                    HStack(spacing: 0) {
                        
                        Spacer()
                        
                        PostCellToolbarButton(
                            image: post.isLiked ? "heart.fill" : "heart",
                            text: post.likeCountText,
                            color: post.isLiked ? .red : .black)
                        {
                            if post.isLiked {
                                post.isLiked = false
                                post.likeCount -= 1
                            } else {
                                post.isLiked = true
                                post.likeCount += 1
                            }
                            self.userData.update(post)
                        }
                        
                        Spacer()
                        
                        PostCellToolbarButton(image: "message",
                                              text: post.commentCountText,
                                              color: .black)
                        {
                            self.presentComment = true
                        }
                        .sheet(isPresented: $presentComment) {
                            CommentInputView(post: post)
                        }
                        
                        
                        
                        Spacer()
                        
                        //添加转发button
                        // 方案一：使用侧向转弯箭头（最像转发）
                        PostCellToolbarButton(image: "arrowshape.turn.up.right",
                                              text: "转发",
                                              color: .black)
                        {
                            print("Click repost Button")
                        }
                        
                        Spacer()
                        
                    }
                    //添加浅灰色分割线
                    Rectangle()
                        .padding(.horizontal,-15)
                        .frame(height: 10)
                        .foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
            }
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

#Preview {
    let userData = UserData.testData
    PostCell(post: userData.recommendPostList.list[0])
        .environmentObject(userData)
}
