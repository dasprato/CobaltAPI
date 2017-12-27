//
//  ViewController.swift
//  JSONParsingLBTA
//
//  Created by Prato Das on 2017-12-24.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id: String
    let code: String
    let name: String
    let description: String
    let division: String
    let department: String
    let prerequisites: String
    let exclusions: String
    let campus: String
    let term: String
    let level: Int
    let breadths: [Int]
    let meeting_sections: [MeetingSection]
}

struct MeetingSection: Decodable {
    let code: String
    let size: Int
    let enrolment: Int
    let instructors: [String]
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UITextField!
    var jsonUrl = "https://cobalt.qas.im/api/1.0/courses/filter?key=(InsertAPIkey)&q=code:"
    var courseCode = ""
    var coursesForDataSource = [Course]()
    
    
    fileprivate func fetchUsers() {
        guard let url = URL(string: jsonUrl + courseCode + "&limit=100") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            self.coursesForDataSource.removeAll()
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                for eachitem in courses {
                    if eachitem.code.lowercased().hasPrefix(self.courseCode) {
                        self.coursesForDataSource.append(eachitem)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor(red: 0, green: 45/255, blue: 103/255, alpha: 1)
        
        if searchView.text?.isEmpty == false {
            courseCode = searchView.text!
        }

        fetchUsers()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.keyboardDismissMode = .onDrag
        
        searchView.addTarget(self, action: #selector(allChangingTextField), for: .allEditingEvents)
    }
    
    
    @objc func allChangingTextField() {
        if searchView.text?.isEmpty == false {
            courseCode = searchView.text!
        }
        fetchUsers()
    }

    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesForDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row < coursesForDataSource.count {
            cell.textLabel?.text = coursesForDataSource[indexPath.row].code
            cell.backgroundColor = UIColor(red: 0, green: 45/255, blue: 103/255, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
            cell.selectionStyle = .blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "detailsVCID") as! DetailsViewController
        self.present(detailsVC, animated: true, completion: nil)
        detailsVC.detailsNavBar.topItem?.title = coursesForDataSource[indexPath.row].code
//        let id: String
//        let code: String
//        let name: String
//        let description: String
//        let division: String
//        let department: String
//        let prerequisites: String
//        let exclusions: String
//        let campus: String
//        let term: String

        detailsVC.detailsText.text = "Id: " + coursesForDataSource[indexPath.row].id + "\n"  + "\n" +
                                    "Code: " + coursesForDataSource[indexPath.row].code + "\n" + "\n" +
                                    "Name: " + coursesForDataSource[indexPath.row].name + "\n" + "\n" +
            "Description: " + coursesForDataSource[indexPath.row].description + "\n" + "\n" +
            "Division: " + coursesForDataSource[indexPath.row].division + "\n" + "\n" +
            "Department: " + coursesForDataSource[indexPath.row].department + "\n" + "\n" +
            "Prerequisites: " + coursesForDataSource[indexPath.row].prerequisites + "\n" + "\n" +
            "Exclusions: " + coursesForDataSource[indexPath.row].exclusions + "\n" + "\n" +
            "Level: " + String(describing: coursesForDataSource[indexPath.row].level) + "\n" + "\n" +
            "Campus: " + coursesForDataSource[indexPath.row].campus + "\n" + "\n" +
            "Term: " + coursesForDataSource[indexPath.row].term + "\n" + "\n" +
            "Breadths: " + String(describing: coursesForDataSource[indexPath.row].breadths) + "\n" + "\n" +
        "Meeting Sections: " + String(describing: coursesForDataSource[indexPath.row].meeting_sections)


        
        detailsVC.detailsText.textAlignment = .center
        detailsVC.detailsText.font = UIFont.boldSystemFont(ofSize: (detailsVC.detailsText.font?.pointSize)! + 2)
    
    }
    
}

