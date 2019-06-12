import Foundation
import RealmSwift 
import KeychainAccess 
class SafeBoxManager {
    private static let REALM_ENCRYPTION_KEY = "REALM_ENCRYPTION_KEY"
    private static let MASTER_PASSWORD = "SAFETY_FIRST_MASTER_PASSWORD"
    private var _safeBox : SafeBox?
    private var _keychain: Keychain
    init() {
        _keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "fr.albanbernard.ios.app.SafetyFirst")
    }
    func getMainSafeBox() -> SafeBox? {
        var possibleKey: Data?
        possibleKey = loadRealmEncryptionKey()
        if possibleKey == nil {
            possibleKey = generateRealmEncryptionKey()
        }
        if let realmEncryptionKey = possibleKey {
            let realmConf = Realm.Configuration(encryptionKey: realmEncryptionKey)
            let realm = try! Realm(configuration: realmConf)
            _safeBox = SafeBox(withRealm: realm)
        }
        return _safeBox
    }
    private func loadRealmEncryptionKey() -> Data? {
        return _keychain[data: SafeBoxManager.REALM_ENCRYPTION_KEY]
    }
    private func generateRealmEncryptionKey() -> Data? {
        guard let generatedData = Data(countOfRandomData: 64) else {
            return nil
        }
        try! _keychain.set(generatedData, key: SafeBoxManager.REALM_ENCRYPTION_KEY)
        return generatedData
    }
    func saveMasterPassword(_ password:String) {
        _keychain[SafeBoxManager.MASTER_PASSWORD] = password
    }
    func getMasterPassword() -> String? {
        return _keychain[SafeBoxManager.MASTER_PASSWORD]
    }
    func hasMasterPassword() -> Bool {
        return getMasterPassword() != nil
    }
}
