import UIKit
import RealmSwift
import IQKeyboardManagerSwift
class SafeBoxViewController: UITableViewController { 
    private let _safeBox : SafeBox? = SafeBoxManager().getMainSafeBox()
    @IBAction func unwindToCredentialList(_ segue: UIStoryboardSegue){
        if segue.identifier == "segue-Save-And-Return-To-List" {
            self.tableView.reloadData()
        }
    }
    @IBAction func lockSafeBox() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SafeBox"
        self.lockSafeBoxXtvbcMaster("bestIn")
         self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Listview Will Appear")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Warning")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _safeBox?.getCredentialCount() ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "credentials-Cell", for: indexPath)
        if let credentials = _safeBox?.getCredential(atIndex: indexPath.row) {
                cell.textLabel?.text = credentials.title 
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _safeBox?.deleteCredential(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _safeBox?.moveCredential(moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue-Display-Credentials" {
            print("segue-Display-Credentials")
            if let credViewController = segue.destination as? CredentialViewController, 
                let selectedIndex = self.tableView.indexPathForSelectedRow?.row, 
                let cred = _safeBox?.getCredential(atIndex: selectedIndex)
                {
                    credViewController.setCredentials(cred)
            }
        }
    }
}
