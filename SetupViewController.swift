import UIKit
class SetupViewController: UIViewController {
    let welcomeTextMessage = NSLocalizedString("PleaseChoose", comment: "")
    let placeholderTextField1 = NSLocalizedString("TypeYour", comment: "")
    let placeholderTextField2 = NSLocalizedString("ConfirmPassword", comment: "")
    @IBOutlet weak var ui_passwordField1: UITextField!
    @IBOutlet weak var ui_passwordField2: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return getTypedPassword() != nil
    }
    private func getTypedPassword() -> String? {
        let password:String?
        if let password1 = ui_passwordField1.text,
            let password2 = ui_passwordField2.text,
            password1.count > 6,
            password1 == password2
        {
            password = password1
        } else {
            password = nil
        }
        return password
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let password = getTypedPassword()
            {
                SafeBoxManager().saveMasterPassword(password)
        }
    }
}
