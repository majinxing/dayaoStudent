//
//  SelectSchoolViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolModel.h"

/**
 *  查询数据的类型
 **/
typedef enum {
    SelectSchool,
    SelectDepartment,
    SelectMajor,
    SelectClass,
}SelectType;

typedef void (^ReturnTextBlock)(SchoolModel *returnText);

@interface SelectSchoolViewController : UIViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@property (nonatomic,strong)SchoolModel * s;
@property (nonatomic, assign)SelectType  selectType;
- (void)returnText:(ReturnTextBlock)block;
@end
