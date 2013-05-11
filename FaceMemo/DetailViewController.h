//
//  DetailViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFriend.h"
#import "FMCommentManager.h"
#import "FMUser.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *
tableView;
@property(nonatomic,strong) FMFriend *friend;
@property(nonatomic,strong) FMUser   *user;
@property(nonatomic,strong) FMCommentManager *commentManager;


@end
