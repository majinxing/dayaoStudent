//
//  AnswerChoiceQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "TextModel.h"


@protocol AnswerChoiceQuestionViewControllerDelegate<NSObject>
-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer;
@end
@interface AnswerChoiceQuestionViewController : UIViewController

@property (nonatomic,weak)id<AnswerChoiceQuestionViewControllerDelegate>delegate;

@property (nonatomic,strong)TextModel *t;

@property (nonatomic,assign)BOOL selectMore;//是否多选

@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign)int titleNum;//题号
@end
