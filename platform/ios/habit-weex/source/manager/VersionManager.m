//
//  VersionManager.m
//  版本管理器
//  Created by hzm on 17/07/13.
//  Copyright (c) 2017年 winupon. All rights reserved.
//

#import "VersionManager.h"
#import "AppMacro.h"
#import <TBXML.h>
#import <SSZipArchive.h>



@interface VersionManager()

@property (nonatomic, copy) NSString *remoteVersion;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, copy) CheckFinishBlock checkFinishBlock;

@end



@implementation VersionManager

+ (instancetype)sharedInstance
{
    static VersionManager *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[VersionManager alloc] init];
        
    });
    return instance;
}

- (void)checkAppVersion:(void (^)())complete
{
    [self checkRemoteVersion:^(BOOL success) {
        if (!success) {
            if (complete) {
                complete();
            }
            return;
        }
        
        _checkFinishBlock = complete;
        [self checkNeedUpdate];
    }];
}

// 流程1
- (void)checkRemoteVersion:(void (^)(BOOL success))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/update.xml", VAESION_CHECK_URL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                TBXML *tbxml = [[TBXML alloc] initWithXMLData:data error:nil];
                TBXMLElement *root = tbxml.rootXMLElement;
                if (root) {
                    TBXMLElement *noteElement = [TBXML childElementNamed:@"IOS" parentElement:root];
                    if (noteElement != nil) {
                        //版本号
                        TBXMLElement *CDateElement = [TBXML childElementNamed:@"version" parentElement:noteElement];
                        if (CDateElement != nil) {
                            _remoteVersion = [TBXML textForElement:CDateElement];
                        }
                        //下载地址
                        TBXMLElement *CDateElement1 = [TBXML childElementNamed:@"download" parentElement:noteElement];
                        if (CDateElement1 != nil) {
                            _downloadUrl = [TBXML textForElement:CDateElement1];
                        }
                        //是否强制升级
                        TBXMLElement *CDateElement2 = [TBXML childElementNamed:@"force" parentElement:noteElement];
                        if (CDateElement2 != nil) {
                            _forceUpdate = [TBXML textForElement:CDateElement2].boolValue;
                        }
                        
                        if (complete) {
                            complete(YES);
                        }
                        return;
                    }
                }
            }
            if (complete) {
                complete(NO);
            }
        });
    }];
    [task resume];
}

// 流程2
- (void)checkNeedUpdate
{
    NSString *localVersion = [self localVersion];
    if ([self compareVersion:localVersion to:_remoteVersion] != VersionCompareLow) {
        [self checkNeedCleanPatch];
        return;
    }
    
    NSInteger major1 = 0;
    NSInteger minor1 = 0;
    NSInteger micro1 = 0;
    NSInteger major2 = 0;
    NSInteger minor2 = 0;
    NSInteger micro2 = 0;
    
    [self getVersion:localVersion major:&major1 minor:&minor1 micro:&micro1];
    [self getVersion:_remoteVersion major:&major2 minor:&minor2 micro:&micro2];
    
    if (major1 != major2 || minor1 != minor2) {
        [self popUpdateBinDialog];
        return;
    }
    
    [self startUpdatePatch];
}

// 流程2-1
- (void)popUpdateBinDialog
{
    NSString *msg = [NSString stringWithFormat:@"有新的版本 %@ 可供更新，您当前使用的应用版本号为 %@，请前往更新", _remoteVersion, [self localVersion]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:msg preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:_downloadUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    if (!_forceUpdate) {
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [self onCheckNeedUpdateEnd];
        }];
        [alert addAction: cancel];
    }
    [alert addAction: confirm];
    [[self currentViewController] presentViewController:alert animated:YES completion:nil];
}

// 流程2-2
- (void)startUpdatePatch
{
    NSInteger major1 = 0;
    NSInteger minor1 = 0;
    NSInteger micro1 = 0;
    NSInteger major2 = 0;
    NSInteger minor2 = 0;
    NSInteger micro2 = 0;
    
    [self getVersion:[self localVersion] major:&major1 minor:&minor1 micro:&micro1];
    [self getVersion:_remoteVersion major:&major2 minor:&minor2 micro:&micro2];
    for (NSInteger i = micro1 + 1; i <= micro2; ++i) {
        NSString *ver = [NSString stringWithFormat:@"%zd.%zd.%zd", major1, minor1, i];
        NSString *verFile = [NSString stringWithFormat:@"%@/patch/%@.zip", VAESION_CHECK_URL, ver];
        if ([self isFileExist:verFile]) {
            [self downLoadPatch:ver];
            return;
        }
    }
    
    [self onCheckNeedUpdateEnd];
}

