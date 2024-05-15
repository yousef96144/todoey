

import UIKit
import CoreData

class CategoryViewController: UITableViewController,UIPickerViewDelegate,UIImagePickerControllerDelegate {
    
    var categoriesarray=[Category]()
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    var datafilepath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
     loaddata()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text=categoriesarray[indexPath.row].name
//        cell.accessoryType=itemslist[indexPath.row].done ? .checkmark:.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesarray.count
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "firstsegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc=segue.destination as! ToDoListViewController
       if let indexPath=tableView.indexPathForSelectedRow {
           print(categoriesarray[indexPath.row].name!)
           destinationvc.selectedcategory=self.categoriesarray[indexPath.row]
           print(categoriesarray[indexPath.row])    
        }
    }
    
    @IBAction func addbtnpressed(_ sender: UIBarButtonItem) {
        
        var textfield=UITextField()
        let alert=UIAlertController(title: "add new Category", message:"" , preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default){(action) in
            if let text=textfield.text{
                let newcategory=Category(context: self.context)
                newcategory.name=text
                //                newcategory.done=false
                self.categoriesarray.append(newcategory)
                self.saveditem()
            }
            
            
        }
        alert.addTextField{ (alerttextfield) in
            alerttextfield.placeholder="Create new Categoty"
            print(alerttextfield.text ?? "nothing to show")
           textfield=alerttextfield
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK - saveddata
    func saveditem(){
        do{
            
           try context.save()
        }catch{
            print("error saving context\(error)")
        }
        self.tableView.reloadData()

    }
    
    func loaddata(with request:NSFetchRequest<Category>=Category.fetchRequest()){
        do{
           categoriesarray = try context.fetch(request)
        }catch{
            print("fetching error!\(error)")

        }
        tableView.reloadData()
    }
    
}
