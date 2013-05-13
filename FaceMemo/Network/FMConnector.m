//
//  FMConnector.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMConnector.h"
#import "FMCommentManager.h"

@implementation FMConnector

+ (FMConnector*)sharedConnector{
    
}


- (BOOL)isNetworkAccessing{
    return _retrieveCommentsOperations > 0;
    
}


- (void)refreshComments{
    
    if ([self isRefreshingComments]) {
        return;
    }
    
    BOOL networkAccessing = _networkAccessing;
    
    //コメント一覧を取得
    

    
    
    
    
}

@end
