//
//  ViewController.swift
//  HowlRealm
//
//  Created by 유명식 on 2018. 4. 10..
//  Copyright © 2018년 유명식. All rights reserved.
//

import UIKit
import RealmSwift
class Cart :Object{
    @objc dynamic var name = ""
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var textfield: UITextField!
    @IBAction func button(_ sender: Any) {
        
        let cart = Cart()
        cart.name = textfield.text!
        try! realm?.write {
            realm?.add(cart)
        }
    }
    @IBOutlet weak var tableview: UITableView!
    var notificationToken : NotificationToken?
    var realm:Realm?
    var items:Results<Cart>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = items![indexPath.row].name
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Migration 이 필요할때 데이터베이스 초기화
        let config = Realm.Configuration( deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
        
        //Cart 데이터들을 수집하는 코드 입니다.
        items = realm?.objects(Cart.self)
        
        //Push Driven 작동 시키는 코드
        notificationToken = realm?.observe({ (noti, realm) in
            self.tableview.reloadData()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

