//
//  SelectClassRoomViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassRoomModel.h"

typedef void (^ReturnTextBlock)(ClassRoomModel *returnText);

@interface SelectClassRoomViewController : UIViewController

@property (nonatomic,strong)ClassRoomModel * classRoom;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
