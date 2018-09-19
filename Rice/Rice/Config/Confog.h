//
//  Confog.h
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#ifndef Confog_h
#define Confog_h

#define kHomeBannerHeight   KScreenWidth / 2

#define KStartDefaultImage [UIImage imageNamed:@"1111"]

#define KDefaultImage [UIImage imageNamed:@"1111"]

#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kToken [[NSUserDefaults standardUserDefaults] stringForKey:@"RJtoken"]
#define kUserID [[NSUserDefaults standardUserDefaults] stringForKey:@"RJuser_id"]

#define RJUserDefaultsGET(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]            // 取
#define RJUserDefaultsSET(object,key)   [[NSUserDefaults standardUserDefaults] setObject:object forKey:key] // 写
#define RJUserDefaultsSynchronize       [[NSUserDefaults standardUserDefaults] synchronize]                 // 存
#define RJUserDefaultsRemove(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]      // 删

//缓存key
#define SONGLIST  @"storyLIST"

#define TOTALTIME @"storyTOTALTIME"

#endif /* Confog_h */
