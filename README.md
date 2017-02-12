# Protocol oriented network abstraction in Swift

Please visit [my blog](https://blog.benchr.me/post/pop-network-1/) for more explanation.

This is a working example to fetch all public repositories of the authenticated user:

```Swift
let githubToken = "xxx"

let githubAuthenticator = SimpleAuthenticator {
    $0.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
}

struct Repository: JSONObject {
    let desc: String
    let name: String
    init?(json: Any) {
        guard let j = json as? [String: Any] else {
            return nil
        }
        guard
            let d = j["description"] as? String,
            let n = j["full_name"] as? String
        else {
            return nil
        }
        self.desc = d
        self.name = n
    }
}

struct RepositoryEndpoint: GET {
    typealias ResponseType = JSONArray<Repository>
    let path = "/user/repos"
    var urlParameter: [String : String] {
        return ["visibility": "public"]
    }
}


let client = Client(baseUrl: "https://api.github.com", authenticator: githubAuthenticator)

client.get(RepositoryEndpoint()) { response in
    response.res?.array // -> is now an array of all requested repositories
}

```
