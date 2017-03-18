//
//  ViewController.m
//  SendMeters
//
//  Created by Oleg Pavlichenkov on 17/03/2017.
//  Copyright © 2017 Oleg Pavlichenkov. All rights reserved.
//

#import "LoginController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;
@import GoogleSignIn;

@interface LoginController () <FBSDKLoginButtonDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *nativeFBLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *customFBLoginButton;
@property (weak, nonatomic) IBOutlet UIStackView *loginButtonsStack;
@property (weak, nonatomic) IBOutlet GIDSignInButton *nativeGoogleLoginButton;

- (void) setLoginButtonsStack;
- (void) setNativeFacebookLoginButton;
- (void) setCustomFacebookLoginButton;
- (void) setNativeGoogleLoginButton;
- (void) setCustomGoogleLoginButton;

- (void) loginWithFacebook;
- (void) onFacebookLogin;
- (void) loginWithGoogle;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginButtonsStack];
    [self setNativeFacebookLoginButton];
    [self setCustomFacebookLoginButton];
    [self setNativeGoogleLoginButton];
    [self setCustomGoogleLoginButton];
//    if ([FBSDKAccessToken currentAccessToken]) {
//        // User is logged in, do work such as go to next view controller.
//        NSLog(@"=== viewDidLoad: FB user currentAccessToken != nil");
//        [self onFacebookLogin];
//    }

}

- (void)setLoginButtonsStack {
    UIStackView *loginButtonsStack = [[UIStackView alloc] init];
    [loginButtonsStack setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:loginButtonsStack];
    
    loginButtonsStack.axis = UILayoutConstraintAxisVertical;
    loginButtonsStack.alignment = UIStackViewAlignmentFill;
    loginButtonsStack.distribution = UIStackViewDistributionFillEqually;
    loginButtonsStack.spacing = 8;

    [[loginButtonsStack.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:8]  setActive:YES];
    [[loginButtonsStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:24] setActive:YES];
    [[loginButtonsStack.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-8] setActive:YES];
    [[loginButtonsStack.heightAnchor constraintEqualToConstant:224] setActive:YES];
    //[[loginButtonsStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-8] setActive:YES];
    
    self.loginButtonsStack = loginButtonsStack;
};

- (void)setNativeFacebookLoginButton {
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButtonsStack addArrangedSubview:loginButton];
    self.nativeFBLoginButton = loginButton;
    
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
}

- (void)setCustomFacebookLoginButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [btn setBackgroundColor: [UIColor colorWithRed:59/255.0 green:86/255.0 blue:152/255.0 alpha:1]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    
    [btn addTarget:nil
            action:@selector(loginWithFacebook)
  forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButtonsStack addArrangedSubview:btn];
    self.customFBLoginButton = btn;
}

- (void) setNativeGoogleLoginButton {
    GIDSignInButton *nativeGoogleLoginButton = [[GIDSignInButton alloc] init];
    [nativeGoogleLoginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButtonsStack addArrangedSubview:nativeGoogleLoginButton];
    [GIDSignIn sharedInstance].uiDelegate = self;
};

- (void) setCustomGoogleLoginButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [btn setBackgroundColor: [UIColor colorWithRed:219/255.0 green:81/255.0 blue:73/255.0 alpha:1]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Login with Google" forState:UIControlStateNormal];
    
    [btn addTarget:nil
            action:@selector(loginWithGoogle)
  forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButtonsStack addArrangedSubview:btn];
    self.customFBLoginButton = btn;
};

- (void) loginWithFacebook {
    [[[FBSDKLoginManager alloc] init] logInWithReadPermissions:@[@"public_profile", @"email"]
                                            fromViewController:self
                                                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if(error) {
            NSLog(@"=== ERROR trying to connect to Facebook: %@", error.debugDescription);
            return;
        }
        NSLog(@"=== SUCCESS: Logged to facebook from cusromButton. Result Token: %@", result.token.tokenString);
        [self onFacebookLogin];
    }];
}

- (void) loginWithGoogle {
    NSLog(@"=== LOGIN WITH GOOGLE");
    [[GIDSignIn sharedInstance] signIn];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"=== INFO: Logged out from Facebook");
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"=== ERROR:  %@", error);
    }
    
    NSLog(@"=== SUCCESS: Successfully logged with Facebook Native Button/ didCompleteWithResult");
    [self onFacebookLogin];
}

- (void)onFacebookLogin {
    

    FIRAuthCredential *credentials = [FIRFacebookAuthProvider
                                      credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                      
    [[FIRAuth auth] signInWithCredential:credentials
                              completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
    {
        if (error) {
            NSLog(@"=== ERROR trying to sign in to Friebase with Facebook credentials: %@", error);
            return;
        }
        NSLog(@"=== SUCCESS: Logged to Firebase with FB Credentials. Firebase user: %@", user);
        
    }];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email, picture"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             NSLog(@"=== ERROR fetching Facebook User Data: %@", error);
         }
         //NSLog(@"=== fetched user: %@", result);
     }];
};


@end



//.h file
@interface UIColor (JPExtras)
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;
@end

//.m file
@implementation UIColor (JPExtras)
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}
@end
