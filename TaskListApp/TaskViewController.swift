//
//  TaskViewController.swift
//  TaskListApp
//
//  Created by Max Franz Immelmann on 2/27/23.
//

import UIKit

class TaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Task"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(taskTextField)
    }
}