// 流程2-2-1
- (void)downLoadPatch:(NSString *)ver
{
    // 1. 创建url
    NSString *urlStr = [NSString stringWithFormat:@"%@/patch/%@.zip", VAESION_CHECK_URL, ver];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            BOOL extractOK = [self extractPatchZipFile:[location path]];
            [self removePatchZipFile:[location path]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (extractOK) {
                    [self writeVersionFile:ver];
                }
                else {
                    [self onCheckNeedUpdateEnd];
                }
            });
        }
        else {
            NSLog(@"download patch error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onCheckNeedUpdateEnd];
            });
        }
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
}

// 流程2-2-2
- (BOOL)extractPatchZipFile:(NSString *)file
{
    NSString *extractPath = [self patchPath];
    return [SSZipArchive unzipFileAtPath:file toDestination:extractPath];
}

// 流程2-2-3
- (BOOL)removePatchZipFile:(NSString *)file
{
    return [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
}

// 流程2-2-4
- (void)writeVersionFile:(NSString *)ver
{
    NSString *file = [NSString stringWithFormat:@"%@/version.txt", [self patchPath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:file contents:[ver dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    [self checkNeedUpdate];
}

- (void)onCheckNeedUpdateEnd
{
    [self checkNeedCleanPatch];
}

// 流程3
- (void)checkNeedCleanPatch
{
    NSString *binVer = [self binVersion];
    NSString *patchVer = [self patchVersion];
    if ([self compareVersion:binVer to:patchVer] == VersionCompareHigh) {
        [[NSFileManager defaultManager] removeItemAtPath:[self patchPath] error:nil];
    }
    
    [self checkVersionEnd];
}

// 流程4
- (void)checkVersionEnd
{
    if (_checkFinishBlock != nil) {
        _checkFinishBlock();
    }
}

- (UIViewController *)currentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return lastViewController;
    }
    UIViewController *presViewController = rootViewController.presentedViewController;
    if (presViewController != nil) {
        return rootViewController;
    }
    return rootViewController;
}

- (NSString *)localVersion
{
    NSString *binVersion = [self binVersion];
    NSString *patchVersion = [self patchVersion];
    if ([patchVersion isEqualToString:@""]) {
        return binVersion;
    }
    if ([self compareVersion:patchVersion to:binVersion] == VersionCompareHigh) {
        return patchVersion;
    }
    return binVersion;
}

- (NSString *)binVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)patchVersion
{
    NSString *path = [self patchPath];
    if ([path isEqualToString:@""]) {
        return @"";
    }
    NSString *file = [NSString stringWithFormat:@"%@/version.txt", path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        return @"";
    }
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (NSString *)applicationPath
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    if (nil == arr || [arr count] == 0){
        return @"";
    }
    
    NSString *app = arr[0];
    return app;
}

- (NSString *)patchPath
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (nil == arr || [arr count] == 0){
        return @"";
    }
    
    NSString *documents = arr[0];
    if ([documents isEqualToString:@""]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@/patch", documents];
}

- (void)getVersion:(NSString *)ver major:(NSInteger *)major minor:(NSInteger *)minor micro:(NSInteger *)micro
{
    if ([ver isEqualToString:@""]) {
        return;
    }
    
    NSArray *verArr = [ver componentsSeparatedByString:@"."];
    if ([verArr count] > 0) {
        if (nil != major) {
            *major = [verArr[0] integerValue];
        }
    }
    else {
        if (nil != major) {
            *major = 0;
        }
    }
    
    if ([verArr count] > 1) {
        if (nil != minor) {
            *minor = [verArr[1] integerValue];
        }
    }
    else {
        if (nil != minor) {
            *minor = 0;
        }
    }
    
    if ([verArr count] > 2) {
        if (nil != micro) {
            *micro = [verArr[2] integerValue];
        }
    }
    else {
        if (nil != micro) {
            *micro = 0;
        }
    }
}

- (VersionComparisonResult)compareVersion:(NSString *)ver1 to:(NSString *)ver2
{
    NSInteger major1 = 0;
    NSInteger minor1 = 0;
    NSInteger micro1 = 0;
    NSInteger major2 = 0;
    NSInteger minor2 = 0;
    NSInteger micro2 = 0;
    
    [self getVersion:ver1 major:&major1 minor:&minor1 micro:&micro1];
    [self getVersion:ver2 major:&major2 minor:&minor2 micro:&micro2];
    
    if (major1 != major2) {
        if (major1 > major2) {
            return VersionCompareHigh;
        }
        return VersionCompareLow;
    }
    
    if (minor1 != minor2) {
        if (minor1 > minor2) {
            return VersionCompareHigh;
        }
        return VersionCompareLow;
    }
    
    if (micro1 != micro2) {
        if (micro1 > micro2) {
            return VersionCompareHigh;
        }
        return VersionCompareLow;
    }
    return VersionCompareEqual;
}

- (BOOL)isFileExist:(NSString *)file
{
    NSURL *url = [NSURL URLWithString:file];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return (data != nil);
}

@end
