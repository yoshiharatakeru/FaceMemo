//
//  FMFeedbackNetworkOperation.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMFeedbackNetworkOperation.h"
#import "SBJson.h"


@implementation FMFeedbackNetworkOperation


- (id)initWithFeedback:(FMFeedback*)feedBack{
    NSLog(@"fmfeedbacknetworkoperation:init");
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _isExecuting = NO;
    _isFinished = NO;
    _feedback = feedBack;
    
    return self;
    
}


- (void)start{
    
    NSLog(@"FMFeedbackNetworkOperation:start");
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
    
    //エスケープ
    _feedback.userid = [self addEscape:_feedback.userid];
    _feedback.username = [self addEscape:_feedback.username];
    _feedback.content = [self addEscape:_feedback.content];
    _feedback.modelname = [self addEscape:_feedback.modelname];
    _feedback.model = [self addEscape:_feedback.model];
    _feedback.systemversion = [self addEscape:_feedback.systemversion];
    
    
    //パラメータ準備
    NSMutableString *textStr = [[NSMutableString alloc]init];
    NSString *path           = @"feedbacks/create";

    
    textStr = [NSString stringWithFormat:@"userid=%@&username=%@&content=%@&model=%@&modelname=%@&systemversion=%@",_feedback.userid, _feedback.username, _feedback.content, _feedback.model, _feedback.modelname, _feedback.systemversion];
    
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
