//
//  AddTaskViewController.swift
//  taskivate
//
//  Created by Neil Baron on 7/22/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Eureka
import Firebase
import FirebaseAuthUI
import NotificationCenter
import ImageRow

class AddTaskViewController: FormViewController {
    var taskViewModel: TaskViewModel!
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter
    }()
    
    convenience init(taskViewModel: TaskViewModel) {
        self.init()
        self.taskViewModel = taskViewModel
        initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Tasks"
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
        
       // let deleteButton = UIBarButtonItem(barButtonSystemItem:., target: self, action: #selector(deleteButtonPressed))
     //   navigationItem.leftBarButtonItem = deleteButton
        
        view.backgroundColor = .white
        
        form
            +++ Section()    //2
            <<< TextRow() { // 3
                $0.title = "Description" //4
                $0.placeholder = "e.g. Pick up my laundry"
                $0.value = taskViewModel.title //5
                $0.onChange { [unowned self] row in //6
                   self.taskViewModel.title = row.value
                }
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
        }
            <<< PushRow<String>() { //1
                $0.title = "Category" //2
                $0.value = taskViewModel.category //3
                $0.options = taskViewModel.categoryOptions //4
                $0.onChange { [unowned self] row in //5
                    if let value = row.value {
                        self.taskViewModel.category = value
                        let subCatRow: PushRow<String>? = self.form.rowBy(tag: "SubCat")
                        subCatRow?.options = self.taskViewModel.getSubCategories(category:value)
                        subCatRow?.value?.removeAll()
                        subCatRow?.updateCell()
                        subCatRow?.reload()
                    }
                }
                
        }
            
            <<< PushRow<String>("SubCat") { //1
                $0.title = "Sub Category" //2
                $0.value = taskViewModel.subCategory //3
                if let category = taskViewModel.category {
                    $0.options = taskViewModel.getSubCategories(category: category)
                }
                $0.onChange { [unowned self] row in //5
                    if let value = row.value {
                        self.taskViewModel.subCategory = value
                    }
                }
                $0.cellSetup{ cell, row in
                    
                }
            }
        
            +++ Section()
            <<< DateTimeRow() {
                $0.dateFormatter = type(of: self).dateFormatter //1
                $0.title = "Due date" //2
                $0.value = taskViewModel.dueDate //3
                $0.minimumDate = Date() //4
                $0.onChange { [unowned self] row in //5
                    if let date = row.value {
                        self.taskViewModel.dueDate = date
                    }
                }
        }
        
            <<< PushRow<String>() { //1
                $0.title = "Repeats" //2
                $0.value = taskViewModel.repeatFrequency //3
                $0.options = taskViewModel.repeatOptions //4
                $0.onChange { [unowned self] row in //5
                    if let value = row.value {
                        self.taskViewModel.repeatFrequency = value
                    }
                }
        }
        
            +++ Section()
            <<< SegmentedRow<String>() {
                $0.title = "Priority"
                $0.value = taskViewModel.priority
                $0.options = taskViewModel.priorityOptions
                $0.onChange { [unowned self] row in
                    if let value = row.value {
                        self.taskViewModel.priority = value
                    }
                }
        }
        
            <<< AlertRow<String>() {
                $0.title = "Reminder"
                $0.selectorTitle = "Remind me"
                $0.value = taskViewModel.reminder
                $0.options = taskViewModel.reminderOptions
                $0.onChange { [unowned self] row in
                    if let value = row.value {
                        self.taskViewModel.reminder = value
                    }
                }
        }
          //  +++ Section("Status")
            <<< SwitchRow("SwitchRow") { row in      // initializer
                row.title = taskViewModel.status
                
                if(taskViewModel.status == Task.Status.inProgress.rawValue) {
                    row.value = false
                } else {
                    row.value = true
                }
               
                }.onChange { row in
                    row.title = (row.value ?? false) ? Task.Status.completed.rawValue : Task.Status.inProgress.rawValue
                    self.taskViewModel.status = row.title!
                    row.updateCell()
                    
                }.cellSetup { cell, row in
                   // cell.backgroundColor = .lightGray
                }.cellUpdate { cell, row in
                   // cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
            }
        
            +++ Section("Picture Attachment")
            <<< ImageRow() {
                $0.title = "Attachment"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera] //1
                $0.value = taskViewModel.image //2
                $0.clearAction = .yes(style: .destructive) //3
                $0.onChange { [unowned self] row in //4
                    self.taskViewModel.image = row.value
                    row.cell.update()
                }
        }
        
        
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
    }
    
    // MARK: - Actions
    @objc fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
        if form.validate().isEmpty {
            if let id = Auth.auth().currentUser?.uid {
                SwiftyBeaver.info(taskViewModel.getTask())
                
                
                TaskAPI.save(uid: id, task: taskViewModel.getTask(), completion:  { (status, error) in
                    if let err = error {
                       SwiftyBeaver.error("error saving task \(err)")
                    } else {
                        SwiftyBeaver.info("task \(String(describing: self.taskViewModel.getTask().title)) saved ok")
                        self.navigationController?.popViewController(animated: true)
                    }
//
               })
                
            } else {
                SwiftyBeaver.info("user is not logged in giong to login controller")
                let loginController = HomeViewController()
                self.navigationController?.pushViewController(loginController, animated: true)
            }
        }
    }
    
    @objc fileprivate func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        
