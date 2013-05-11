//
//  FriendsViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FriendsViewController.h"
#import "SettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FMFriend.h"
#import "DetailViewController.h"

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *getFriendBt;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    //facebookのセッションが切れた場合の通知要求を登録
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    //テストボタン
    [_getFriendBt addTarget:self action:@selector(getFriendBtPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _arrayFriends = [[NSMutableArray alloc]init];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (FBSession.activeSession.isOpen) {
        //プロフィール情報の取得
        [self populateUserDetails];
        
        //フレンド情報の取得
        [self populateFriendsData];
        

    }

    
}


-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidAppear:(BOOL)animated{
    //viewDeckControllerの設定
    SettingViewController *settingCon = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    DetailViewController *detailCon = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.viewDeckController setRightController:detailCon];
    [self.viewDeckController setLeftController:settingCon];

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


- (IBAction)pusLogoutBt:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"まだログイン中");
    } else {
        NSLog(@"ログアウト済み");
        LoginViewController *loginCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginCon animated:YES completion:nil];
    }
}

//設定画面開く
- (IBAction)push:(id)sender {
    NSLog(@"takeru");
    [self.viewDeckController toggleLeftViewAnimated:YES];
    
}





#pragma mark -
#pragma mark facebook sdk methods

//友達リスト取得メソッド
- (BOOL)populateFriendsData{

    NSLog(@"get");
    [[FBRequest requestForMyFriends]startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"takeru");
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
        }

     //FMFrindオブジェクトとして配列に追加
     //TODO:_arrayFriendsはキャッシュとして保存するように変更
        if (_arrayFriends) {
            [_arrayFriends removeAllObjects];
        }
        NSArray *data = [result objectForKey:@"data"];
     for (NSDictionary *dic in data){
         FMFriend *friend = [[FMFriend alloc]initWithName:[dic objectForKey:@"name"] first_name:[dic objectForKey:@"first_name"] id:[dic objectForKey:@"id"] last_name:[dic objectForKey:@"last_name"] username:[dic objectForKey:@"username"]];
         [_arrayFriends addObject:friend];
         //テーブルビューに追加
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[data indexOfObject:dic] inSection:0];
         [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     }
        
        /*
        //テーブルの表示を更新
        for (int i=0; i<_arrayFriends.count; i++) {
            NSIndexPath *indexPath= [NSIndexPath indexPathForRow:i inSection:1];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [self updateCell:cell atIndexPath:indexPath];
        }*/
        //[_tableView reloadData];
        
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
                 _profileName.text = user.name;
                 _profileImage.profileID = user.id;
                 
                  //FMUserモデルクラスを作成してデータベースに保存
                 //TODO場所がここだとマズイ。ログインアクションの直後に置きたい
                 _user = FMUser.new;
                 [_user setFirst_name:user.first_name];
                 [_user setLast_name:user.last_name];
                 [_user setMiddle_name:user.middle_name];
                 [_user setName:user.name];
                 [_user setUsername:user.username];
                 [_user setLocation:user.location];
                 [_user setId_facebook:user.id];
                 [_user updateUserData];
                 
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
    return _arrayFriends.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = @"takeru";
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    FMFriend *friend = [_arrayFriends objectAtIndex:indexPath.row];
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = friend.name;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailCon = (DetailViewController*)self.viewDeckController.rightController;
    detailCon.friend = [_arrayFriends objectAtIndex:indexPath.row];
    detailCon.user   = _user;
    FMFriend *f = [_arrayFriends objectAtIndex:indexPath.row];
    [self.viewDeckController toggleRightView];

    
}


#pragma mark -
#pragma mark loginViewControllerDelegate
-(void)loginViewControllerDidLogin:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    //ユーザー情報をデータベースに登録
    
    
}

@end
