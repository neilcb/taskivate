//
//  TaskViewController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit

class TaskViewController: BaseTableViewController<TaskTableCell, Task> {
    
    var customElements: [Task]!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Tasks"
       
        items = [
           Task(title: "Run", dueDate: Date(), priority: Task.Priority.medium.rawValue, reminderDate: Date(), category: Task.Category.health.rawValue, repeats: Task.RepeatFrequency.daily.rawValue, image: nil)
            
            
        ]
        initialize()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func initialize() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addTask(_ sender: UIBarButtonItem) {
        let taskViewModel = AddTaskViewController.TaskViewModel(task: Task())
        let addTaskController = AddTaskViewController(taskViewModel: taskViewModel)
        addTaskController.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(addTaskController, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
