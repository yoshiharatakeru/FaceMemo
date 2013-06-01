//
//  InformationViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "InformationViewController.h"
#import "LicenceViewController.h"
#import "FeedbackViewController.h"


@interface InformationViewController ()
<UITableViewDataSource,
UITableViewDelegate>

{
    
    
    __weak IBOutlet UITableView *_tableView;
    
}

@end

@implementation InformationViewController

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
    
    //トラッキング
    self.trackedViewName = @"InformationView";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            break;
            
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            break;
            
        default:
            break;
    }
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        LicenceViewController *licenceViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"LicenceViewController"];
        [self.viewDeckController setRightController:licenceViewCon];
        self.viewDeckController.rightSize = 0;
        [self.viewDeckController toggleRightViewAnimated:YES];
    }
    
    if (indexPath.row == 2) {
        FeedbackViewController *feedBackViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
        [self.viewDeckController setRightController:feedBackViewCon];
        self.viewDeckController.rightSize = 0;
        [self.viewDeckController toggleRightViewAnimated:YES];
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backBtPressed:(id)sender {
    
    [self.viewDeckController toggleLeftView];
    
}



@end
