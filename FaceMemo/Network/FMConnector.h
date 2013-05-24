//
//  FMConnector.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMConnectorDelegate;


@interface FMConnector : NSObject

@property(nonatomic,readonly) BOOL networkAccessing;
@property(nonatomic,strong) NSMutableArray *retrieveCommentsOperations;
@property(nonatomic, weak) id delegate;

+ (FMConnector*)sharedInstance;

- (void)updateComments;
- (void)downloadComments;
- (void)cancelRefreshComments;
- (BOOL)isRefreshingComments;
- (float)progressOfRefreshComments;

@end


@protocol FMConnectorDelegate <NSObject>

- (void)connectorDidBeginLoading:(id)sender;
- (void)connector:(FMConnector*)connector didFinishDownLoading:(id)responseData;
- (void)connectorDidFinishUpdating:(id)sender;
- (void)connectorDidFailLoadingWithError:(id)sener;

@end