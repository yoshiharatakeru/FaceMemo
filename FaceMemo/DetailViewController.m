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

@interface DetailViewController ()

< UITableViewDataSource,
  UITableViewDelegate,
  UITextFieldDelegate >



@end

@implementation DetailViewController

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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //TODO:コメント取得
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [_tableView reloadData];
    
    
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
        
        case 0:{
            //フレンドの基本情報
            UILabel *lb_name= (UILabel*)[cell viewWithTag:1];
            lb_name.text = _friend.name;
            NSLog(@"name:%@",_friend.name);
            
            break;
        }
        
        case 1:{
            //フレンドの既存情報
            MyTextField *tf = (MyTextField*)[cell viewWithTag:1];
            tf.delegate = self;
            
            break;
        }
        
        case 2:{
            //追加ボタン
            UIButton *bt = (UIButton*)[cell viewWithTag:1];
            [bt addTarget:self action:@selector(addSectionPressed) forControlEvents:UIControlEventTouchUpInside];

            
            
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
            height = 160;
            break;
            
        }
        case 1:{
            //フレンドの既存情報
            height = 44;
            break;
            
        }
        case 2:{
            height = 60;

            break;
        }
            
        default:{
            break;
        }
    }
return height;
}


#pragma mark -
#pragma textField delegate

//編集終了後
- (void)textFieldDidEndEditing:(MyTextField *)textField{
    
    FMComment *comment = [_commentManager.comments objectAtIndex:textField.indexPath.row];
    [comment setComment:textField.text];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
}

#pragma mark -
#pragma mark button action

- (void)addSectionPressed{
    FMComment *comment = FMComment.new;
    [comment setTo_user:_friend.name];
    [comment setFrom_user:_user.name];
    [comment setDisp_flg:@"falset"];
    NSLog(@"_user.name:%@",_user.name);
    
    _commentManager= [FMCommentManager sharedManager];
    [_commentManager addComment:comment];
    NSLog(@"num: %d",_commentManager.comments.count);
    
    //テーブルの更新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_commentManager.comments.count-1 inSection:1];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (IBAction)savePressed:(id)sender {
    NSLog(@"DetailCon:savePressed");
    NSLog(@"numarray:%d",_commentManager.comments.count);
    [_commentManager update];
}



- (IBAction)cancelPressed:(id)sender {
}


    
@end
