//
//  EditPageView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "EditPageView.h"
#import "DYHeader.h"

@implementation EditPageView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addContentView];
        [self keyboardNotification];
    }
    return self;
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
//    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    _textView.frame = CGRectMake(10, 0, APPLICATION_WIDTH-20, APPLICATION_HEIGHT-keyBoardRect.size.height-40-104);
//    _cancle.frame = CGRectMake(10, CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
//    _save.frame = CGRectMake(CGRectGetMaxX(_cancle.frame), CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
//    CGRect rect = _btoView.frame;
//    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-rect.size.height-keyBoardRect.size.height, APPLICATION_WIDTH, rect.size.height);
//    _keyH = keyBoardRect.size.height;
}
-(void)addContentView{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.5;
    [self addSubview:btn];
    
    _textView = [[UITextView alloc] init];
    
    _textView.font = [UIFont systemFontOfSize:15];
    
    [_textView becomeFirstResponder];
    
    [self addSubview:_textView];
    
//    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    _textView.frame = CGRectMake(10, 0, APPLICATION_WIDTH-20, APPLICATION_HEIGHT/2-80-20);
    
    _cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _cancle.frame = CGRectMake(10, CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
    _cancle.backgroundColor = [UIColor whiteColor];
    
    [_cancle setTitle:@"取消" forState:UIControlStateNormal];

    [_cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_cancle addTarget:self action:@selector(saveTextStr:) forControlEvents:UIControlEventTouchUpInside];
    _cancle.tag  = 1;
    [self addSubview:_cancle];
    
    _save = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _save.frame = CGRectMake(CGRectGetMaxX(_cancle.frame), CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
    
    _save.backgroundColor = [UIColor whiteColor];
    
    [_save setTitle:@"保存" forState:UIControlStateNormal];
    
    [_save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_save addTarget:self action:@selector(saveTextStr:) forControlEvents:UIControlEventTouchUpInside];
    
    _save.tag = 2;
    
    [self addSubview:_save];
    
}
-(void)saveTextStr:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(saveTextStrDelegate:)]) {
        [self.delegate saveTextStrDelegate:btn];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
