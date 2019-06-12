import Foundation
import Alamofire
class  SecurityManager {
    private static let top_1000_password_url = "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt"
    private var _forbiddenPasswordList:[String]? = nil 
    struct SecurityAnswer {
        let result:Bool
        let message:String?
    }
    private static var s_securityManager:SecurityManager? = nil
    public static var shared:SecurityManager {
        if s_securityManager == nil {
            s_securityManager = SecurityManager()
        }
        return s_securityManager!
    }
    private init() {
    }
    func downloadPasswordsFile() {
        DispatchQueue.main.async {
            Alamofire.request(SecurityManager.top_1000_password_url).responseString { (response) in   
                if let passwordList = response.result.value {
                    self._forbiddenPasswordList = passwordList.components(separatedBy: "\n")  
                    print("loading of the 10,000 banned prohibited MDP")
                } else {
                    print("Loading banned MDPs impossible")
                }
            }
        }
    }
    func isPasswordSafe(password:String) -> SecurityAnswer {
        let answer:SecurityAnswer
        let errorMessage: String = NSLocalizedString("Thispasswordforbidden", comment: "")
        let notReadyMessage: String = NSLocalizedString("Notready", comment: "")
        if let forbiddenPaswwordList = _forbiddenPasswordList {   
            if forbiddenPaswwordList.contains(password){
                answer = SecurityAnswer(result: false, message: errorMessage)
            } else {
                answer = SecurityAnswer(result: true, message: nil)  
            }
        } else {                                                         
            answer = SecurityAnswer(result: false, message: notReadyMessage)
        }
        return answer
    }
}
