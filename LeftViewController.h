//
//  LeftViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

@protocol LeftViewControllerDelegate;

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id delegate;


@end


@protocol LeftViewControllerDelegate <NSObject>

- (void)leftViewControllerDidPressLogout:(id)sender;

@end