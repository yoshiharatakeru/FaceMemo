//
//  LeftViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "LeftViewController.h"
#import "FriendsViewController.h"
#import "FMControllerManager.h"
#import "UserViewController.h"
#import "InformationViewController.h"

@interface LeftViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate 
>

@end

@implementation LeftViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDelegate,Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            break;
        }
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            break;
        }
        case 2:{
            cell  = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            break;
        }
            
        case 3:{
            cell  = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            break;
        }
            
        default:
            break;
    }
    
    //[self updateCell:cell atIndexPath:indexPath];
    
    return cell ;

}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    switch (indexPath.row) {
        case 0:{
            break;
        }
        case 1:{
            //途中
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [cell.contentView addGestureRecognizer:pan];
            
            
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            break;
        }

        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMControllerManager *controllerManager = [FMControllerManager sharedManager];
    switch (indexPath.row) {
        
        case 0:{//friends
            if (controllerManager.friendViewController) {
                [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                    controller.centerController = controllerManager.friendViewController;
            }];
            }
            
            break;
        }
            
        
        case 1:{//you
            
            UserViewController *userViewCon;
            
            if (controllerManager.userViewController) {
                userViewCon = controllerManager.userViewController;
            
            }else{//初めて開くときには新規に作成
                userViewCon =  [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
            }
            
            //開く
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                controller.centerController = userViewCon;
            }];
                
            break;
        }
        
            
        case 2:{//information
            InformationViewController *infoViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                controller.centerController = infoViewCon;
            }];
            
            
            break;
        }
            
        
        case 3:{//logout
            NSString *message  = @"ログアウトしてもよろしいですか";
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"ログアウト", nil];
            [al show];
            
            break;
        }
        
        default:
            break;
    }
 
    
}


#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self logout];
    }
}

#pragma mark -
#pragma mark private method
- (void)logout{
    
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        [_delegate leftViewControllerDidPressLogout:self];
    }];

}


- (void)tap:(UIPanGestureRecognizer*)ges{
    NSLog(@"tap");
}

@end
