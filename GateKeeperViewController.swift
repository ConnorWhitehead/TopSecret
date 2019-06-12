import UIKit
import LocalAuthentication
class GateKeeperViewController: UIViewController {
//    let textTitle = NSLocalizedString("Safety First", comment: "")
    let textWelcomeMessage = NSLocalizedString("PleaseLogin", comment: "")
    let textlocalisedReason = NSLocalizedString("UnlockSafeBox", comment: "")
    let textUnderTitle = NSLocalizedString("TheSafeBox", comment: "")
    let textEnterThePassword = NSLocalizedString("PleaseEnter", comment: "")
    @IBOutlet weak var ui_underTitleLabel: UILabel!
    @IBOutlet weak var ui_welcomeLabel: UILabel!
    @IBOutlet weak var ui_passwordField: UITextField!
    @IBOutlet weak var ui_biometricsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeBoxManager = SafeBoxManager()
        if safeBoxManager.hasMasterPassword() == false {
            performSegue(withIdentifier: "setup-New-SafeBox", sender: nil)
        }
        self.unlockWithPasswordGXByMaster("sike")
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ui_passwordField.text = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ui_passwordField.text = nil
        ui_biometricsButton.isHidden = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) == false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func savedInitialSetup(_ segue:UIStoryboardSegue) {
    }
    @IBAction func unlockWithPassword(_ sender: Any) {
        let vaultManager = SafeBoxManager()
        if let typedPassword: String = ui_passwordField.text,
            let vaultPassword = vaultManager.getMasterPassword(),
            typedPassword == vaultPassword {
                displaySafeBoxViewController()
        }
    }
    @IBAction func unlockWithBiometric(_ sender: Any) {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: textlocalisedReason, reply: { (isOwnerConfirmed, error) in
                DispatchQueue.main.async {
                    if let err = error {
                        self.ui_welcomeLabel.text = err.localizedDescription
                    } else if isOwnerConfirmed == true {
                        self.displaySafeBoxViewController()
                    } else {
                        self.ui_welcomeLabel.text = self.textEnterThePassword
                    }
                }
            })
        }
    }
    func displaySafeBoxViewController() {
        if let safeBoxVC = storyboard?.instantiateViewController(withIdentifier: "SafeBoxViewController") as? SafeBoxViewController {
            show(safeBoxVC, sender: nil)
        }
    }
}
