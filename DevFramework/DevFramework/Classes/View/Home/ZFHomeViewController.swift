//
//  ZFHomeViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
///原创cellid
private let originalCellId = "originalCellId"
///被转发可重用的cellid
private let retweetedCellId = "retweetedCellId"

class ZFHomeViewController: ZFBaseViewController {
    
    private lazy var listViewModel = ZFStatusesListViewModel()
    
    @objc private func showFriends(){
        let vc = ZFDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            self.refreshController?.endRefreshing()
            self.isPullup = false
            if shouldRefresh{
                self.tableView?.reloadData()
                self.animateTable()
            }
        }
    }
    

}

extension ZFHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = listViewModel.statusList[indexPath.row]
        let cellid = vm.status.retweeted_status != nil ? retweetedCellId : originalCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ZFStatusCell
        
        cell.viewModel = vm
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DRotate(transform, 0, 0, 0, 1)//渐变
        transform = CATransform3DTranslate(transform, -200, 0, 0)//左边水平移动
        transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
        cell.layer.transform = transform
        cell.layer.opacity = 0.0
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.layer.opacity = 1
        }
    }
    
}

extension ZFHomeViewController {
    override func setupTableView() {
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", image: nil, horizontalAlignment: .left, target: self, action: #selector(showFriends))
        tableView?.register(UINib.init(nibName: "ZFStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib.init(nibName: "ZFStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
    }
}
