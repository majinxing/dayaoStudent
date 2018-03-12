//
//  CourseCollectionViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
@interface CourseCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *courseImage;
-(void)setInfoForContentView:(MeetingModel *)meetingModel;
-(void)setClassInfoForContentView:(ClassModel *)classModel;
@end
