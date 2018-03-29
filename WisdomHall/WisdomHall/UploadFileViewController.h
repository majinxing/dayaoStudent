//
//  UploadFileViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
@interface UploadFileViewController : UIViewController
@property(nonatomic,strong)MeetingModel * meeting;
@property(nonatomic,strong)ClassModel * classModel;
@property(nonatomic,copy)NSString * type;
@end
