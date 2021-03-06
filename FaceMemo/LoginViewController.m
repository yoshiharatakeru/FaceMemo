//
//  LoginViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *LoginBt;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _LoginBt.center = self.view.center;
    [_LoginBt addTarget:self action:@selector(performLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //トラッキング
    self.trackedViewName = @"LoginView";
    
    NSLog(@"LoginViewController:viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark private methods
//ログインボタンプッシュ時
-(void)performLogin{
    [self openSession];
}




#pragma mark -
#pragma mark facebook sdk methods

//ログインのアクション
-(void)openSession{
    NSArray *permissions = @[@"read_friendlists"];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         
         if (error) {
             NSLog(@"Session error");
             [self fbResync];
             [NSThread sleepForTimeInterval:0.5];   //half a second
             [FBSession openActiveSessionWithReadPermissions:permissions
                                                allowLoginUI:YES
                                           completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                               [self sessionStateChanged:session state:state error:error];
                                           }];
         }else
         {
             [self sessionStateChanged:session state:state error:error];

         }
     
     
     }];
}


-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
    }
}


//ログイン後のアクション
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            //認証済みなのでログインビューを閉じるってこと？
            NSLog(@"ログイン成功です");
            [_delegate loginViewControllerDidLogin:self];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            //ログイン失敗ってこと？
            // Once the user has logged in, we want them to
            // be looking at the root view.
            NSLog(@"ログイン失敗です");
            
            break;
        default:
            break;
    }
    
    /*デリゲートで通知してるのでいらないのでは？
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];*/
    
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



-(void)loginFailed{
    //ログイン失敗時のメソッド(インジケータの消去とか)
    //チュートリアルでは上記のopenactivesession~もこのメソッドもappdelegateで呼んでる。なぜ？
}






@end
