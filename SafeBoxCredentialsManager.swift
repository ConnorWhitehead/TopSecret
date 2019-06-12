import Foundation
import RealmSwift
class  SafeBox {
    private let _realm: Realm
    private var _credentialsList: Results<Credentials> 
    init(withRealm realm: Realm) {
        _realm = realm
        _credentialsList = _realm.objects(Credentials.self).sorted(byKeyPath: "_order") 
    }
    func addOrUpdate(credential:Credentials) {
        try? _realm.write {
            _realm.add(credential, update: true)
        }
    }
    func add() -> Credentials {
        let credential = Credentials()
        credential.order = self.getCredentialCount()
            try? _realm.write {
                _realm.add(credential)
            }
        return credential
    }
        func update(credential:Credentials) {
        try? _realm.write {
            _realm.delete(credential)
        }
    }
    func addCredentials(withTitle title:String, login: String, password: String, email: String, url:String, detail: String ) -> Credentials {
        let newCredential = Credentials()
        newCredential.title = title
        newCredential.login = login
        newCredential.password = password
        newCredential.email = email
        newCredential.url = url
        newCredential.detail = detail
        try? _realm.write {
            _realm.add(newCredential)
        }
        return newCredential
    }
    func getCredentialCount() -> Int {
        return _credentialsList.count
    }
    func getCredential(atIndex index:Int) -> Credentials? {
        guard index >= 0 && index < getCredentialCount() else { 
            return nil
        }
        return _credentialsList[index]
    }
    func deleteCredential(atIndex index:Int) {
        if let credToDelete = getCredential(atIndex: index) {
            try? _realm.write {
                _realm.delete(credToDelete)
            }
        }
    }
    func moveCredential(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! _realm.write {
            let sourceObject = _credentialsList[sourceIndexPath.row]
            let destinationObject = _credentialsList[destinationIndexPath.row]
            let destinationObjectOrder = destinationObject.order
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = _credentialsList[index]
                    object.order -= 1
                }
            } else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                let object = _credentialsList[index]
                object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
        }
    }
    func credential(withTitle title:String) -> Credentials? {
        return _credentialsList.filter("_title = %@", title).first 
    }
}
