//
//  FriendsViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FriendsViewController.h"
#import "LeftViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FMFriend.h"
#import "DetailViewController.h"
#import "FMControllerManager.h"
#import "MyTextField.h"

@interface FriendsViewController ()

<
UITableViewDataSource,
UITableViewDelegate,
LoginViewControllerDelegate,
UITextFieldDelegate,
LeftViewControllerDelegate,
UIScrollViewDelegate,
IIViewDeckControllerDelegate
>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *getFriendBt;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MyTextField *serchField;
@property (weak, nonatomic) IBOutlet UIImageView *blackView;
@property (weak, nonatomic) IBOutlet UIImageView *tabbar;

@end

@implementation FriendsViewController

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
    //friendConが表示された時点で過去にログイン記録があれば、それを元に
    //opensessionメソッドでログインできる。
    //記録が無い場合はログイン画面を表示
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"過去にログイン済み");
        [self openSession];
    } else {
        NSLog(@"ログイン記録無し");
        [self showLoginView];
    }
    
    //facebookのセッションが変化した場合の通知要求を登録
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    //テストボタン
    [_getFriendBt addTarget:self action:@selector(getFriendBtPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //メニューボタン
    [_menu_bt addTarget:self action:@selector(menu_btPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _serchField.delegate = self;
    

    
    //モデル
    _friendManager = [FMFriendManager sharedManager];
    
    
    //トラッキング
    self.trackedViewName = @"FriendsView";
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (FBSession.activeSession.isOpen) {
        //プロフィール情報の取得
        [self populateUserDetails];
        
        //フレンド情報の取得
        [self populateFriendsData];
        
    }else{
        NSLog(@"takeru");
        LoginViewController *loginCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginCon.delegate = self;
        [self presentViewController:loginCon animated:YES completion:nil];
        
    }
    
    self.viewDeckController.delegate = self;
}



-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidAppear:(BOOL)animated{
    


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark private methods

//セッション状態の変化の通知を受けとったときは情報を更新
- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}


#pragma mark -
#pragma mark Button action

- (void)menu_btPressed{
    
    //現状のセンタービューを保存
    FMControllerManager *controllerManager = FMControllerManager.new;
    [controllerManager setFriendViewController:self];
    
    //メビュー表示
    LeftViewController  *leftCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    leftCon.delegate = self;
    self.viewDeckController.leftSize = 160;
    [self.viewDeckController setLeftController:leftCon];
    [self.viewDeckController toggleLeftViewAnimated:YES];
    _tableView.allowsSelection = NO;


}



- (void)cellTapped:(FMButton*)bt{
    
    [self.view endEditing:YES];
    
    //詳細画面
    DetailViewController *detailCon = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.viewDeckController setRightController:detailCon];
    self.viewDeckController.rightSize = 0;
    detailCon.friend = [_friendManager.friends objectAtIndex:bt.indexPath.row];
    detailCon.user   = _user;
    
    [self.viewDeckController toggleRightView];
    
    
}


#pragma mark -
#pragma mark facebook sdk methods

//友達リスト取得メソッド
- (BOOL)populateFriendsData{

    [[FBRequest requestForMyFriends]startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
        }

        [_friendManager initFriends];
        [_tableView reloadData];
        
        NSArray *data = [result objectForKey:@"data"];
        
        for (NSDictionary *dic in data){
            
            //managerに追加
            FMFriend *friend = [[FMFriend alloc]initWithName:[dic objectForKey:@"name"] first_name:[dic objectForKey:@"first_name"] identifier:[dic objectForKey:@"id"] last_name:[dic objectForKey:@"last_name"] username:[dic objectForKey:@"username"]];
            [_friendManager addFriend:friend];
            
            //テーブルビュー更新
            NSLog(@"FriendsViewCon:data.count:%d",data.count);
            NSLog(@"FriendsViewCon:friends.count:%d",_friendManager.friends.count);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[data indexOfObject:dic] inSection:0];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        [_tableView reloadData];
        //検索用に変化しないarrayを作成
        [_friendManager setAllFriends:[[NSArray alloc]initWithArray:_friendManager.friends] ];

        
    }];
    
}


//ログイン画面を開くメソッド
-(void)showLoginView{
    LoginViewController *loginCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginCon.delegate = self;
    [self presentViewController:loginCon animated:YES completion:nil];
    
}

-(void)openSession{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
     }];
}

//プロフィール情報取得
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 //FMUserモデルクラスを作成してデータベースに保存
                 //TODO場所がここだとマズイ。ログインアクションの直後に置きたい
                 _user = [FMUser sharedInstance];
                 [_user setFirst_name:user.first_name];
                 [_user setLast_name:user.last_name];
                 [_user setMiddle_name:user.middle_name];
                 [_user setName:user.name];
                 [_user setUsername:user.username];
                 [_user setLocation:user.location];
                 [_user setId_facebook:user.id];
                 //[_user updateUserData];
                 
             }
         }];
    }
}

#pragma mark -
#pragma  mark tableview data source, delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _friendManager.friends.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
    FMFriend *friend = [_friendManager.friends objectAtIndex:indexPath.row];
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    FBProfilePictureView *picView = (FBProfilePictureView*)[cell viewWithTag:2];
    
    picView.profileID = nil;
    //名前
    lb_name.text = friend.name;
    
    
    //ボタン
    FMButton *bt = (FMButton*)[cell viewWithTag:4];
    bt.indexPath = indexPath;
    [bt addTarget:self action:@selector(cellTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //写真
    picView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        picView.profileID  = friend.identifier;
        picView.alpha = 1;
    } completion:nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"スクロール");
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark LeftViewControllerDelegate

- (void)leftViewControllerDidPressLogout:(id)sender{
    
    //ログアウト
    [FBSession.activeSession closeAndClearTokenInformation];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"まだログイン中");
    
    } else {
        NSLog(@"ログアウト完了");
        LoginViewController *loginCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginCon.delegate = self;
        [self presentViewController:loginCon animated:YES completion:nil];
    }
    
    
}


#pragma mark -
#pragma mark loginViewControllerDelegate

-(void)loginViewControllerDidLogin:(id)sender{
    NSLog(@"takeru");
    [self dismissViewControllerAnimated:YES completion:nil];
    //ユーザー情報をデータベースに登録
    
}


#pragma mark -
#pragma mark UITextfieldDelegate

-(BOOL)textField:(MyTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"text:%@",result);
    
    
    //friendsを空に
    [_friendManager initFriends];
    
    for (FMFriend *friend in _friendManager.allFriends) {
        NSRange match = [friend.name rangeOfString:result];
        
        if (match.location != NSNotFound) {
            [_friendManager addFriend:friend];
        }
    }
    
    if ([result isEqualToString:@""]){
        [_friendManager.friends addObjectsFromArray:_friendManager.allFriends ];
    }
     
    
    //テーブルの更新
    [_tableView reloadData];
    
    
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"編集開始");
    
    //フォーカス
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.alpha = 0.4;
        _tabbar.alpha = 0;
    
    }];
    

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"編集終了");
    
    //フォーカス解除
    [UIView animateWithDuration:0.2 animations:^{
        _blackView.alpha  = 0;
        _tabbar.alpha  = 1;
    }];
    
    //トラッキング
    GAI_TRACK_EVENT(NSStringFromClass(self.class), NSStringFromSelector(_cmd), textField.text);
    
}


#pragma mark -
#pragma mark viewDeckControllerDelegate


- (void)viewDeckController:(IIViewDeckController *)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated{
    
    _tableView.allowsSelection = YES;
}
@end
