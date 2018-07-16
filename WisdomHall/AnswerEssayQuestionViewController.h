//
//  AnswerEssayQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "TextModel.h"

@protocol AnswerEssayQuestionViewControllerDelegate<NSObject>

-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer;

-(void)sendImageBeginDelegate;

-(void)sendImageEndDelegate;

-(void)textEditorBeginDelegate;

-(void)textEditorEndDelegate;


@end
@interface AnswerEssayQuestionViewController : UIViewController

@property (nonatomic,weak)id<AnswerEssayQuestionViewControllerDelegate>delegate;

@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,strong)TextModel *t;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,assign)int titleNum;//题号

@end
