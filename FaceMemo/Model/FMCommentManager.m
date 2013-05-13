//
//  FMCommentManager.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/30.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMCommentManager.h"
#import "FMClient.h"

@implementation FMCommentManager

static FMCommentManager *_sharedInstance  = nil;

+(FMCommentManager*)sharedManager{
    if (!_sharedInstance) {
        _sharedInstance = [[FMCommentManager alloc]init];
        
        //初期設定
        _sharedInstance.comments = NSMutableArray.new;
        _sharedInstance.comments_removed =NSMutableArray.new;
        
    }
    return _sharedInstance;
}


#pragma mark -
#pragma mark array operataion

//追加
-(void)addComment:(FMComment *)comment{
    if (!comment){
        return;
    }
    [_comments addObject:comment];
}


//挿入
-(void)insertComment:(FMComment *)comment atIndex:(unsigned int)index{
    if (!comment) {
        return;
    }
    if (index < 0 || index > _comments.count) {
        return;
    }

    [_comments insertObject:comment atIndex:index];
    
}


//削除
-(void)removeCommentAtIndex:(unsigned int)index{
    if (index < 0 || index > _comments.count - 1) {
        return;
    }
    
    [_comments removeObjectAtIndex:index];
    [_comments_removed addObject:[_comments objectAtIndex:index]];

}


//移動
-(void)moveCommentFromIndex:(unsigned int)fromIndex toIndex:(unsigned int)toIndex{
    //後で実装
}


//コメント一覧の更新
-(void)update{
    NSLog(@"commentManager:update");
   
    //新規作成、更新
    for (FMComment *comment in _comments){
        if (comment.identifier == nil) {
            [self createComment:comment];
        }else{
            [self updateComment:comment];
        }
    }
    
    //削除
    for (FMComment *comment in _comments_removed){
        [self deleteComment:comment];
    }


}


#pragma mark -
#pragma mark database operation

- (void)createComment:(FMComment*)comment{
    NSLog(@"commentManager:createComment");
    
    if (!comment) {
        return;
    }
    
    NSMutableDictionary *param;
    NSString     *path;
    FMClient     *client;
    
    NSLog(@"comment.disp_flg:%@",comment.disp_flg);
    NSLog(@"comment.from_user:%@",comment.from_user);
    
    param = [[NSMutableDictionary alloc]init];
    [param setObject:comment.comment forKey:@"comment"];
    [param setObject:comment.from_user forKey:@"from_user"];
    [param setObject:comment.disp_flg forKey:@"disp_flg"];
    [param setObject:comment.to_user forKey:@"to_user"];
    

    
    path = @"memo/create";
    
    NSLog(@"manager:param:%@",param.description);
    
    client = [[FMClient alloc]initWithBaseUrl:BASE_URL];
    [client postToPath:path param:param];
    
    
             
    
}


- (void)deleteComment:(FMComment*)comment{
    
}
         

- (void)updateComment:(FMComment*)comment{
    
}




@end
