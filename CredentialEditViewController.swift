import UIKit
import RealmSwift
import IQKeyboardManagerSwift
class CredentialEditViewController: UITableViewController {  
    var _credentials: Credentials?
    func setCredentials (_ credentials: Credentials){
        _credentials = credentials
    }
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ui_titleTextField: UITextField!
    @IBOutlet weak var ui_loginTextField: UITextField!
    @IBOutlet weak var ui_passwordTextField: UITextField!
    @IBOutlet weak var ui_emailTextField: UITextField!
    @IBOutlet weak var ui_urlTextField: UITextField!
    @IBOutlet weak var ui_detailTextView: UITextField!
    @IBAction func dissmissThisController(_ sender: Any) {
        dismiss(animated: true, completion: nil) 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_titleTextField.text = _credentials?.title
        ui_loginTextField.text = _credentials?.login
        ui_passwordTextField.text = _credentials?.password
        ui_emailTextField.text = _credentials?.email
        ui_urlTextField.text = _credentials?.url
        ui_detailTextView.text = _credentials?.detail
        idLabel.text = _credentials?.credentialId
        self.setCredentialsMqVAMaster("soo")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue-Save-And-Return-To-List" {
            print("segue-Save-And-Return-To-List")
            if let title : String = ui_titleTextField.text, title.count > 0,
                let login : String  = ui_loginTextField.text, login.count > 0,
                let password : String  = ui_passwordTextField.text, password.count > 0,
                let email : String  = ui_emailTextField.text,
                let url : String  = ui_urlTextField.text,
                let detail : String  = ui_detailTextView.text,
                let credManager: SafeBox = SafeBoxManager().getMainSafeBox()
                {
                    let isNewCredentials:Bool = ( _credentials == nil )
                    let credentials : Credentials = isNewCredentials ? credManager.add() : _credentials!
                    credentials.title = title
                    credentials.login = login
                    credentials.password = password
                    credentials.email = email
                    credentials.url = url
                    credentials.detail = detail
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = self.setupGradientLayer(colors: [UIColor(hexcode: "#FFFFFF", alpha: 1).cgColor, UIColor(hexcode: "#FFFFFF", alpha: 1).cgColor], frame: self.view.frame)
        self.view.layer.insertSublayer(layer, at: 0)
    }
}
