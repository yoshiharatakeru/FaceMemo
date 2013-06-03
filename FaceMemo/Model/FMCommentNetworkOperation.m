//
//  FMCommentNetworkOperation.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/14.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMCommentNetworkOperation.h"
#import "SBJson.h"

@implementation FMCommentNetworkOperation

- (id)initWithComment:(FMComment *)comment action:(NSString *)action{
    NSLog(@"fmcommentnetworkoperation:init");

    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _isExecuting = NO;
    _isFinished  = NO;
    _comment = comment;
    _action  = action;
    
    return self;
    
}


- (void)start{
    NSLog(@"operation:comment:%@",_comment.comment);
    
    
    NSLog(@"FMCommentNetworkOperation:start");
    _isExecuting = YES;
    
    //リクエスト作成
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
    
    
    //パラメータ準備
    NSMutableString *textStr = [[NSMutableString alloc]init];
    NSString *path           = [NSString stringWithFormat:@"memo/%@",_action];
    
    //アクションのに応じてパラム設定
    if ([_action isEqualToString:@"read"]) {
        textStr = [NSString stringWithFormat:@"from_user=%@&to_user=%@",_comment.from_user,_comment.to_user];
    }
    
    if ([_action isEqualToString:@"update"]) {
        textStr = [NSString stringWithFormat:@"id=%@&comment=%@&disp_flg=%@",_comment.identifier,_comment.comment,_comment.disp_flg];

    }
    
    if ([_action isEqualToString:@"delete"]) {
        textStr = [NSString stringWithFormat:@"id=%@",_comment.identifier];
    }
    
    if ([_action isEqualToString:@"create"]) {
        textStr = [NSString stringWithFormat:@"to_user=%@&from_user=%@&disp_flg=%@&comment=%@&date=%@",_comment.to_user,_comment.from_user,_comment.disp_flg,_comment.comment,_comment.date];
    }
    
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

#pragma  mark
#pragma NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"connection:didReceiveResponse");
    NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
    NSLog(@"statusCode:%d",res.statusCode);
    
    //バッファ作成
    _mutableData = [[NSMutableData alloc]init];
    
    [_delegate operation:self didReceiveResponse:res];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_mutableData appendData:data];
    
    [_delegate operation:self didReceiveData:data];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"FMCommentNetworkDidFailWithError:%@",error.localizedDescription);
    //TODO:通信エラー処理
    [_delegate operation:self didFailWithError:error];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"送信完了");
    //jsonをパースしたデータを作成
    NSString *encodedData = [[NSString alloc]initWithData:_mutableData encoding:NSUTF8StringEncoding];
    _parsedData = [encodedData JSONValue];
    
    [_delegate operationDidFinishLoading:self];
    
    _isExecuting = NO;
    _isFinished  = YES;
    _mutableData = nil;
}


@end
