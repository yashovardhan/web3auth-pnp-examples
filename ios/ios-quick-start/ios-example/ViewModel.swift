import Foundation
// IMP START - Quick Start
import Web3Auth
// IMP END - Quick Start

class ViewModel: ObservableObject {
    var web3Auth: Web3Auth?
    @Published var loggedIn: Bool = false
    @Published var user: Web3AuthState?
    @Published var isLoading = false
    @Published var navigationTitle: String = ""
    // IMP START - Get your Web3Auth Client ID from Dashboard
    private var clientId = "BEglQSgt4cUWcj6SKRdu5QkOXTsePmMcusG5EAoyjyOYKlVRjIF1iCNnMOTfpzCiunHRrMui8TIwQPXdkQ8Yxuk"
    // IMP END - Get your Web3Auth Client ID from Dashboard
    // IMP START - Whitelist bundle ID
    private var network: Network = .cyan
    // IMP END - Whitelist bundle ID
    func setup() async {
        guard web3Auth == nil else { return }
        await MainActor.run(body: {
            isLoading = true
            navigationTitle = "Loading"
        })
        // IMP START - Initialize Web3Auth
        web3Auth = await Web3Auth(.init(clientId: clientId, network: network))
        // IMP END - Initialize Web3Auth
        await MainActor.run(body: {
            if self.web3Auth?.state != nil {
                user = web3Auth?.state
                loggedIn = true
            }
            isLoading = false
            navigationTitle = loggedIn ? "UserInfo" : "SignIn"
        })
    }

    func login(provider: Web3AuthProvider) {
        Task {
            do {
                // IMP START - Login
                let result = try await Web3Auth(.init(clientId: clientId, network: network)).login(W3ALoginParams(loginProvider: provider))
                // IMP END - Login
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })

            } catch {
                print("Error")
            }
        }
    }
    
    func loginEmailPasswordless(provider: Web3AuthProvider, email: String) {
        Task {
            do {
                // IMP START - Login
                let result = try await Web3Auth(.init(clientId: clientId, network: network)).login(W3ALoginParams(loginProvider: provider, extraLoginOptions: ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: email, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil, additionalParams: nil)))
                // IMP END - Login
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                    navigationTitle = "UserInfo"
                })

            } catch {
                print("Error")
            }
        }
    }
}
