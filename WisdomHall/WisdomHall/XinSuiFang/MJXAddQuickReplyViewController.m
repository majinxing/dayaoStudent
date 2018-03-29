//
//  MJXAddQuickReplyViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/4.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAddQuickReplyViewController.h"

@interface MJXAddQuickReplyViewController ()<UITextViewDelegate>
@property (nonatomic,strong)NSString * quickReply;
@property (nonatomic,strong)UILabel * label;//提示性文字
@end

@implementation MJXAddQuickReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _quickReply = [[NSString alloc] init];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"添加快速回复"];
    [self addBackButton];
    
    [self addTextView];
    // Do any additional setup after loading the view.
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

-(void)addTextView{
    UIView * bView = [[UITextView alloc] initWithFrame:CGRectMake(0, 75, APPLICATION_WIDTH, 200)];
    bView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 79, APPLICATION_WIDTH-20, 14)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor colorWithHexString:@"#999999"];
    _label.text = @"请输入快速回复信息";
    [self.view addSubview:_label];
    
    UITextView * t = [[UITextView alloc] initWithFrame:CGRectMake(10, 75, APPLICATION_WIDTH-20, 200)];
    t.backgroundColor = [UIColor clearColor];
    t.font = [UIFont systemFontOfSize:14];
    t.textColor = [UIColor colorWithHexString:@"#999999"];
    t.delegate = self;
    [self.view addSubview:t];
   
    
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
    [save setTitle:@"保 存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_quickReply);
    }
    [self back];
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    _quickReply = textView.text;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _label.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0) {
        
    }else{
        _label.text = @"请输入快速回复信息";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
