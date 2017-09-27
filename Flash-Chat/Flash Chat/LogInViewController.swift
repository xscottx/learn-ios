//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class LogInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        signInButton.style = .wide
        signInButton.colorScheme = .dark
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.show()
        
        if let error = error {
            print("failed to google sign in")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        print("credential: \(credential)")
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("user: \(user) logged out")
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Log in the user
        FIRAuth.auth()?.signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        })
        
    }
    


    
}  
