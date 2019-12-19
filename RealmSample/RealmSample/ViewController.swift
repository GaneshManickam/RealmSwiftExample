//
//  ViewController.swift
//  RealmSample
//
//  Created by Ganesh Manickam on 21/11/19.
//  Copyright © 2019 Ganesh Manickam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var subTitleField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var primaryKeyField: UITextField!
    @IBOutlet weak var getPrimaryKeyButton: UIButton!
    @IBOutlet weak var primaryKeyValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    fileprivate var realmManager = RealmManager()
    fileprivate var objectToUpdate: NotesItem?

    fileprivate var notes: [NotesItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var isUpdate: Bool = false {
        didSet {
            saveButton.setTitle(isUpdate ? "Update" : "Save", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.configureTableHeight()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotesFromDB()
        print("\(realmManager.realm?.configuration.fileURL)")
    }

    // Function to configure UITableView cell height
    func configureTableHeight() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // Function to register tableview cell
    func registerCell() {
        self.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
    }
    
    // Function to perform save action
    @IBAction func saveAction(_ sender: UIButton) {
        if titleField.text!.isEmpty || subTitleField.text!.isEmpty {
            return
        }
    
        if isUpdate && objectToUpdate != nil {
            isUpdate = false
            // MARK: UPDATE WAY - 1
//            realmManager.realm?.beginWrite()
//            objectToUpdate?.title = titleField.text!
//            objectToUpdate?.subTitle = subTitleField.text!
//            objectToUpdate?.date = Date()
//            try! realmManager.realm?.commitWrite()
            
            // MARK: UPDATE WAY - 2
            let note = NotesItem(id: objectToUpdate!.id, title: titleField.text!, subTitle: subTitleField.text!, date: Date())
            realmManager.updateObject(object: note)
        } else {
            let note = NotesItem(id: realmManager.incrementID(type: NotesItem.self, key: "id"), title: titleField.text!, subTitle: subTitleField.text!, date: Date())
            realmManager.saveObject(object: note)
        }
        self.titleField.text = ""
        self.subTitleField.text = ""
        getNotesFromDB()
    }
    
    // Function to get primarykey value
    @IBAction func getPrimaryKeyValueAction(_ sender: UIButton) {
        self.primaryKeyValueLabel.text = ""
        if primaryKeyField.text!.isEmpty {
            return
        }
        
        guard let primaryKey = Int(primaryKeyField.text!) else {
            return
        }
        
        if let note = realmManager.getObject(type: NotesItem.self, primaryKey: primaryKey) as? NotesItem {
            self.primaryKeyValueLabel.text = "{ id: \(note.id), title: \(note.title), subtitle: \(note.subTitle), date: \(note.date) }"
        }
    }
    
    // Function to get all notes
    func getNotesFromDB() {
        var tempNotes: [NotesItem] = []
        if let results = realmManager.getObjects(type: NotesItem.self) {
            for item in results {
                if let noteItem = item as? NotesItem {
                    tempNotes.append(noteItem)
                }
            }
        }
        self.notes = tempNotes
        print("Total Items: \(self.notes)")
    }
    
    // Function to perform update action
    @objc func editAction(_ sender: UIButton) {
        objectToUpdate = notes[sender.tag]
        titleField.text = objectToUpdate?.title ?? ""
        subTitleField.text = objectToUpdate?.subTitle ?? ""
        isUpdate = true
    }
    
    // Function to perform delete action
    @objc func deleteAction(_ sender: UIButton) {
        realmManager.deleteObject(object: notes[sender.tag])
        getNotesFromDB()
    }
    
    @IBAction func generateRandomAction(_ sender: UIButton) {
        storeListOfObjects()
        getNotesFromDB()
    }
    
    @IBAction func dropAction(_ sender: UIButton) {
        realmManager.deleteTableOfType(type: NotesItem.self)
        self.getNotesFromDB()
    }
    
    @IBAction func flushDBAction(_ sender: UIButton) {
        realmManager.deleteDatabase()
        getNotesFromDB()
    }
    
    // Function to save list of objects into DB
    func storeListOfObjects() {
        let availableStartId = realmManager.incrementID(type: NotesItem.self, key: "id")
        var notesArray: [NotesItem] = []
        for i in 0 ..< 10 {
            let note = NotesItem(id: availableStartId + i, title: "This is Random \(availableStartId + i)", subTitle: "This is generated by code", date: Date())
            notesArray.append(note)
        }
        realmManager.saveListOfObjects(objects: notesArray)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as! NoteTableViewCell
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAction(_:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        cell.titleLabel.text = notes[indexPath.row].title
        cell.subTitleLabel.text = notes[indexPath.row].subTitle
        return cell
    }
    
}
