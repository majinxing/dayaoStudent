//
//  StatisticalCourseTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/25.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseStatisticalModel.h"

@interface StatisticalCourseTableViewCell : UITableViewCell
-(void)addContentView:(CourseStatisticalModel *)c;
@end
