//
//  FMConnector.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMConnector.h"
#import "FMCommentManager.h"
#import "FMCommentNetworkOperation.h"
#import "FMUser.h"
#import "FMFriendManager.h"

static FMConnector *_sharedInstance = nil;

@implementation FMConnector

+ (FMConnector*)sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance =[[FMConnector alloc]init];
        _sharedInstance.retrieveCommentsOperations = NSMutableArray.new;
    }
    
    return _sharedInstance;
    
}


+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone*)zone{
    
    return self;
    
}


- (BOOL)isNetworkAccessing{
    return _retrieveCommentsOperations > 0;
    
}



- (void)downloadComments{
    
    //ロード開始を通知
    [_delegate connectorDidBeginLoading:self];
    
    FMCommentManager *manager = [FMCommentManager sharedManager];
    NSString *to_user = manager.to_user;
    NSString *from_user = manager.from_user;
    NSLog(@"connector:downloadcomment:to_uer:%@",to_user);
    NSLog(@"connector:downloadcomment:from_user:%@",from_user);
    
    FMComment *comment = FMComment.new;
    [comment setTo_user:to_user];
    [comment setFrom_user:from_user];
    
    FMCommentNetworkOperation *op;
    op = [[FMCommentNetworkOperation alloc]initWithComment:comment action:@"read"];
    op.delegate = self;
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:op];
    
}


- (void)updateComments {
    
//    if ([self isRefreshingComments]) {
//        return;
//    }
    
    [_delegate connectorDidBeginLoading:self];
    FMCommentManager *commentManager = [FMCommentManager sharedManager];
    NSOperationQueue *queue = NSOperationQueue.new;
    
    //追加、更新
    for (FMComment *comment in commentManager.comments) {
        NSLog(@"connector:comment:%@",comment.comment);
        
        FMCommentNetworkOperation *op;
        
        if (comment.identifier) {//更新
            op = [[FMCommentNetworkOperation alloc]initWithComment:comment action:@"update"];
            op.delegate = self;

            
       
        }else{//新規作成
            op = [[FMCommentNetworkOperation alloc]initWithComment:comment action:@"create"];
            op.delegate = self;

            
        }
        [queue addOperation:op];
        [_retrieveCommentsOperations addObject:op];
         
    
    }
    
    //削除
    for (FMComment *comment in commentManager.comments_removed) {
        NSLog(@"削除す");
        FMCommentNetworkOperation *op;
        
        op = [[FMCommentNetworkOperation alloc]initWithComment:comment action:@"delete"];
        op.delegate = self;

        [queue addOperation:op];
        [_retrieveCommentsOperations addObject:op];
    
    }
      
    BOOL networkAccessing = _networkAccessing;

}



#pragma mark -
#pragma mark FMCommentNetworkOperationDelegate

- (void)operation:(FMCommentNetworkOperation*)operation didReceiveResponse:(NSHTTPURLResponse*)response{
    
    //エラー処理
    
}
- (void)operation:(FMCommentNetworkOperation*)operation didFailWithError:(NSError*)error{
    
    //エラー処理
    [_delegate connectorDidFailLoadingWithError:self];
    
}
- (void)operation:(FMCommentNetworkOperation*)operation didReceiveData:(NSData*)data{
    
    
}
- (void)operationDidFinishLoading:(FMCommentNetworkOperation*)operation{
    
    
    if ([operation.action isEqualToString:@"read"]) {
        //ダウンロードの完了を通知
        [_delegate connector:self didFinishDownLoading:operation.parsedData];
    
    }
    
    if ([operation.action isEqualToString:@"update"]||
        [operation.action isEqualToString:@"create"]||
        [operation.action isEqualToString:@"delete"]) {
       
        [_retrieveCommentsOperations removeObject:operation];
        
        if (_retrieveCommentsOperations.count == 0) {
            //更新の完了を通知
            [_delegate connectorDidFinishUpdating:self];
        }
     
    }

    
}

@end
