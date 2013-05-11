//
//  BaseViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

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

}



-(void)viewDidAppear:(BOOL)animated {
    FriendsViewController *friendCon = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    
    IIViewDeckController *deckCon = [[IIViewDeckController alloc]initWithCenterViewController:friendCon];
    [self presentViewController:deckCon animated:NO completion:nil];

}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
