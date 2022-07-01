struct UserAuthorization: Codable {
    var accessToken: String = ""
    var refreshToken: String = ""
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "Authorization"
        case refreshToken = "Refresh-Token"
    }
}
