//
//  PersonalUploadDataViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/31.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"

@interface PersonalUploadDataViewController : UIViewController
@property(nonatomic,strong)MeetingModel * meeting;
@property(nonatomic,strong)ClassModel * classModel;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * function;
@end
