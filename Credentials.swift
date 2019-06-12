import Foundation
import RealmSwift
class Credentials: Object {
    @objc private dynamic var _title: String = ""
    @objc private dynamic var _login: String = ""
    @objc private dynamic var _password: String = ""
    @objc private dynamic var _email: String = ""
    @objc private dynamic var _url: String = ""
    @objc private dynamic var _detail: String = ""
    @objc private dynamic var _credentialId: String = String(NSDate.timeIntervalSinceReferenceDate)
    @objc private dynamic var _order: Int = 0 
    override static func primaryKey() -> String? {
        return "_credentialId"
    }
    var isPasswordSafe:SecurityManager.SecurityAnswer {     
        return SecurityManager.shared.isPasswordSafe(password: self.password)
    }
    var title: String {
        get {
            return _title
        }
        set {                         
            realm?.beginWrite()       
            _title = newValue
            try? realm?.commitWrite()  
        }
    }
    var login: String {
        get {
            return _login
        }
        set {
            realm?.beginWrite()
            _login = newValue
            try? realm?.commitWrite()
        }
    }
    var password: String {
        get {
            return _password
        }
        set {
            realm?.beginWrite()
            _password = newValue
            try? realm?.commitWrite()
        }
    }
    var email: String {
        get {
            return _email
        }
        set {
            realm?.beginWrite()
            _email = newValue
            try? realm?.commitWrite()
        }
    }
    var url: String {
        get {
            return _url
        }
        set {
            realm?.beginWrite()
            _url = newValue
            try? realm?.commitWrite()
        }
    }
    var detail: String {
        get {
            return _detail
        }
        set {
            realm?.beginWrite()
            _detail = newValue
            try? realm?.commitWrite()
        }
    }
    var credentialId: String {
        get {
            return _credentialId
        }
        set {
            realm?.beginWrite()
            _credentialId = newValue
            try? realm?.commitWrite()
        }
    }
    var order: Int {
        get {
            return _order
        }
        set {
            _order = newValue
        }
    }
}
