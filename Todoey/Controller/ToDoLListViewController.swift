

import UIKit
import CoreData
class ToDoListViewController: UITableViewController,UIPickerViewDelegate,UIImagePickerControllerDelegate {

    
    
    var itemslist=[Item]()
    
    var selectedcategory:Category?{
        
        didSet{
            loaddata()
        }
        
    }
    
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var datafilepath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedcategory!.name!)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
   
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemslist[indexPath.row].title
        cell.accessoryType=itemslist[indexPath.row].done ? .checkmark:.none
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemslist.count
    }
    
    
    
    
    
    
    //MARK - Tableview delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemslist[indexPath.row])
        itemslist[indexPath.row].done = !itemslist[indexPath.row].done
        saveditem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    //MARK - addbutton
    
    @IBAction func addbtn(_ sender: UIBarButtonItem) {
        var textfield=UITextField()
        let alert=UIAlertController(title: "add new todoey item", message:"" , preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default){(action) in
            if let text=textfield.text{
                let newitem=Item(context: self.context)
                newitem.title=text
                newitem.done=false
                newitem.parentcategory=self.selectedcategory
                self.itemslist.append(newitem)
                self.saveditem()
            }
           
        }
        alert.addTextField{ (alerttextfield) in
            alerttextfield.placeholder="Create new item"
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
    
    
    
    
    func loaddata(with request:NSFetchRequest<Item>=Item.fetchRequest(),predicate:NSPredicate?=nil){
        print("i'm inside loaddata")
        print(selectedcategory!.name!)
        let categorypredicate=NSPredicate(format: "parentcategory.name MATCHES %@", selectedcategory!.name!)
        if let additionalpredicate=predicate{
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalpredicate])
        }else{
            request.predicate=categorypredicate
        }
        do{
           itemslist = try context.fetch(request)

        }catch{
            print("fetching error!\(error)")

        }
        tableView.reloadData()
    }
    
   

}





//MARK: - Search bar methods
extension ToDoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item>=Item.fetchRequest()
         let predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        loaddata(with: request,predicate: predicate)
        
    }
    
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loaddata()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
