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
<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UserViewController


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
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }


    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell ;
    
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.section == 0) {
        //写真
        FBProfilePictureView *pv = (FBProfilePictureView*)[cell viewWithTag:1];
        pv.profileID = _user.id_facebook;
        //名前
        UILabel *lb = (UILabel*)[cell viewWithTag:2];
        lb.text = _user.name;
    }
    
    if (indexPath.section == 1) {
        FMComment *comment = [_commentManager.comments objectAtIndex:indexPath.row];
        UITextView *tv = (UITextView*)[cell viewWithTag:1];
        tv.text = comment.comment;
        
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    
    if (indexPath.section == 1) {
        return 145;
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
        NSString *disp_flg = ([[res objectForKey:@"disp_flg"]intValue] == 1)? @"true":@"false";
        [comment setDisp_flg:disp_flg];
        
        [_commentManager addComment:comment];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
    
}


//アップデート完了
- (void)connectorDidFinishUpdating:(id)sender{
    
    NSLog(@"更新完了");
}


//失敗
- (void)connectorDidFailLoadingWithError:(id)sener{
    NSLog(@"エラー");
}

@end
