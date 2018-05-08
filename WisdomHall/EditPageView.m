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
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
//    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
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
    
    _textView.frame = CGRectMake(10, 0, APPLICATION_WIDTH-20, APPLICATION_HEIGHT/2-80-20);
    
    UIButton * cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    
    cancle.frame = CGRectMake(10, CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
    cancle.backgroundColor = [UIColor whiteColor];
    
    [cancle setTitle:@"取消" forState:UIControlStateNormal];

    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cancle addTarget:self action:@selector(saveTextStr:) forControlEvents:UIControlEventTouchUpInside];
    cancle.tag  = 1;
    [self addSubview:cancle];
    
    UIButton * save = [UIButton buttonWithType:UIButtonTypeSystem];
    
    save.frame = CGRectMake(CGRectGetMaxX(cancle.frame), CGRectGetMaxY(_textView.frame), (APPLICATION_WIDTH-20)/2, 40);
    
    save.backgroundColor = [UIColor whiteColor];
    
    [save setTitle:@"保存" forState:UIControlStateNormal];
    
    [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [save addTarget:self action:@selector(saveTextStr:) forControlEvents:UIControlEventTouchUpInside];
    
    save.tag = 2;
    
    [self addSubview:save];
    
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
