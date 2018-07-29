//
//  InputViewController.swift
//  taskapp
//
//  Created by tatsuya ohyama on 2018/07/28.
//  Copyright © 2018年 tatsuya.ohyama. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var task: Task!
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        categoryTextField.text = task.category
        contentsTextView.text = task.contents
        datePicker.date = task.date

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("/---------------")
            }
        }
    }
    
    @IBAction func taskSaveButton(_ sender: Any) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //保存ボタンを押した時にタイトルが未入力ならアラートを出す
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "未入力", message: "タイトルが入力されていません", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel) { (action: UIAlertAction) in
                print("Cancel")
            }
            alert.addAction(okButton)
            
            present(alert, animated: true, completion: nil)
            return false
        } else {
            //タイトルが入力済みなら保存してタスク一覧画面に戻る
            try! realm.write {
                self.task.title = self.titleTextField.text!
                self.task.category = self.categoryTextField.text!
                self.task.contents = self.contentsTextView.text!
                self.task.date = self.datePicker.date
                
                self.realm.add(self.task, update: true)
            }
            setNotification(task: task)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
