//
//  DebugMarco.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#ifndef DebugMarco_h
#define DebugMarco_h

#define __LOGDEBUG__ (1)

#if defined(__LOGDEBUG__) && __LOGDEBUG__ && DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

// 判断设备是否是iPhone
#define isIPhoneDevice ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


#define beginTime NSTimeInterval beginTime = CACurrentMediaTime();
#define consumeTime 

//string
#define STRINGHASVALUE(str)		(str && [str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)


#endif /* DebugMarco_h */
