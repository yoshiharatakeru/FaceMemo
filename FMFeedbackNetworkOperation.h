//
//  FMFeedbackNetworkOperation.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMFeedback.h"

@protocol FMFeedbackNetworkOperationDelegate;


@interface FMFeedbackNetworkOperation : NSOperation
<NSURLConnectionDelegate>

@property (nonatomic,strong) NSMutableData *mutableData;
@property BOOL isExecuting;
@property BOOL isFinished;
@property (nonatomic, weak) id delegate;
@property (nonatomic,strong) NSArray *parsedData;
@property (nonatomic,strong) FMFeedback *feedback;


-(id)initWithFeedback:(FMFeedback*)feedBack;


@end


@protocol FMFeedbackNetworkOperationDelegate <NSObject>

- (void)operation:(FMFeedbackNetworkOperation*)operation didReceiveResponse:(NSHTTPURLResponse*)response;
- (void)operation:(FMFeedbackNetworkOperation*)operation didFailWithError:(NSError*)error;
- (void)operation:(FMFeedbackNetworkOperation*)operation didReceiveData:(NSData*)data;
- (void)operationDidFinishLoading:(FMFeedbackNetworkOperation*)operation;


@end