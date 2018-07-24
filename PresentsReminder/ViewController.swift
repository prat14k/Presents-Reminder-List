//
//  ViewController.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 24/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var managedObjectContext : NSManagedObjectContext!
    
    var presentsInfo = [PresentsList]()
    
    lazy var imagePickerController : UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
    
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    private func loadDataFromDB(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription()
        entity.name = NSStringFromClass(PresentsList.self)
        fetchRequest.entity = entity
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            if let data = try managedObjectContext.fetch(fetchRequest) as? [PresentsList] {
                presentsInfo = data
                self.tableView.reloadData()
            }
        }
        catch {
            print("Unable to fetch \(error.localizedDescription)")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        if managedObjectContext != nil {
            loadDataFromDB()
        }
    }
    
    private func  alertForOtherInfo(withImage image: UIImage) {
        
        if managedObjectContext == nil {
            return
        }
        
        let alertController = UIAlertController(title: "New Present", message: "Enter the person's name and the present", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Gift"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "When to give the gift"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let person = alertController.textFields?[0].text ,
                let present = alertController.textFields?[1].text,
                let dateToGive = alertController.textFields?[2].text {
                
                if person != "" && present != "" {
                    
                    let presentModel = PresentsList(context: self.managedObjectContext)
                    presentModel.image = UIImageJPEGRepresentation(image, 0.3)!
                    presentModel.personName = person
                    presentModel.gift = present
                    presentModel.uid = NSUUID().uuidString
                    presentModel.dateToGive = dateToGive.toDate() ?? Date()
                    do {
                        try self.managedObjectContext.save()
                        presentModel.donatePresentToSiri()
                        self.presentsInfo.append(presentModel)
                        self.tableView.insertRows(at: [IndexPath(row: self.presentsInfo.count - 1, section: 0)], with: .top)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetailView" {
            if let destinationVC = segue.destination as? PresentsViewController {
                destinationVC.present = presentsInfo[(sender as! Int)]
            }
        }
    }
    
}

extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            picker.dismiss(animated: true, completion: {
                self.alertForOtherInfo(withImage: selectedImage)
            })
        }
        else{
            picker.dismiss(animated: true, completion: nil)
        }

    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let present = presentsInfo[indexPath.row]
        cell.heading.text = present.personName
        cell.subHeading.text = present.gift
        
        if let imageData = present.image {
            if let image = UIImage(data: imageData) {
                cell.cellImageView.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "presentDetailView", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = UIColor.red
            
            let deletedPresent = presentsInfo[indexPath.row]
            presentsInfo.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            DispatchQueue.global(qos: .background).async {
                deletedPresent.removeIndexFromSearch()
                do {
                    self.managedObjectContext.delete(deletedPresent)
                    try self.managedObjectContext.save()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
}

