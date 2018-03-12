//
//  JoinCours.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/17.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JoinCoursDelegate <NSObject>

-(void)joinCourseDelegete:(UIButton *)btn;

@end
@interface JoinCours : UIView
@property (nonatomic,weak)id<JoinCoursDelegate>delegate;
@property (nonatomic,strong)UITextField * courseNumber;
@end

