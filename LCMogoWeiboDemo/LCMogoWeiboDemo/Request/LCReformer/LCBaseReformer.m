//
//  LCBaseReformer.m
//  LCMogoWeiboDemo
//
//  Created by 李策 on 16/4/19.
//  Copyright © 2016年 李策. All rights reserved.
//

#import "LCBaseReformer.h"
#import "MBProgressHUD.h"


@interface LCBaseReformer ()
@property (nonatomic , assign) BOOL refresh;
@end

@implementation LCBaseReformer

#pragma mark 参数是否为空的判断  1、参数   2、参数名  3、错误信息
- (BOOL)judgeParamsState:(id)param paramName:(NSString *)paramName{
    if(!param){
//        [ZGTXParamsNullTool writeToErrorMesLog:@"参数不能为空" paramName:paramName];
        return NO;
    }
    return YES;
}
#pragma mark 加密相关-------
//使用AES加密
- (NSString *)useAESEncrypted:(NSDictionary *)encryptedDic{
    //将字典转变为json字符串
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:encryptedDic options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //将字符串加密
//    NSString *encryptJson = [ZGTXEncryptAndDecryptTool useAESEncrypted:jsonStr];
//    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encryptJson, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return @"等待学习";
}
//使用RSA加密
- (NSString *)useRSAEncrypted:(NSDictionary *)encryptedDic{
    //将字典转变为json字符串
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:encryptedDic options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    //将字符串加密
//    NSString *encryptJson = [ZGTXEncryptAndDecryptTool useRSAEncrypted:jsonStr];
//    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encryptJson, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    
    return @"暂时没有实现";
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isOpenED = NO;//是否打开加密解密功能
        
        self.manager = [LCRequestManager sharedManager];
        
        self.appCache = [LCURLCache sharedCache];
        self.myRequest = [[LCRequsestBase alloc]init];
    }
    return self;
}
#pragma mark - public methods
#pragma mark - 开始请求
- (void)startWithRequest:(LCRequsestBase *)request withView:(UIView *)view
{
#warning FUTURE  将唯一标识  与二级标识保存到reformer留做以后用
    self.identfier = request.identifier;
    if(request.secondIden){
        self.secondIden = request.secondIden;
    }

    //缓存是否存在标识
    BOOL exsist = NO;
    
    if(request.cachePolicy != LCRequestCacheNone){
        //判断是否有缓存，缓存是否过期，有缓存不过期为真
        exsist = [self isExsistOrExpireCache:request.identifier expiredInteval:request.cacheExpiredTime];
    }
    
    if (exsist) {//有缓存并且没有过期，从数据库中请求数据
        
        if (self.delegate || [self.delegate respondsToSelector:@selector(reformerGetAppCacheWith:)]) {
            id cacheData = [self.appCache getBackData:request.identifier];
            [self getAppCache:cacheData];
            [self.delegate reformerGetAppCacheWith:self];
        }
    }else{//没有缓存或者缓存过期了，从网络请求
        [self requestDataWith:request andView:view];
    }
}
#pragma mark - 刷新数据方法
- (void)refreshDataWithRequest:(LCRequsestBase *)request
{    self.refresh = YES;
    [self requestDataWith:request andView:nil];
}
- (BOOL)isRefresh{
    return self.refresh;
}
#warning NOTICE 空方法子类调用
- (LCRequsestBase *)prepareRequest
{
#warning token 处理重新登录
//    NSString *tokenId = [NSString getTokenId];
//    if (tokenId) {
//        [self.zgRequest.params setObject:tokenId forKey:kTokenId];
//    }else{
//        [self reLogin];
//    }
    return nil;
}

#pragma mark -  判断是否存在缓存
- (BOOL)isExsistOrExpireCache:(NSString *)identifier expiredInteval:(LCCacheExpiredTime)expiredTime
{
    BOOL result = [self.appCache isExistCache:identifier expiredTime:expiredTime];
    if (result) {
        ReqLog(@"存在且没有过期");
    }else{
        ReqLog(@"不存在或者过期");
    }
    return result;
}
#pragma mark - 获得假数据
- (NSDictionary *)replaceDataFromFakeDataWithIdentifier:(LCFakeDataParams *)fakeDataParams
{
    if (fakeDataParams.identifier.length == 0) {//如果没有唯一标示直接返回空
        return nil;
    }
    NSString *dataPath = nil;
    
    if(fakeDataParams.secondIden.length > 0){
#warning read 本地假数据
        NSString *pathFull = [NSString stringWithFormat:@"%@_%@_list",fakeDataParams.identifier,fakeDataParams.secondIden];
        dataPath = [[NSBundle mainBundle] pathForResource:pathFull ofType:@"json"];
        ReqLog(@"%@",pathFull);

    }else{
        dataPath = [[NSBundle mainBundle] pathForResource:fakeDataParams.identifier ofType:@"json"];
        ReqLog(@"%@",dataPath);

    }
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return response;
}
#pragma mark - 取消所有的请求
- (void)cancelReformerAllOperations
{
    [self.manager cancelAllOperations];
}
#pragma mark - private methods

