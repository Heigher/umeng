//
//  vdUmengModule.m
//  WeexTestDemo
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 TomQin. All rights reserved.
//

#import "vdUmengModule.h"
#import "vdUmengManager.h"
#import <UMAnalytics/MobClick.h>
#import <WeexPluginLoader/WeexPluginLoader.h>

@implementation vdUmengModule

WX_PlUGIN_EXPORT_MODULE(vdUmeng, vdUmengModule)
WX_EXPORT_METHOD_SYNC(@selector(getToken))
WX_EXPORT_METHOD(@selector(setNotificationClickHandler:))
WX_EXPORT_METHOD(@selector(onEvent:attributes:))
WX_EXPORT_METHOD(@selector(profileSignInUser:provider:))
WX_EXPORT_METHOD(@selector(logPageView:seconds:))
WX_EXPORT_METHOD(@selector(beginLogPage:))
WX_EXPORT_METHOD(@selector(endLogPage:))
WX_EXPORT_METHOD(@selector(beginEvent:primarykey:attributes:))
WX_EXPORT_METHOD(@selector(endEvent:primarykey:))
WX_EXPORT_METHOD(@selector(setCrashReportEnabled:))
WX_EXPORT_METHOD(@selector(addAlias:))

- (NSDictionary*)getToken
{
    return [[vdUmengManager sharedIntstance] token];
}

- (void)setNotificationClickHandler:(WXModuleKeepAliveCallback)callback
{
    [[vdUmengManager sharedIntstance] setNotificationClickHandler:callback];
}

//添加别名
- (void)addAlias:(id)params {
    [[vdUmengManager sharedIntstance] addAlias:params];
}

//判断是否打开系统通知
WX_EXPORT_METHOD(@selector(checkSystemNotification:))
WX_EXPORT_METHOD(@selector(toOpenSystemNBotification))

- (void)checkSystemNotification:(WXModuleKeepAliveCallback)callback {
    BOOL isEnable = NO;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    if (UIUserNotificationTypeNone == setting.types) {
        callback(@{@"opened": @0, @"desc": @"打开系统通知，避免错过新消息"}, YES);
    } else {
        callback(@{@"opened": @1, @"desc": @"系统通知已开启"}, YES);
    }
}

- (void)toOpenSystemNBotification {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url];
            }
        } else {
            [application openURL:url];
        }
    }
}

#pragma mark -友盟统计分析
// 统计应用自身的账号。 Provider：账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节 ;
- (void)profileSignInUser:(NSString *)userid provider:(NSString *)provider {
    [MobClick profileSignInWithPUID:userid provider:provider];
}

// 手动统计页面停留时长
- (void)logPageView:(NSString *)pageName seconds:(int)seconds {
    [MobClick logPageView:pageName seconds:seconds];
}

// 页面统计 页面展示时调用 以下两个方法配合自动统计页面停留时长
- (void)beginLogPage:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

// 页面统计 页面退出时调用
- (void)endLogPage:(NSString *)pageName {
    [MobClick endLogPageView:pageName];
}

// 事件统计
- (void)onEvent:(NSString*)eventId attributes:(NSDictionary *)attributes
{
    [MobClick event:eventId attributes:attributes];
}

/**
 * 统计事件持续时间
 * eventId 事件ID
 * primaryKey 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey。
 * attributes 属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过100个 。
 */
- (void)beginEvent:(NSString *)eventId primaryKey:(NSString *)keyName attributes:(NSDictionary *)attributes {
    [MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}

- (void)endEvent:(NSString *)eventId primaryKey:(NSString *)keyName {
    [MobClick endEvent:eventId primarykey:keyName];
}

// 错误统计 是否收集错误日志
- (void)setCrashReportEnable:(BOOL)value {
    [MobClick setCrashReportEnabled:value];
}

#pragma mark -友盟分享

@end
