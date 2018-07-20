//
//  CorrectAnswerViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/13.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
#import "QuestionBank.h"
#import "ClassModel.h"
@interface CorrectAnswerViewController : UIViewController
@property (nonatomic,strong)TextModel *t;

@property (nonatomic,strong)QuestionBank * qBank;

@property (nonatomic,strong)ClassModel *classModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,copy) NSString * titleStr;//标题名称

@property (nonatomic,assign)BOOL isAbleAnswer;
@end