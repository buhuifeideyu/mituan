//
//  RJFamilyListModel.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJFamilyListModel : NSObject

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *family_name;//家庭名称

@property (nonatomic,strong) NSArray *childList;//家庭成员

@property (nonatomic,strong) NSArray *memberList;//家庭成员

@end
