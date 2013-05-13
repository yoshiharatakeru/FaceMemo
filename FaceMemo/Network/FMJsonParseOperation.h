//
//  FMJsonParseOperation.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMJsonParseOperationDelegate;

@interface FMJsonParseOperation : NSOperation
<NSURLConnectionDelegate>

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSMutableData *mutableData;
@property BOOL isExecuting;
@property BOOL isFinished;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) id parsedData;

-(id)initWithUrl:(NSURL*)url;

@end


@protocol FMJsonParserDelegate <NSObject>

- (void)operation:(FMJsonParseOperation*)operation didReceiveResponse:(NSHTTPURLResponse*)response;
- (void)operation:(FMJsonParseOperation*)operation didFailWithError:(NSError*)error;
- (void)operation:(FMJsonParseOperation*)operation didReceiveData:(NSData*)data;
- (void)operationDidFinishLoading:(FMJsonParseOperation*)operation;

@end