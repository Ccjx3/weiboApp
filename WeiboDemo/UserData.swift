//
//  UserData.swift
//  WeiboDemo
//
//  Created by cjx on 2026/1/12.
//
import Combine
import Foundation

//定义环境对象
class UserData: ObservableObject{//包含微博列表属性
    @Published var recommendPostList: PostList = PostList(list: [])
    @Published var hotPostList: PostList = PostList(list: [])
    @Published var isRefreshing: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var loadingError: Error?
    @Published var reloadData: Bool = false
    
    private var recommendPostDic: [Int: Int] = [:] // id: Index
    private var hotPostDic: [Int: Int] = [:]
}

//定义枚举数据类型
enum PostListCategory {
    case recommend, hot
}


extension  UserData {
    static let testData: UserData = {
        let data = UserData()
        data.handleRefreshPostList(loadPostListData("PostListData_recommend_1.json"), for: .recommend)
        data.handleRefreshPostList(loadPostListData("PostListData_hot_1.json"), for: .hot)
        return data
    }()
    
    var showLoading: Bool { loadingError != nil}
    var loadingErrorText: String { loadingError?.localizedDescription ?? "" }
    
    
    func postList(for category: PostListCategory) -> PostList { // 外部名：for 内部名：category
        switch category {
        case .recommend: return recommendPostList
        case .hot: return hotPostList
        }
    }
    
    func loadPostListIfNeeded(for category: PostListCategory) {
        if postList(for: category).list.isEmpty {
            refreshPostlist(for: category)
        }
        
    }
    
    func refreshPostlist(for category: PostListCategory) {
        let completion: (Result<PostList, Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleRefreshPostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            self.isRefreshing = false
        }
        
        switch category{
        case .recommend:
            NetworkAPI.recommendPostList(completion: completion)
        case .hot:
            NetworkAPI.hotPostList(completion: completion)
        }
    }
    
    func loadMorePostList(for category: PostListCategory) {
        if isLoadingMore || postList(for: category).list.count > 10 { return }
        isLoadingMore = true
        
        let completion: (Result<PostList, Error>) -> Void = { result in
            switch result {
            case let .success(list): self.handleLoadMorePostList(list, for: category)
            case let .failure(error): self .handleLoadingError(error)
            }
            self.isLoadingMore = false
        }
        switch category {
        case .recommend:
            NetworkAPI.hotPostList(completion: completion)
        case .hot:
            NetworkAPI.recommendPostList(completion: completion)
        }
    }
    
    private func handleRefreshPostList(_ list: PostList, for category: PostListCategory) {
        //去重
        var tempList: [Post] = []
        var tempDic: [Int : Int] = [:]
        for (index, post) in list.list.enumerated() {
            //如果重复
            if tempDic[post.id] != nil { continue }
            //存储
            tempList.append(post)
            tempDic[post.id] = index
            update(post)
        }
        switch category {
        case .recommend:
            recommendPostList.list = tempList
            recommendPostDic = tempDic
        case .hot:
            hotPostList.list = tempList
            hotPostDic = tempDic
        }
        reloadData = true
        
    }
    
    
    private func handleLoadMorePostList(_ list: PostList, for category: PostListCategory) {
        switch category {
        case .recommend:
            for post in  list.list {
                update(post)
                if recommendPostDic[post.id] != nil { continue }
                recommendPostList.list.append(post)
                recommendPostDic[post.id] = recommendPostList.list.count - 1
            }
        case .hot:
            for post in list.list {
                update(post)
                if hotPostDic[post.id] != nil { continue }
                hotPostList.list.append(post)
                hotPostDic[post.id] = hotPostList.list.count - 1
            }
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        loadingError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingError = nil
            
        }
        
    }
    
    func post(forId id: Int)-> Post? {
        //index: Int?
        if let index = recommendPostDic[id] {
            return recommendPostList.list[index]
        }
        
        if let index = hotPostDic[id] {
            return hotPostList.list[index]
        }
        return nil
    }
    
    func update(_ post: Post) {
        if let index = recommendPostDic[post.id] {
            recommendPostList.list[index] = post
        }
        
        if let index = hotPostDic[post.id] {
            hotPostList.list[index] = post
        }
    }
}
