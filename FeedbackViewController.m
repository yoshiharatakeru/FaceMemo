//
//  FeedbackViewController.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FMFeedback.h"
#import "FMUser.h"
#import "FMFeedbackNetworkOperation.h"

@interface FeedbackViewController ()
<UITextViewDelegate, FMFeedbackNetworkOperationDelegate, MBProgressHUDDelegate>

{
    
    __weak IBOutlet UITextView *_textView;
}

@end

@implementation FeedbackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //詳細情報を用意
    UIDevice *dev = [UIDevice currentDevice];
    NSLog(@"name:%@",dev.name);
    NSLog(@"model:%@",dev.model);
    NSLog(@"localizeModel:%@",dev.localizedModel);
    NSLog(@"systemName:%@",dev.systemName);
    NSLog(@"systemVersion:%@",dev.systemVersion);
    
    FMUser *user = [FMUser sharedInstance];
    
    _feedback = FMFeedback.new;
    
    [_feedback setUserid:user.id_facebook];
    [_feedback setUsername:user.username];
    [_feedback setModelname:dev.name];
    [_feedback setModel:dev.model];
    [_feedback setSystemversion:dev.systemVersion];
    
    
    //トラッキング
    self.trackedViewName = @"FeedbackView";
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [_textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    [_feedback setContent:textView.text];
}


- (IBAction)sendBtPressed:(id)sender {
    [_textView resignFirstResponder];
    
    _queue = [[NSOperationQueue alloc]init];
    FMFeedbackNetworkOperation *op = [[FMFeedbackNetworkOperation alloc]initWithFeedback:_feedback];
    op.delegate = self;
    [_queue addOperation:op];
    
    //インジケータ
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"Loading";
    
    
}


- (IBAction)backBtPressed:(id)sender {
    [_textView resignFirstResponder];
    [_feedback setContent:_textView.text];
    [self.viewDeckController closeRightView];
    
}


#pragma mark -
#pragma mark FMFeedbackNetworkOperationDelegate

- (void)operation:(FMFeedbackNetworkOperation*)operation didReceiveResponse:(NSHTTPURLResponse*)response{
    
    //エラー処理
    
}
- (void)operation:(FMFeedbackNetworkOperation*)operation didFailWithError:(NSError*)error{
    
    //エラー処理
    
}
- (void)operation:(FMFeedbackNetworkOperation*)operation didReceiveData:(NSData*)data{
    
    
}
- (void)operationDidFinishLoading:(FMFeedbackNetworkOperation*)operation{
 
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = @"OK";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_HUD hide:YES afterDelay:2];
        [self.viewDeckController closeRightView];
        
    });

 
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[_HUD removeFromSuperview];
	_HUD = nil;
}




@end
