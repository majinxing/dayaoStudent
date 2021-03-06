//
//  TestCompletedViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
#import "QuestionBank.h"
#import "ClassModel.h"

@interface TestCompletedViewController : UIViewController
@property (nonatomic,strong)TextModel *t;

@property (nonatomic,strong)ClassModel *classModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,copy) NSString * titleStr;//标题名称

@property (nonatomic,copy) NSString * typeStr;//判断是否是问答

@property (nonatomic,assign)BOOL isAbleAnswer;

@end
