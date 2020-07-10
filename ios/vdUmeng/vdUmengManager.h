//
//  vdUmengManager.h
//  WeexTestDemo
//
//  Created by apple on 2018/6/20.
//  Copyright © 2018年 TomQin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeexSDK.h"
#import <UMPush/UMessage.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#define kUmengNotification @"kUmengNotification"

@interface vdUmengManager : NSObject

@property (nonatomic, strong) NSDictionary *token;
@property (nonatomic, copy) WXModuleKeepAliveCallback callback;

+ (vdUmengManager *)sharedIntstance;

- (void)init:(NSString*)key channel:(NSString*)channel launchOptions:(NSDictionary*)launchOptions;

- (void)setNotificationClickHandler:(WXModuleKeepAliveCallback)callback;

- (void)addAlias:(NSDictionary *)params;
@end
