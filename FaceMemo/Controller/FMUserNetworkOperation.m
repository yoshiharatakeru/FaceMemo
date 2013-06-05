//
//  FMUserNetworkOperation.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/06/03.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMUserNetworkOperation.h"

@implementation FMUserNetworkOperation

- (id)initWithUser:(FMUser*)user{
    
    NSLog(@"FMUserNetworkOperation:init");
    
    self = [super  init];
    
    if (!self) {
        return nil;
    }
    
    _isExecuting = NO;
    _isFinished = NO;
    _user = user;
    
    return self;
    
}




- (void)start{
    
    NSLog(@"FMUserNetworkOperation:start");
    _isExecuting = YES;
    
    //リクエスト
    NSMutableURLRequest *req = [self setRequest];
    
    //コネクション作成
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    
    // NSURLConnection は RunLoop をまわさないとメインスレッド以外で動かない
    if (connection != nil) {
        do{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            
            if ([self isCancelled]) {
                
            }
        } while(_isExecuting);
    }
    
}


- (BOOL)isConcurrent{
    
    return YES;
    
}


- (NSMutableURLRequest*)setRequest{
    
    //エスケープ
    _user.id_facebook = [self addEscape:_user.id_facebook];
    _user.username = [self addEscape:_user.username];
    _user.first_name = [self addEscape:_user.first_name];
    _user.last_name = [self addEscape:_user.last_name];
    _user.username = [self addEscape:_user.username];
    _user.middle_name = [self addEscape:_user.middle_name];
      
    
    //パラメータ準備
    NSMutableString *textStr = [[NSMutableString alloc]init];
    NSString *path           = @"sample/create";
    
    
    textStr = [NSString stringWithFormat:@"name=%@&id_facebook=%@",_user.name,_user.id_facebook];
    
    NSLog(@"text:%@",textStr);
    
    
    //url準備
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,path];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"FMCommentNetworkOperation:url:%@",urlString);
    
    
    //リクエスト準備
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"textStr:%@",textStr);
    //ヘッダ,ボディ準備
    [req setHTTPMethod:@"POST"];
    [req setValue:@"multipart/form-data"forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[textStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return req;
    
}


//エスケープ
-(NSString*)addEscape:(NSString*)str{
    
    if (![str isKindOfClass:[NSString class]]) {
        return str;
    }
    
    NSString *result;
    result = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return result;
    
}

@end
