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
    
    private lazy var saveButton: UIButton = {
        createButton(withTitle: "Save Task",
                     andColor: UIColor(red: 21/255,
                                       green: 101/255,
                                       blue: 192/255,
                                       alpha: 194/255),
                     action: UIAction { [unowned self] _ in
                        dismiss(animated: true) }
                     )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButton(withTitle: "Cancel",
                     andColor: .orange,
                     action: UIAction { [unowned self] _ in
                        dismiss(animated: true) }
                     )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(
            taskTextField,
            saveButton,
            cancelButton
        )
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
    }
    
    private func createButton(withTitle title: String,
                              andColor color: UIColor,
                              action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString(title,
                                                               attributes: attributes)
        buttonConfiguration.baseBackgroundColor = color
        
        return UIButton(configuration: buttonConfiguration,
                        primaryAction: action)
        
    }
}