//            let alert = UIAlertController(title: "Delete this item?", message: nil, preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//            let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//              self?.taskViewModel.delete()
//              _ = self?.navigationController?.popViewController(animated: true)
//            }
//
//            alert.addAction(delete)
//            alert.addAction(cancel)
        
 //           navigationController?.present(alert, animated: true, completion: nil)
        
        // Delete this line
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension AddTaskViewController {
    
    class TaskViewModel {
        
        private let task: Task
        
        func getTask() -> Task {
            return self.task
        }
        
        var title: String? {
            get {
                return task.title
            }
            set {
                task.title = newValue
            }
        }
        
        var dueDate: Date {
            get {
                return task.dueDate
            }
            set {
                task.dueDate = newValue
            }
        }
        
        let reminderOptions: [String] = [Task.Reminder.none.rawValue,
                                         Task.Reminder.halfHour.rawValue,
                                         Task.Reminder.oneHour.rawValue,
                                         Task.Reminder.oneDay.rawValue,
                                         Task.Reminder.oneWeek.rawValue]
        var reminder: String? {
            get {
                return task.reminder.rawValue
            }
            set {
                if let value = newValue {
                    task.reminder = Task.Reminder(rawValue: value)!
                }
            }
        }
        
        var image: UIImage? {
            get {
                if let data = task.image {
                    return UIImage(data: data)
                }
                return nil
            }
            set {
                if let img = newValue {
                    task.image = UIImagePNGRepresentation(img)
                } else {
                    task.image = nil
                }
            }
        }
        
        let priorityOptions: [String] = [Task.Priority.low.rawValue,
                                         Task.Priority.medium.rawValue,
                                         Task.Priority.high.rawValue]
        
        var priority: String {
            get {
                return task.priority.rawValue
            }
            set {
                task.priority = Task.Priority(rawValue: newValue)!
            }
        }
        
        var categoryOptions: [String] = [Task.Category.home.rawValue,
                                         Task.Category.work.rawValue,
                                         Task.Category.personal.rawValue,
                                         Task.Category.play.rawValue,
                                         Task.Category.health.rawValue ]
        var category: String? {
            get {
                return task.category?.rawValue
            }
            set {
                if let value = newValue {
                    task.category = Task.Category(rawValue: value)!
                }
            }
        }
        
        var subCategory: String? {
            get {
                return task.subCategory
            }
            set {
                if let value = newValue {
                    task.subCategory = value
                }
            }
        }
        
        
        
       
        
        let repeatOptions: [String] = [Task.RepeatFrequency.never.rawValue,
                                       Task.RepeatFrequency.daily.rawValue,
                                       Task.RepeatFrequency.weekly.rawValue,
                                       Task.RepeatFrequency.monthly.rawValue,
                                       Task.RepeatFrequency.annually.rawValue]
        
        var repeatFrequency: String {
            get {
                return task.repeats.rawValue
            }
            set {
                task.repeats = Task.RepeatFrequency(rawValue: newValue)!
            }
        }
        
        var status: String {
            get {
                return task.status.rawValue
            }
            
            set {
                task.status = Task.Status(rawValue: newValue)!
            }
        }
        
        func getSubCategories(category: String) -> [String] {
            
            switch category {
                
            case Task.Category.home.rawValue:
                return ["Laundry","Clean","Make Bed","Groceries","Organize"]
            case Task.Category.health.rawValue:
                return ["Run","Job","Walk","Swim","Tennis","Weights"]
            case Task.Category.travel.rawValue:
                return ["Plain","Trains","Auto","Bus","Boat","Hotel","Reseverations"]
            default:
                return ["None"]
            }
        }
        
        // MARK: - Life Cycle
        
        init(task: Task) {
            self.task = task
        }
        
        // MARK: - Actions
        
        func delete() {
            NotificationCenter.default.post(name: .deleteTaskNotification, object: nil, userInfo: [ Notification.Name.deleteTaskNotification : task ])
        }
    }
}

   

