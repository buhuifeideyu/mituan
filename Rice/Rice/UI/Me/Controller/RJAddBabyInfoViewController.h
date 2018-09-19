//
//  RJAddBabyInfoViewController.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFamilyListModel.h"

@interface RJAddBabyInfoViewController : UIViewController

@property (nonatomic,strong) NSString *relationship;

@property (nonatomic,strong) RJFamilyListModel *familyListModel;

@end
