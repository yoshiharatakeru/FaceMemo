//
//  FMCommentNetworkOperation.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/14.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMComment.h"

@protocol FMCommentNetworkOperationDelegate;

@interface FMCommentNetworkOperation : NSOperation
<NSURLConnectionDelegate>

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,strong) NSMutableData *mutableData;
@property BOOL isExecuting;
@property BOOL isFinished;
@property (nonatomic, weak) id delegate;
@property (nonatomic,strong) NSArray *parsedData;
@property (nonatomic,strong) FMComment *comment;
@property (nonatomic,strong) NSString  *action;


-(id)initWithComment:(FMComment*)comment action:(NSString*)action;

@end


@protocol FMCommentNetworkOperationDelegate  <NSObject>

- (void)operation:(FMCommentNetworkOperation*)operation didReceiveResponse:(NSHTTPURLResponse*)response;
- (void)operation:(FMCommentNetworkOperation*)operation didFailWithError:(NSError*)error;
- (void)operation:(FMCommentNetworkOperation*)operation didReceiveData:(NSData*)data;
- (void)operationDidFinishLoading:(FMCommentNetworkOperation*)operation;

@end
