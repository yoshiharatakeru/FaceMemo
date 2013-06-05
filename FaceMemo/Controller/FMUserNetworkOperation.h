//
//  FMUserNetworkOperation.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/06/03.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMUser.h"


@interface FMUserNetworkOperation : NSOperation

@property (nonatomic,strong) FMUser *user;
@property BOOL isExecuting;
@property BOOL isFinished;
@property (nonatomic, weak) id delegate;
@property (nonatomic,strong) NSArray *parsedData;


- (id)initWithUser:(FMUser*)user;

@end
