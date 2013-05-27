//
//  DetailViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "DetailViewController.h"
#import "FMComment.h"
#import "FMCommentManager.h"
#import "SBJson.h"
#import "MyTextField.h"
#import "FMCommentNetworkOperation.h"
#import "FMSwitch.h"
#import "FMButton.h"
#import "FMSwipeGestureRecognizer.h"
#import "CommentSettingView.h"
#import "FMTextView.h"

@interface DetailViewController ()



< UITableViewDataSource,
  UITableViewDelegate,
  UITextFieldDelegate,
  FMCommentNetworkOperationDelegate,
  FMConnectorDelegate,
  MBProgressHUDDelegate,
  UITextViewDelegate
>

@end

@implementation DetailViewController

{
    NSIndexPath *_settingIndexPath;
}


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
    
    //テーブル
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //model準備
    _commentManager= [FMCommentManager sharedManager];
    
    //設定ビューのステータス
    _settingIndexPath = nil;
    
    
    NSLog(@"DetailViewController:viewDidLoad");
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"DetailViewController:viewWillAppear");
    
    //コメント取得:プロパティが消えてしまう。
    [self performSelector:@selector(downloadComments) withObject:nil afterDelay:0];
      
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [_commentManager initProperties];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableview datasource, delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num;
    switch (section) {
        case 0:{
            //フレンドの基本情報
            num = 1;
            break;
        }

        case 1:{
            //num =  3;
            NSLog(@"Num:%d",_commentManager.comments.count);;
            num = _commentManager.comments.count;
            
            break;
        }
        case 2:{
            //追加ボタン
            num = 1;
            break;
        }
        default:
            
            break;
    }
    return num;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            //フレンドの基本情報
            cell = [_tableView dequeueReusableCellWithIdentifier:@"cell0"];
            
            break;
        case 1:
            //フレンドの既存情報
            cell = [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
            break;
        case 2:
            //追加ボタン
            cell = [_tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
        default:
            break;
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}


-(void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
    
    switch (indexPath.section) {
        
        case 0:{//フレンドの基本情報
            //名前
            UILabel *lb_name= (UILabel*)[cell viewWithTag:2];
            lb_name.text = _friend.name;
            
            //写真
            FBProfilePictureView *ProView = (FBProfilePictureView*)[cell viewWithTag:1];
            ProView.alpha = 0;
            ProView.profileID = _friend.identifier;
            //アニメーション
            [UIView animateWithDuration:0.2 animations:^{
                ProView.alpha = 1;
            } completion:nil];
            
            
            break;
        }
        
        case 1:{//コメント
            
            //NSLog(@"update comment");
            FMComment *comment = [_commentManager.comments objectAtIndex:indexPath.row];
            
            //コメント
            FMTextView *tv = (FMTextView*)[cell viewWithTag:1];
            tv.text = comment.comment;
            tv.delegate = self;
            tv.indexPath = indexPath;

            //削除ボタン
            FMButton *bt = (FMButton*)[cell viewWithTag:6];
            bt.indexPath = indexPath;
            [bt addTarget:self action:@selector(deleteBtPressed:) forControlEvents:UIControlEventTouchUpInside];

            
            //デバッグ用にずらしてあるビューを戻しておく
            UIView *commentView = (UIView*)[cell viewWithTag:4];
            UIView *settingView = (UIView*)[cell viewWithTag:8];
            commentView.center = cell.contentView.center;
            
            //公開スイッチ
            FMButton *disp_bt = (FMButton*)[cell viewWithTag:5];
            disp_bt.indexPath =  indexPath;
            
            UIImage *disp_image = ([comment.disp_flg isEqualToString:@"true"])? [UIImage imageNamed:@"on_image"]:[UIImage imageNamed:@"off_image"];
            [disp_bt setImage:disp_image forState:UIControlStateNormal];
            
            [disp_bt addTarget:self action:@selector(disp_btPressed:) forControlEvents:UIControlEventTouchUpInside];

            
            //設定ボタン
            FMButton  *button = (FMButton*)[cell viewWithTag:3];
            button.indexPath = indexPath;
            [button addTarget:self action:@selector(settingBtPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //ジェスチャ
            FMSwipeGestureRecognizer *ges;
            ges = [[FMSwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
            ges.indexPath = indexPath;
            [cell.contentView addGestureRecognizer:ges];
            
            //日付
            UILabel *lb_date = (UILabel*)[cell viewWithTag:2];
            lb_date.text = comment.date;
            
            /*
            //アニメーション
            commentView.alpha = 0;
            settingView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                commentView.alpha = 1;
            } completion:^(BOOL finished) {
                settingView.alpha = 1;
            }];
             */
            
            break;
             
        }
        
        case 2:{
            
            //追加ボタン
            UIButton *bt = (UIButton*)[cell viewWithTag:1];
            [bt addTarget:self action:@selector(addCommentPressed) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
            
            
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    CGFloat height;
    switch (indexPath.section) {
        case 0:{
            //フレンドの基本情報
            height = 135;
            break;
            
        }
        case 1:{
            //コメント
            height = 135;
            break;
            
        }
        case 2:{
            height = 61;

            break;
        }
            
        default:{
            break;
        }
    }
return height;
}




#pragma mark -
#pragma textView delegate

//編集終了後


- (void)textViewDidEndEditing:(FMTextView *)textView{

    NSLog(@"indexpath.row:%d",textView.indexPath.row);
    NSLog(@"comment:%@",textView.text);
    
    FMComment *comment = [_commentManager.comments objectAtIndex:textView.indexPath.row];
    [comment setComment:textView.text];
}


#pragma mark -
#pragma mark button action

- (void)disp_btPressed:(FMButton*)bt{
    
    
    FMComment *comment = _commentManager.comments[bt.indexPath.row];
    NSLog(@"disp_btPressed:indexpath.row:%d disp_flg:%@",bt.indexPath.row, comment.disp_flg);

    
    if ([comment.disp_flg isEqualToString:@"true"]) {
        comment.disp_flg = @"false";
        [bt setImage:[UIImage imageNamed:@"off_image"] forState:UIControlStateNormal];

        
    }else{
        comment.disp_flg = @"true";
        [bt setImage:[UIImage imageNamed:@"on_image"] forState:UIControlStateNormal];
    }
    
}



- (void)settingBtPressed:(FMButton*)bt{
    
    NSLog(@"settingBtPressed");
    [self moveSettingViewAtIndexPath:bt.indexPath];
 
}

- (void)didSwipe:(FMSwipeGestureRecognizer*)ges{
    
    if (ges.state == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left");
    }
    
    if (ges.state == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right");
    }
    
}


- (void)moveSettingViewAtIndexPath:(NSIndexPath*)indexPath{
    
    NSLog(@"settingBtPressedd");
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UIView *commentView = (UIView*)[cell viewWithTag:4];
    
    if (_settingIndexPath.row!=indexPath.row && _settingIndexPath) {
        return;
    }
    
    if (!_settingIndexPath) {
        //開く
        [UIView animateWithDuration:0.2 animations:^{
            commentView.center = CGPointMake(commentView.center.x-185, commentView.center.y);
        }];
        
        _settingIndexPath = indexPath;
        
        return;
    }
    
    if (_settingIndexPath) {
        //閉じる
        [UIView animateWithDuration:0.2 animations:^{
            commentView.center = cell.contentView.center;
        }];
        
        _settingIndexPath = nil;
        
        return;
    }
    
}



- (void)addCommentPressed{
    
    FMComment *comment = FMComment.new;
    [comment setTo_user:_friend.identifier];
    [comment setFrom_user:_user.id_facebook];
    [comment setDisp_flg:@"false"];
    
    [_commentManager addComment:comment];
    
    //セル追加
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_commentManager.comments.count-1 inSection:1];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    //テーブル更新
    for (int i = 0; i < _commentManager.comments.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }

    
}


- (void)deleteBtPressed:(FMButton*)bt{
    
    [_commentManager removeCommentAtIndex:bt.indexPath.row];
    
    //セル削除
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.indexPath.row inSection:1];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    //テーブル更新
    for (int i = 0; i < _commentManager.comments.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    _settingIndexPath = nil;
    
    
    
}

- (IBAction)savePressed:(id)sender {
    
    [self.view endEditing:YES];
    
    FMConnector *connector = [FMConnector sharedInstance];
    connector.delegate = self;
    [connector updateComments];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"Loading";
    
}


- (IBAction)backBtPressed:(id)sender {
    [self.viewDeckController closeRightView];

}



-(void)switchValueChanged:(FMSwitch*)sw{
    
    FMComment *comment = [_commentManager.comments objectAtIndex:sw.indexPath.row];
    comment.disp_flg = (sw.on)? @"true":@"false";
    
}




#pragma mark -
#pragma mark private method

- (void)downloadComments{
    
    [_commentManager setFrom_user:_user.id_facebook];
    [_commentManager setTo_user:_friend.identifier];
    
    _connector = [FMConnector sharedInstance];
    _connector.delegate = self;
    [_connector downloadComments];
    
    //インジケータの表示
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"Loading";

}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[_HUD removeFromSuperview];
	_HUD = nil;
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
        [comment setDate:[res objectForKey:@"created_at"]];
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_commentManager addComment:comment];
            NSInteger num  = [_commentManager.comments indexOfObject:comment];
            NSLog(@"test:num:%d",num);
            NSLog(@"comments:%d",_commentManager.comments.count);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num inSection:1];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //テーブル更新
        //[_tableView reloadData];
        [_HUD hide:YES];
    });
    


}


//アップデート完了
- (void)connectorDidFinishUpdating:(id)sender{
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = @"送信完了";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_HUD hide:YES afterDelay:2];
        
    });
    
}


//失敗
- (void)connectorDidFailLoadingWithError:(id)sener{
    NSLog(@"エラー");
}


@end
