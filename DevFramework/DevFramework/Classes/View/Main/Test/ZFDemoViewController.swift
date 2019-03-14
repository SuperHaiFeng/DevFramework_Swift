//
//  ZFDemoViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFDemoViewController: ZFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(navigationController?.childViewControllers.count ?? 0)"
        
    }

    @objc private func showNext(){
        let vc = ZFDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    enum Suit: Int{
        case spades, heards, diamonds, clubs
        func simpleDescription() -> String {
            switch self {
            case .spades:
                return "spades"
            case .heards:
                return "heards"
            case .diamonds:
                return "diamonds"
            default:
                return String(self.rawValue)
            }
        }
    }
    
    func setSuit() {
        let hearts = Suit.heards
        let description = hearts.simpleDescription()
        print(description)
        if let suit = Suit(rawValue: 3) {
            let des = suit.simpleDescription()
            print(des)
        }
    }
    
    enum ServerResponse {
        case result(String,String)
        case failure(String)
        func simpleDescription() -> String {
            switch self {
            case .result("1", ""):
                return "result"
            case .failure(""):
                return "failure"
            default:
                return ""
            }
        }
    }
    
    func setResponse() {
        _ = ServerResponse.result("6:00", "8:00")
        _ = ServerResponse.failure("out of server")
    }
    
    struct Card {
        var suit: Suit
        var server: ServerResponse
        func simpleDescription() -> String {
            return "The \(suit.simpleDescription()) of \(server.simpleDescription())"
        }
    }
    
    func testCard() {
        let threeOfSpades = Card(suit: .heards, server: .result("1", ""))
        let threeOfDescription = threeOfSpades.simpleDescription()
        print(threeOfDescription)
    }
    
}

protocol ExampleProtocol {
    var simpleDescription: String {get}
    mutating func adjust()
}

class simpleClass: ExampleProtocol {
    var simpleDescription: String = "a very simple class"
    
    func adjust() {
        simpleDescription += "now 100% adjust"
    }
}

struct simpleStruct: ExampleProtocol {
    var simpleDescription: String = "a simple struct"
    
    mutating func adjust() {
        simpleDescription += "adjust"
    }
}

extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "the number is \(self)"
    }
    mutating func adjust() {
        self += 2
    }
}

extension ZFDemoViewController {
    override func setupTableView() {
        super.setupTableView()
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", image: nil, horizontalAlignment: .right, target: self, action: #selector(showNext))
    }
}
