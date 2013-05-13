//
//  FMConnector.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMConnector : NSObject
@property(nonatomic,readonly) BOOL networkAccessing;

@property(nonatomic,strong) NSMutableArray *retrieveCommentsOperations;

+ (FMConnector*)sharedConnector;

- (void)refreshComments;
- (void)cancelRefreshComments;
- (BOOL)isRefreshingComments;
- (float)progressOfRefreshComments;

@end
