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

@interface LoginController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *customFBLoginButton;
@property (weak, nonatomic) IBOutlet UIStackView *loginButtonsStack;

- (void) setLoginButtonsStack;
- (void) setNativeFBLoginButton;
- (void) setCustomFBLoginButton;

- (void) loginWithFacebook;
- (void) onFacebookLogin;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginButtonsStack];
    [self setNativeFBLoginButton];
    [self setCustomFBLoginButton];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"=== viewDidLoad: FB user currentAccessToken != nil");
        [self onFacebookLogin];
        
    
        
    }
}

- (void)setLoginButtonsStack {
    UIStackView *loginButtonsStack = [[UIStackView alloc] init];
    [loginButtonsStack setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:loginButtonsStack];
    
    loginButtonsStack.axis = UILayoutConstraintAxisVertical;
    loginButtonsStack.distribution = UIStackViewDistributionFillEqually;
    loginButtonsStack.spacing = 8;

    [[loginButtonsStack.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:8]  setActive:YES];
    [[loginButtonsStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20] setActive:YES];
    [[loginButtonsStack.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-8] setActive:YES];
    [[loginButtonsStack.heightAnchor constraintEqualToConstant:108] setActive:YES];
    //[[loginButtonsStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-8] setActive:YES];
    
    self.loginButtonsStack = loginButtonsStack;
};

- (void)setNativeFBLoginButton {
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    loginButton.readPermissions = @[@"public_profile", @"email"];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self.loginButtonsStack addSubview:loginButton];
    [self.loginButtonsStack addArrangedSubview:loginButton];
    
//    [[loginButton.leftAnchor constraintEqualToAnchor:self.loginButtonsStack.leftAnchor constant:16]  setActive:YES];
//    [[loginButton.topAnchor constraintEqualToAnchor:self.loginButtonsStack.topAnchor constant:40] setActive:YES];
//    [[loginButton.rightAnchor constraintEqualToAnchor:self.loginButtonsStack.rightAnchor constant:-16] setActive:YES];
//    [[loginButton.heightAnchor constraintEqualToConstant:50] setActive:YES];
    
    self.loginButton = loginButton;
}

- (void)setCustomFBLoginButton {
    UIButton *customFBLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [customFBLoginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [customFBLoginButton setBackgroundColor: [UIColor colorWithRed:59/255.0 green:86/255.0 blue:152/255.0 alpha:1]];
    [customFBLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customFBLoginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    
    [customFBLoginButton addTarget:nil
                            action:@selector(loginWithFacebook)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButtonsStack addArrangedSubview:customFBLoginButton];
    self.customFBLoginButton = customFBLoginButton;
    
}
- (void) loginWithFacebook {
    NSLog(@"Trying to loging with Facebook");
    
    [[[FBSDKLoginManager alloc] init] logInWithReadPermissions:@[@"public_profile", @"email"]
                                            fromViewController:self
                                                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if(error) {
            NSLog(@"=== ERROR: %@", error.debugDescription);
            return;
        }
        NSLog(@"logged with FB with Token: %@", result.token.tokenString);
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"=== INFO: Logged out from Facebook");
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error != nil) {
        NSLog(@"=== ERROR:  %@", error);
    }
    
    NSLog(@"=== INFO: Successfully logged with Facebook/ didCompleteWithResult");
    [self onFacebookLogin];
}

- (void)onFacebookLogin {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email, picture"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             NSLog(@"=== ERROR fetching FB User Data: %@", error);
         }
         NSLog(@"=== fetched user: %@", result);}];
};

@end
