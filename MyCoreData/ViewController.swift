//
//  ViewController.swift
//  MyCoreData
//
//  Created by jayesh on 4/4/17.
//  Copyright © 2017 jayesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPresent: UILabel!
    var managedObjectContext:NSManagedObjectContext!
    var present = [Present]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
    }
    
    @IBAction func btnActionnnnn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "secSegue", sender: self)
    }
    // info@workbenchitsolution.com
    
    
    
    func loadData(){
        let presentRequest:NSFetchRequest<Present> = Present.fetchRequest()
        do{
            present = try managedObjectContext.fetch(presentRequest)
            
            if present.count > 0
            {
                for  i in 0...present.count - 1
                {
                    print(present[i].name ?? "")
                    lblName.text = present[i].name
                    lblPresent.text = present[i].presentName
                    imgView.image = UIImage(data: present[i].imageData as! Data)
                }

            }
        }catch
        {
            print("sadfsdf \(error.localizedDescription)")
        }
    }
    @IBAction func btnAction(_ sender: UIButton) {
        
        let imgpicker = UIImagePickerController()
        imgpicker.sourceType = .photoLibrary
        imgpicker.delegate = self
        self.present(imgpicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            picker.dismiss(animated: true, completion: { 
                self.createpresentItem(with: image)
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func createpresentItem(with image:UIImage)  {
        
        let present = Present(context: managedObjectContext)
        present.imageData = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
        let inputalert = UIAlertController(title: "New Present", message: "Enter a present and person", preferredStyle: UIAlertControllerStyle.alert)
        inputalert.addTextField { (textFeild:UITextField) in
            textFeild.placeholder  = "presentName"
        }
        inputalert.addTextField { (textFeild:UITextField) in
            textFeild.placeholder  = "Name"
        }
        
        
        inputalert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            let PresentName = inputalert.textFields?.first
            let name = inputalert.textFields?.last
            
            if PresentName?.text != "" && name?.text != ""
            {
                present.presentName = PresentName?.text
                present.name = name?.text
                let img = UIImage(named: "1.jpg")
                present.imageData = NSData(data: UIImagePNGRepresentation(img!)!)
                
                do {
                    try self.managedObjectContext.save()
                }catch{
                    print("sadfsdf \(error.localizedDescription)")
                }
            }
        }))
        inputalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(inputalert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
