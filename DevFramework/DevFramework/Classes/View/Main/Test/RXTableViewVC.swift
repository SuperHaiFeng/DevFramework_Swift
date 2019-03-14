//
//  RXTableViewVC.swift
//  DevFramework
//
//  Created by 张志方 on 2018/9/28.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RXTableViewVC: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RXSwiftTableView"
        
        self.setTableView()
        self.baseUsage()
//        self.rxDataSourceWithSelf()
//        self.rxDataSourceWithDefine()
//        self.sectionWithSelf()
//        self.sectionWithDefine()
    }
    
    func setTableView() {
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
    }
}

extension RXTableViewVC {
    func baseUsage() {
        let items = Observable.just([
            "控件的使用",
            "手势的使用",
            "进度条的用法",
            "标签的用法"
            ])
        //设置单元格数据
        items
            .bind(to: tableView.rx.items) {(tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(row):\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext:{indexPath in
            print("选中\(indexPath.row)")
            switch indexPath.row{
                case 0:
                    self.navigationController?.pushViewController(ZFTraitsVC(), animated: true)
                break
                case 1:
                    self.navigationController?.pushViewController(RXCircleVC(), animated: true)
                break
            default: break
                
            }
        })
        .disposed(by: disposeBag)
        tableView.rx.modelSelected(String.self).subscribe(onNext:{item in
            print("选中的标题\(item)")
        })
        .disposed(by: disposeBag)
        //单元格删除事件响应
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .middle)
        })
        .disposed(by: disposeBag)
        //单元格移动事件响应
        tableView.rx.itemMoved.subscribe(onNext:{sourceIndexPath, destinationIndexPath in
            
        })
        .disposed(by: disposeBag)
        //单元格插入事件响应
        tableView.rx.itemInserted.subscribe(onNext:{indexPath in
            
        }).disposed(by: disposeBag)
    }
    //使用自带的section
    func rxDataSourceWithSelf() {
        let items = Observable.just([
            SectionModel(model: "", items: [
                "UILable用法",
                "UIText",
                "UIButton"
                ])
            ])
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: { (dataSource, tv, indexPath, element)  in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(indexPath.row)  \(element)"
            return cell
        })
        
        //绑定单元格数据
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    //使用自定义的section
    func rxDataSourceWithDefine() {
        let sections = Observable.just([
            MySection(header: "", items: [
                "UILable用法",
                "UIText",
                "UIButton"
                ])
            ])
        //数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            //设置单元格
            configureCell: {ds, tv, indexPath, element in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(indexPath.row)  \(element)"
                return cell
        })
        //绑定单元格
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    //多分区的tableview
    //使用自带的分区
    func sectionWithSelf() {
        let items = Observable.just([
            SectionModel(model: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            SectionModel(model: "高级控件", items: [
                "UITableView的用法",
                "UICollectionView的用法",
                ])
            ])
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (ds, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(indexPath.row) \(element)"
            return cell
        })
        
        
        //设置分区头
        dataSource.titleForHeaderInSection = {ds , index in
            return ds.sectionModels[index].model
        }
        
        //绑定单元格数据
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    //使用自定义个section
    func sectionWithDefine()  {
        let sections = Observable.just([
            MySection(header: "基本控件", items: [
                "UILable",
                "UIText",
                "UIButton"
                ]),
            MySection(header: "高级控件", items: [
                "UITableView",
                "UICollectionView",
                ])
            ])
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(configureCell: { ds, tv, indexPath, element in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(indexPath.row) \(element)"
            return cell
        },
            //设置分区头标题
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        })
        //绑定单元格数据
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

//自定义section
struct MySection {
    var header: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    var identity: String {
        return header
    }
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
