//
//  ViewController.swift
//  TodoList
//
//  Created by 桑原望 on 2020/02/14.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import RealmSwift

class ToDo: Object {
      dynamic var name = ""
      dynamic var deadline =  Date(timeIntervalSince1970: 0)
      //完了フラグ
      dynamic var isComplete = false
  }
class ViewController: UIViewController {
    @IBOutlet weak var todoNameText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: Results<ToDo>? {
    do {
    let realm = try Realm()
        return realm.objects(ToDo.self)
    } catch {
    print("エラー")
    }
    return nil
    }
    
    @IBAction func addToDo(_ sender: UIButton) {
    
    //入力チェック
        if isValidateInputContents() == false {
            return
        }
        //ToDoデータを作成する処理
        let toDo = ToDo()
        toDo.name = todoNameText.text!
        
        //ToDoデータを永続化する処理
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toDo)
            }
            todoNameText.text = ""
        } catch {
            print("失敗")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    private func isValidateInputContents() -> Bool {
        //ToDo名のデータ入力
        if let name = todoNameText.text {
            if name.count == 0 {
                return false
            }
        } else {
            return false
        }
        return true
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDo = toDoItems?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ToDoTableViewCell
        //Realmに登録したデータをラベルに値設定
        cell.nameLabel.text = toDo?.name
        
        print(toDo?.name as Any)
        return cell
    }
}
