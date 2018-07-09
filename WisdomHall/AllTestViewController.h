//
//  AllTestViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYHeader.h"
#import "ClassModel.h"

@interface AllTestViewController : UIViewController
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong) ClassModel * classModel;
@property (nonatomic,strong) NSString * typeText;
@end
