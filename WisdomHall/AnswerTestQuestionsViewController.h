//
//  AnswerTestQuestionsViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
#import "QuestionBank.h"
#import "ClassModel.h"

@interface AnswerTestQuestionsViewController : UIViewController
@property (nonatomic,strong)TextModel *t;

@property (nonatomic,strong)QuestionBank * qBank;

@property (nonatomic,strong)ClassModel *classModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,copy) NSString * titleStr;//标题名称
@end
