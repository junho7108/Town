import Security
import Foundation
import KakaoSDKCommon

struct KeyChainManager {

    static let serivceIdentifier = "com.traydcorp.village"
    
    static let userAccessTokenKeyName = "AuthorizationKey"
    static let userRefreshTokenKeyName = "Refresh-AuthorizationKey"
    
    static let socialAccesTokenKeyName = "SocialAccessTokenKey"
    static let socialProviderKeyName = "SocialProviderKey"
    
    /*
     * service: 키체인에서 해당 앱을 식별하는 값으로 앱만의 고유한 값을 써야함. (데이터를 해당 앱에서만 사용하기 위해서)
     * userAccount: 앱 내에서 데이터를 식별하기 위한 키에 해당하는 값
     */
    
    static func save(service: String, userAccount: String, data: String) {
        let dataFromString: Data = data.data(using: String.Encoding.utf8)!
        
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword as String,
            kSecAttrService: service,
            kSecAttrAccount: userAccount,
            kSecValueData: dataFromString
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        assert(status == noErr, "키체인 저장에 실패하였습니다.")
    }
    
    static func load(service: String, userAccount: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: userAccount,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            return value
        } else {
            return nil
        }
    }
    
    static func delete(service: String, userAccount: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: userAccount
        ]
        
        SecItemDelete(query)
    }
}

extension KeyChainManager {
    
    static func saveSocialAccessToken(accessToken: String) {
        Self.save(service: Self.serivceIdentifier,
                             userAccount: Self.socialAccesTokenKeyName, data: accessToken)
    }
    
    static func saveSocialProvider(provider: SocialLoginType) {
        Self.save(service: Self.serivceIdentifier,
                             userAccount: Self.socialProviderKeyName, data: provider.rawValue)
    }
    
    static func saveUserAuthorization(authorization: UserAuthorization) {
        Self.save(service: Self.serivceIdentifier,
                  userAccount: Self.userAccessTokenKeyName, data: authorization.accessToken)
        
        Self.save(service: Self.serivceIdentifier,
                  userAccount: Self.userRefreshTokenKeyName, data: authorization.refreshToken)
    }
    
   
    static func loadSocialProvider() -> SocialLoginType? {
        let providerName =  Self.load(service: Self.serivceIdentifier,
                  userAccount: Self.socialProviderKeyName)
        
        return SocialLoginType.init(rawValue: providerName ?? "")
    }
    
    static func loadSocialAccessToken() -> String? {
        return Self.load(service: Self.serivceIdentifier,
                         userAccount: Self.socialAccesTokenKeyName)
    }
    
    static func loadUserAuthorization() -> UserAuthorization? {
        let accessToken = Self.load(service: Self.serivceIdentifier,
                                    userAccount: Self.userAccessTokenKeyName)
        
        let refreshToken = Self.load(service: Self.serivceIdentifier,
                                     userAccount: Self.userRefreshTokenKeyName)
        
        return UserAuthorization(accessToken: accessToken ?? "", refreshToken: refreshToken ?? "")
    }
   
    static func printUserAccount() {
        print("프로바이더: \(Self.loadSocialProvider())")
        print("소셜 엑세스 토큰: \(Self.loadSocialAccessToken())")
        print("계정 토큰 정보: \(Self.loadUserAuthorization())")
    }
    
    static func deleteUserAccount() {
        Self.delete(service: Self.serivceIdentifier, userAccount: Self.socialProviderKeyName)
        Self.delete(service: Self.serivceIdentifier, userAccount: Self.socialAccesTokenKeyName)
        Self.delete(service: Self.serivceIdentifier, userAccount: Self.userAccessTokenKeyName)
        Self.delete(service: Self.serivceIdentifier, userAccount: Self.userRefreshTokenKeyName)
    }
}
