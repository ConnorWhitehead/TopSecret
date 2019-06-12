import UIKit
import MobileCoreServices
import UserNotifications
class CredentialViewController: UIViewController {
    private var _credentials: Credentials?
    func setCredentials (_ credentials: Credentials){
        _credentials = credentials
    }
    let textPasswordHidden = "Password hidden"
    let textHidePassword = "Hide Password"
    let textShowPassword = "Show Password"
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var urlLabael: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var ui_loginLabel: UILabel!
    @IBOutlet weak var ui_passwordLabel: UILabel!
    @IBOutlet weak var ui_emailLabel: UILabel!
    @IBOutlet weak var ui_urlLabel: UILabel!
    @IBOutlet weak var ui_showPasswordTitleButton: UIButton!
    @IBOutlet weak var ui_copyToClipboardTitleButton: UIButton!
    @IBOutlet weak var ui_OpenUrlTitleButton: UIButton!
    @IBOutlet weak var ui_SecurityWarningButton: UIButton!
    @IBOutlet weak var ui_detailTextView: UITextView!
    @IBAction func displayPassword(_ sender: Any) {
        if let cred = _credentials {
            if ui_passwordLabel.text == textPasswordHidden {
                ui_passwordLabel.text = "\(cred.password)"
                ui_showPasswordTitleButton.setTitle(textHidePassword, for: UIControlState.normal)
            }
            else if ui_passwordLabel.text == "\(cred.password)" {
                ui_passwordLabel.text = textPasswordHidden
                ui_showPasswordTitleButton.setTitle(textShowPassword, for: UIControlState.normal)
            }
        }
    }
    @IBAction func copyPasswordToClipboard(_ sender: Any) {
        if let cred = _credentials {
            let pasteboard = UIPasteboard.general
            pasteboard.setItems([[kUTTypeUTF8PlainText as String : cred.password]], options: [UIPasteboardOption.expirationDate: Date(timeIntervalSinceNow: 60), UIPasteboardOption.localOnly: true])
        }
    }
    @IBAction func openUrl(_ sender: Any) {
    }
    @IBAction func securityButtonTouched() {
        let textSecurityAlert = "Security Alert"
        let textOk = "Ok"
        if let cred = _credentials, 
            cred.isPasswordSafe.result == false, 
            let message = cred.isPasswordSafe.message { 
            let alertController = UIAlertController(title: textSecurityAlert, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: textOk, style: .default, handler: nil)) 
            present(alertController, animated: true, completion: nil) 
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        displayData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_OpenUrlTitleButton.isHidden = true
        askForValidateNotifications()
        self.securityButtonTouchedlcHMaster("string")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func displayData() {
        if let cred = _credentials {
            self.title = cred.title
            ui_loginLabel.text = "\(cred.login)"
            ui_emailLabel.text = "\(cred.email)"
            ui_urlLabel.text = "\(cred.url)"
            ui_detailTextView.text = String(cred.detail)
            ui_passwordLabel.text = textPasswordHidden
            if cred.isPasswordSafe.result {
                ui_SecurityWarningButton.isHidden = true
            } else {
                ui_SecurityWarningButton.isHidden = false
                scheduleWarningNotification(forCredential: cred)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit-Credentials" {
            print("edit-Credentials")
            if let itemToEdit: Credentials = _credentials,
                let editViewController:CredentialEditViewController = segue.destination as? CredentialEditViewController {
                editViewController.setCredentials(itemToEdit)
            }
        }
    }
    func askForValidateNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Response : \(granted) -- and error : \(String(describing: error))")
        }
    }
    func scheduleWarningNotification(forCredential cred:Credentials) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Warning Security", comment: "")
        content.subtitle = NSLocalizedString("Password unsecured", comment: "")
        content.body = NSLocalizedString("YouUsing", comment: "")
        content.sound = UNNotificationSound.default()
        if let imageUrl = Bundle.main.url(forResource: "Safety-First", withExtension: "png"), 
            let imageAttached = try? UNNotificationAttachment(identifier: "logo", url: imageUrl, options: nil)
        {
            content.attachments = [imageAttached]
        }
        content.userInfo = ["cred-title":cred.title]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) 
        let request = UNNotificationRequest(identifier: cred.title, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
