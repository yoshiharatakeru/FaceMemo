//
//  FMClient.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMClient.h"
#import "SBJson.h"

@implementation FMClient
-(id)initWithBaseUrl:(NSString *)baseUrl{
    self = [super init];
    if (!self) {
        return nil;
    }
    _baseUrl = baseUrl;
    return self;
}


-(id)authorize{
    
    //現状ではただ登録するのみ
    //TODO:初めてのユーザーのみを検出してデータベースに登録
    NSString *path = @"sample/index";
    NSString *url_str = [_baseUrl stringByAppendingFormat:path];
    [self requestToURL:url_str method:@"POST"];
    return self;
    
}


- (void)postToPath:(NSString*)path param:(NSDictionary*)param{
    NSLog(@"client:postToPath");
    
    NSLog(@"client:param:%@",param.description);
    //パラメータ作成
    NSString *param_Str = [NSString string];
    NSArray *keys = param.allKeys;
    NSLog(@"clietn:param.allkeys:%@",keys);
    for (NSString *key in keys) {
        NSString *value_escaped = [self addEscape:[param objectForKey:key]];
        NSLog(@"value_escaped:%@",value_escaped);
        NSString *a = [NSString stringWithFormat:@"%@=%@&",key, value_escaped];
        param_Str = [param_Str stringByAppendingFormat:a];
    }
    NSLog(@"param_Str:%@",param_Str);
    
    //url作成
    NSString *url_str;
    url_str = [NSString stringWithFormat:@"%@%@?%@",_baseUrl, path, param_Str];
    NSLog(@"url_str:%@",url_str);
    
    [self requestToURL:url_str method:@"POST"];
     
}


-(void)requestToURL:(NSString*)url_str method:(NSString*)method
{
    NSLog(@"client:request");
    //TODO:ちゃんと書く
    
    NSData        *data = nil;
    NSError       *err  = nil;
    NSHTTPURLResponse *res = nil;
    NSURL         *url;
    
    //リクエスト準備
    url = [NSURL URLWithString:url_str];
    NSLog(@"url:%@",[url absoluteString]);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    
    //送信
    data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    //エラーハンドリング
    NSLog(@"statuscode:%d",res.statusCode);
    if (err) {
        NSLog(@"nSURLException:%@#", err.localizedDescription);
        NSException *exception = [NSException exceptionWithName:@"nSURLException" reason:err.localizedDescription userInfo:nil];
        [exception raise];
    }
    
    //TODO:ステータスコードに応じたエラーハンドリング
    
    
    
    
    //結果の取得
    NSString *encodedStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [encodedStr JSONValue];
    NSLog(@"jsonData:%@",jsonData.description);
    
    

    
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

