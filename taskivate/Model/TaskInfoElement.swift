//
//  TaskInfoElement.swift
//  
//
//  Created by Neil Baron on 7/22/18.
//
import Foundation
import UIKit

class TaskInfoElement: CustomElementModel {
    
    var size: CGSize?
    //var image: UIImage?
    var taskName: String
    var taskDescription: String
    var taskDueDate: Date

    var type: CustomElementType { return .task }

    init(taskName: String, taskDescription: String, taskDueDate: Date, size: CGSize = .zero) {
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.taskDueDate = taskDueDate
        self.size = size

    }

}
