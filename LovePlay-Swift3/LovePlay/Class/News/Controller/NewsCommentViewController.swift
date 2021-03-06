//
//  NewsCommentViewController.swift
//  LovePlay
//
//  Created by weiying on 2017/5/19.
//  Copyright © 2017年 yuns. All rights reserved.
//

import UIKit
import Alamofire

class NewsCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var commentModel : NewsCommentModel?
    var hotCommentData : NewsCommentModel?
    var latestCommentData : NewsCommentModel?
    fileprivate var _newsID : String?
    var newsID : String? {
        set {
            _newsID = newValue
        }
        
        get {
            return _newsID
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubViews()
        self.loadData()
    }
    
    // MARK: - private
    private func addSubViews() {
        
        self.view.addSubview(self.tableView)
    }
    
    private func loadData() {
        self.loadHotCommentData()
        self.loadLatestCommentData()
    }
    
    // 请求热门评论
    private func loadHotCommentData() {
        let urlStr = BaseURL + NewsHotCommentURL + "/\(_newsID!)/0/10/11/2/2"
        Alamofire.request(urlStr).responseJSON { response in
            switch response.result.isSuccess{
            case true:
                if let value = response.result.value as? NSDictionary{
                    if let commentModel = NewsCommentModel.deserialize(from: value) {
//                        print(commentModel.commentIdsSB!)
//                        print(commentModel.commentsSB!)
                        self.hotCommentData = commentModel;
                    }
                }
                
                // 刷新列表
                self.tableView.reloadData()
            case false:
                print(response.result.error as Any)
            }
        }
    }
    
    // 请求最新评论
    private func loadLatestCommentData() {
        let urlStr = BaseURL + NewsLatestCommentURL + "/\(_newsID!)/0/10/6/2/2"
        Alamofire.request(urlStr).responseJSON { response in
            switch response.result.isSuccess{
            case true:
                if let value = response.result.value as? NSDictionary{
                    if let commentModel = NewsCommentModel.deserialize(from: value) {
                        self.latestCommentData = commentModel;
                    }
                }
                // 刷新列表
                self.tableView.reloadData()
            case false:
                print(response.result.error as Any)
            }
        }
    }

    // MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let commentIds = self.hotCommentData?.commentIds {
                return commentIds.count
            }
            return 0
        case 1:
            if let commentIds = self.latestCommentData?.commentIds {
                return commentIds.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCommentCell.cellWithTableView(tableView: tableView)
        
        if 0 == indexPath.section {
            if self.hotCommentData?.commentIds != nil {
                cell.setupComment(commentItems: (self.hotCommentData?.commentsSB)!, commmentIds: self.hotCommentData?.commentIdsSB![indexPath.row] as! NSArray)
            }
            
        }else{
            if self.latestCommentData?.commentIds != nil {
                cell.setupComment(commentItems: (self.latestCommentData?.commentsSB)!, commmentIds: self.latestCommentData?.commentIdsSB![indexPath.row] as! NSArray)
            }
        }
        
        return cell
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NewsSectionHeaderView.sectionHeaderWithTableView(tableView: tableView)
        switch section {
        case 0:
            header.titleText = "热门跟帖"
        case 1:
            header.titleText = "最新跟帖"
        default:
            header.titleText = ""
        }
        return header
    }
    
    
    // MARK: - lazy load
    lazy var tableView : UITableView = {
        let detailTableView = UITableView(frame: self.view.bounds, style: .grouped)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.separatorStyle = .none
        detailTableView.estimatedRowHeight = 60
        detailTableView.rowHeight = UITableViewAutomaticDimension
        return detailTableView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
