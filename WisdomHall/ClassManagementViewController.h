//
//  ClassManagementViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"

typedef enum {
    ClassManageType,
    MeetingManageType,
}ManageType;
@interface ClassManagementViewController : UIViewController
@property (nonatomic,strong)MeetingModel * meeting;
@property (nonatomic,strong)NSMutableArray * signAry;
@property (nonatomic,assign)ManageType manage;
@property (nonatomic,copy)NSString * groupId;
@end