- (void)requestDataWith:(LCRequsestBase *)request andView:(UIView *)view
{
    self.manager.delegate = self;
    [self.manager startRequest:request withView:view];
}

#pragma mark - 用HUD显示错误信息
- (void)showHudMes:(NSString *)mes hiddenDelay:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = mes;
    hud.margin = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.alpha = 0.7;
    [hud hide:YES afterDelay:time];
}
#pragma mark - 添加缓存
- (void)addCacheWithRequest:(LCRequsestBase *)request response:(LCResponse *)response
{
    BOOL re = [self.appCache addCacheWithContent:response.responseObject cachePolicy:self.myRequest.cachePolicy userInfo:response.userInfo identifier:self.myRequest.identifier];
    if (re) {
        ReqLog(@"插入成功");
    }else{
        ReqLog(@"插入数据失败");
    }
}
#pragma mark - 更新缓存
- (void)updateCacheWithRequest:(LCRequsestBase *)request response:(LCResponse *)response
{
    BOOL re = [self.appCache updateDataWithIdentifier:self.myRequest.identifier content:response.responseObject];
    if (re) {
        ReqLog(@"更新成功");
    }else{
        ReqLog(@"更新数据失败");
    }
}
#pragma mark - requestManager delegate
/**
 *  请求成功回调方法
 *
 *  @param response 返回数据
 */
- (void)requestSuccess:(LCResponse *)response
{
    self.response = response;
    //成功后取消错误界面
    
    //成功后回调方法
    if([self.delegate respondsToSelector:@selector(reformerSuccessWith:)]){
        [self.delegate reformerSuccessWith:self];
    }
    /**
     *  拿到子类重组的缓存数据
     */
    
    response.responseObject = [self recombinantDataWith:response.responseObject];
//    NSLog(@"%@",response.responseObject);
    //当request的策略为有缓存的时候，返回的数据字典存到数据库
    if (self.myRequest.cachePolicy != LCRequestCacheNone) {
        if ([self.appCache isExistCache:self.myRequest.identifier]) {//有缓存过期更新 到这一步肯定过期
            [self updateCacheWithRequest:self.myRequest response:response];
        }else{//没有缓存  添加
            [self addCacheWithRequest:self.myRequest response:response];
        }
    }
}
/**
 *  请求失败回调方法
 *
 *  @param response 返回数据
 */
- (void)requestFailure:(LCResponse *)response
{
    self.response = response;
    if([self.delegate respondsToSelector:@selector(reformerFailureWith:)]){
        
        [self.delegate reformerFailureWith:self];
    }
    
    
    if (response.error.code == -1004) {//请求超时
        [self showHudMes:@"网络异常" hiddenDelay:1];
    }else if(response.error.code == - 1009){
//        [self showHudMes:@"没有网络" hiddenDelay:1];

    }
    ReqLog(@"%ld",response.error.code);
}
#pragma mark**读取本地缓存,有缓存且没有过期是执行**
- (void)getAppCache:(id)cacheDict{

}
#pragma mark - 重组数据 父类中为空方法，由子类调用
- (id)recombinantDataWith:(NSDictionary *)data
{
#warning errCode 处理异常
    if ([data[@"errCode"] isEqualToString:@"2002"] ) {//如果返回2002过期
//        [self reLogin];
        return nil;
    }
    
//    LCLogError(@"%@",data[@"errCode"]);
    if([data[@"errCode"] isEqualToString:@"2001"] || [data[@"errCode"] isEqualToString:@"2003"]){//返回2001 或者2003
        [self showHudMes:data[@"mess"] hiddenDelay:1.25];
        return nil;
    }
    return data;
}
#pragma mark - re login
//- (void)reLogin
//{
//    UIWindow *lastWindow = [UIApplication sharedApplication].windows.lastObject;
//    UIButton *coverBtn = [[UIButton alloc] initWithFrame:lastWindow.bounds];
//    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];//为了让背景不可点击
//    [lastWindow addSubview:coverBtn];
//    
//    [self showHudMes:@"登录过期，请重新登录" hiddenDelay:1.25];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIslogined];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [coverBtn removeFromSuperview];
//        [[[UIApplication sharedApplication].delegate window] chooseRootVC];
//    });
//}
- (void)coverBtnClick{
    
}
#pragma mark - getter
- (LCFakeDataParams *)fakeDataParams
{
    if(nil == _fakeDataParams){
        _fakeDataParams = [[LCFakeDataParams alloc]init];
    }
    return _fakeDataParams;
}

@end