//
//  FMCommentManager.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/30.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMComment.h"

@interface FMCommentManager : NSObject

+ (FMCommentManager*)sharedManager;
- (void)addComment:(FMComment*)comment;
- (void)insertComment:(FMComment*)comment atIndex:(unsigned int)index;
- (void)removeCommentAtIndex:(unsigned int)index;
- (void)moveCommentFromIndex:(unsigned int)fromIndex toIndex:(unsigned int)toIndex;
- (void)update;


@property(nonatomic,strong) NSMutableArray *comments;
@property(nonatomic,strong) NSMutableArray *comments_removed;

@end
