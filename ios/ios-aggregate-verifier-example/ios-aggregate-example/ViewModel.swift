import Foundation
import Web3Auth

class ViewModel: ObservableObject {
    var web3Auth: Web3Auth?
    @Published var loggedIn: Bool = false
    @Published var user: Web3AuthState?
    @Published var isLoading = false
    @Published var navigationTitle: String = ""
    private var clientId = "BHr_dKcxC0ecKn_2dZQmQeNdjPgWykMkcodEHkVvPMo71qzOV6SgtoN8KCvFdLN7bf34JOm89vWQMLFmSfIo84A"
    private var network: Network = .testnet
    func setup() async {
        guard web3Auth == nil else { return }
        await MainActor.run(body: {
            isLoading = true
            navigationTitle = "Loading"
        })
        web3Auth = await Web3Auth(.init(clientId: clientId, network: network))
        await MainActor.run(body: {
            if self.web3Auth?.state != nil {
                user = web3Auth?.state
                loggedIn = true
            }
            isLoading = false
            navigationTitle = loggedIn ? "UserInfo" : "Agg-Verifier Example"
        })
    }

    func loginWithGoogle() {
        Task{
            do {
                let result = try await Web3Auth(.init(
                            clientId: clientId,
                            network: network,
                            loginConfig: [
                                TypeOfLogin.google.rawValue:
                                        .init(
                                            verifier: "w3a-agg-example",
                                            typeOfLogin: .google,
                                            name: "Web3Auth-Aggregate-Verifier-Google-Example",
                                            clientId: "774338308167-q463s7kpvja16l4l0kko3nb925ikds2p.apps.googleusercontent.com",
                                            verifierSubIdentifier: "w3a-google"
                                        )
                            ],
                            whiteLabel: W3AWhiteLabelData(
                                    appName: "Web3Auth Stub",
                                    logoLight: "https://images.web3auth.io/web3auth-logo-w.svg",
                                    logoDark: "https://images.web3auth.io/web3auth-logo-w.svg",
                                    defaultLanguage: .en, // en, de, ja, ko, zh, es, fr, pt, nl
                                    mode: .dark,
                                    theme: ["primary": "#d53f8c"]),
                            mfaSettings: MfaSettings(
                                deviceShareFactor: MfaSetting(enable: true, priority: 1),
                                backUpShareFactor: MfaSetting(enable: true, priority: 2),
                                socialBackupFactor: MfaSetting(enable: true, priority: 3),
                                passwordFactor: MfaSetting(enable: true, priority: 4)
                            )
                        )).login(
                            W3ALoginParams(
                            loginProvider: .GOOGLE,
                            dappShare: nil,
                            extraLoginOptions: ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: nil, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil, additionalParams: nil),
                            mfaLevel: .DEFAULT,
                            curve: .SECP256K1
                        ))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })
            } catch {
                print("Error")
            }
        }
    }
    
    func loginWithGitHub() {
        Task{
            do {
                let result = try await Web3Auth(.init(
                    clientId: clientId,
                    network: network,
                    loginConfig: [
                        TypeOfLogin.jwt.rawValue:
                                .init(
                                    verifier: "w3a-agg-example",
                                    typeOfLogin: .jwt,
                                    name: "Web3Auth-Aggregate-Verifier-GitHub-Example",
                                    clientId: "hiLqaop0amgzCC0AXo4w0rrG9abuJTdu",
                                    verifierSubIdentifier: "w3a-a0-github"
                                )
                    ]
                )).login(
                    W3ALoginParams(
                    loginProvider: .JWT,
                    dappShare: nil,
                    extraLoginOptions: ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: nil, acr_values: nil, scope: nil, audience: nil, connection: "github", domain: "https://web3auth.au.auth0.com", client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: "email", isVerifierIdCaseSensitive: false, additionalParams: nil),
                    mfaLevel: .DEFAULT,
                    curve: .SECP256K1
                    ))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })
            } catch {
                print("Error")
            }
        }
    }
}

extension ViewModel {
    func showResult(result: Web3AuthState) {
        print("""
        Signed in successfully!
            Private key: \(result.privKey ?? "")
                Ed25519 Private key: \(result.ed25519PrivKey ?? "")
            User info:
                Name: \(result.userInfo?.name ?? "")
                Profile image: \(result.userInfo?.profileImage ?? "N/A")
                Type of login: \(result.userInfo?.typeOfLogin ?? "")
        """)
    }
}
