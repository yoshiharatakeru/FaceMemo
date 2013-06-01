//
//  UserViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"

@interface UserViewController ()
<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@end

@implementation UserViewController

{
    
    __weak IBOutlet FBProfilePictureView *profileView;
    __weak IBOutlet UILabel *lb_name;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //モデル
    _commentManager = [FMCommentManager sharedManager];
    _user = [FMUser sharedInstance];
    
    
    //コメント情報取得
    [_commentManager setFrom_user:@"blank"];
    [_commentManager setTo_user:_user.id_facebook];
    
    FMConnector *connector = [FMConnector sharedInstance];
    connector.delegate = self;
    [connector downloadComments];
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"Loading";
    
    
    //トラッキング
    self.trackedViewName = @"UserView";
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [_commentManager initProperties];
    FMControllerManager *manager = [FMControllerManager sharedManager];
    [manager setUserViewController:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [_commentManager initProperties];
    
    FMControllerManager *controllManager = [FMControllerManager sharedManager];
    [controllManager setUserViewController:self];
    
    //ユーザー情報
     //写真
     profileView.profileID = _user.id_facebook;
     
     //名前
     lb_name.text = _user.name;
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate,Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    
    if (section == 1){
        return _commentManager.comments.count;
    }
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        }
    
    }


    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell ;
    
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.section == 0) {
 
    }
    
    if (indexPath.section == 1) {
        
        //コメント
        FMComment *comment = [_commentManager.comments objectAtIndex:indexPath.row];
        UITextView *tv = (UITextView*)[cell viewWithTag:1];
        tv.text = comment.comment;
        
        //日付
        UILabel *lb  = (UILabel*)[cell viewWithTag:2];
        lb.text =comment.date;
        
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 135;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 158;
        }else{
            return 153;
        }
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    
}
- (IBAction)backBtPressed:(id)sender {
    [self.viewDeckController toggleLeftView];
    
    
}


#pragma mark  -
#pragma mark FMConnectorDelegate

//ロード開始
- (void)connectorDidBeginLoading:(id)sender{
    
}

//ダウンロード完了
- (void)connector:(FMConnector *)connector didFinishDownLoading:(NSArray*)responseData{
    
    NSLog(@"res:%@",responseData.description);
    
    //コメントモデル追加
    for (NSDictionary *res in responseData) {
        FMComment *comment = FMComment.new;
        [comment setIdentifier:[res objectForKey:@"id"]];
        [comment setTo_user:[res objectForKey:@"to_user"]];
        [comment setFrom_user:[res objectForKey:@"from_user"]];
        [comment setComment:[res objectForKey:@"memo"]];
        [comment setDate:res[@"updated_at"]];
        NSString *disp_flg = ([[res objectForKey:@"disp_flg"]intValue] == 1)? @"true":@"false";
        [comment setDisp_flg:disp_flg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_HUD hide:YES];
            
            [_commentManager addComment:comment];
            NSInteger num  = [_commentManager.comments indexOfObject:comment];
            NSLog(@"test:num:%d",num);
            NSLog(@"comments:%d",_commentManager.comments.count);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num inSection:1];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        });
    }
    
    
}


//失敗
- (void)connectorDidFailLoadingWithError:(id)sener{
    
    [_HUD hide:YES];
    NSString *title = @"通信エラー";
    NSString *message = @"通信に失敗しました";
    [AppDelegate showAlertWithTitle:title message:message];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[_HUD removeFromSuperview];
	_HUD = nil;
}

@end
