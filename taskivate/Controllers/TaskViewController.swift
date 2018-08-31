//
//  TaskViewController.swift
//  taskivate
//
//  Created by Neil Baron on 5/4/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Firebase
import FirebaseAuthUI

class TaskViewController: BaseTableViewController<TaskTableCell, Task> {
   
    
    var startDate: Date!
    var endDate: Date!
    var lastDate: Date!
    var loadInProgress = true
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "My Tasks"
       
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshTasks), for: .valueChanged)
        
        refreshControl?.beginRefreshing()
        initialize()
        fetchTasks(startDate: startDate, endDate: endDate)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let last = items.count - 1
        if(!loadInProgress && indexPath.row == last) {
         //  fetchNextDay()
        }
        
    }

    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard loadInProgress else { return false }
        return indexPath.row == self.items.count
    }
    
    func initialize() {
        tableView.tableFooterView = UIView()
        startDate = DateUtils.getStartOfDay()
        endDate = DateUtils.getEndOfWeek(startOfDay: startDate)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSaveTask(_:)), name: .didSaveTaskNotification, object: nil)
        
    }
    
    @objc func onDidSaveTask(_ notification:Notification) {
        fetchTasks(startDate: startDate, endDate: endDate)
    }
   
    @objc func refreshTasks() {
        fetchTasks(refresh: true, startDate: startDate, endDate: endDate)
    }
    
    func fetchNextDay() {
        startDate = endDate
        endDate = DateUtils.getEndOfWeek(startOfDay: startDate)
        SwiftyBeaver.info("start date \(startDate)")
        SwiftyBeaver.info("end date \(endDate)")
       
        fetchTasks(startDate: startDate, endDate: endDate)
    }
    
    func fetchTasks(refresh: Bool = false, startDate: Date, endDate: Date) {
        if let id = Auth.auth().currentUser?.uid {
            let startOfDay = DateUtils.getStartOfDay()
            loadInProgress = true
            TaskAPI.fetchTasksByDate(uid: id, startDate: startOfDay, endDate: endDate, completion: { (tasks, error) in
                if let err = error {
                    SwiftyBeaver.error("error \(err)")
                } else {
                    DispatchQueue.main.async {
                        for task in tasks {
                            if !self.items.contains(task) {
                                self.items.append(task)
                            }
                        }
                        
                      self.loadInProgress = tasks.isEmpty
                      self.refreshControl?.endRefreshing()
                      self.tableView.reloadData()
                       
                    }
                }
                
            })
            
        }
        
        loadInProgress = false
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
