import UIKit
class LaunchScreenViewController: UIViewController {
    let textWelcomeMessage = NSLocalizedString("PleaseWait", comment: "")
    @IBOutlet weak var ui_activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ui_welcomeMessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_activityIndicator.startAnimating()
        ui_welcomeMessageLabel.text = textWelcomeMessage
        loadForbiddensPassword()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loadForbiddensPassword() {
        SecurityManager.shared.downloadPasswordsFile()
        print("chargement des 1000 MDP Interdit commencé")
    }
}
