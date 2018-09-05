//
//  Common.h
//  ESCloudsManager
//
//  Created by 孙滢贺 on 16/7/15.
//  Copyright © 2016年 ESClouds. All rights reserved.
//

#ifndef Common_h
#define Common_h

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif

#define kFont(x) [UIFont systemFontOfSize:x]//自定义font大小
#define kWidth(obj)   (!obj?0:(obj).frame.size.width)
#define kHeight(obj)   (!obj?0:(obj).frame.size.height)
#define kXpoint(obj)   (!obj?0:(obj).frame.origin.x)
#define kYpoint(obj)   (!obj?0:(obj).frame.origin.y)
#define kXWidth(obj) (kXpoint(obj)+kWidth(obj))
#define kYHeight(obj) (kYpoint(obj)+kHeight(obj))
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

#define kPBlack(obj)  [SVProgressHUD showWithStatus:obj maskType:SVProgressHUDMaskTypeBlack];
#define kPNone(obj)  [SVProgressHUD showWithStatus:obj maskType:SVProgressHUDMaskTypeNone];
#define kPSuccess(obj) [SVProgressHUD showSuccessWithStatus:obj];
#define kPError(obj) [SVProgressHUD showErrorWithStatus:obj];
#define kPdismiss [SVProgressHUD dismiss];

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1];
#define kSepareLineColor [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];

#define ksaveLocal(key,value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
#define kgetLocalData(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

#define kUserName @"userName"
#define kPhoneNumber @"phoneNumber"
#define kUserId  @"userId"
#define KShopId  @"shopId"
#define KPassword @"passWord"
#define kScanCardTopology @"scanCardObj"


#endif /* Common_h */
