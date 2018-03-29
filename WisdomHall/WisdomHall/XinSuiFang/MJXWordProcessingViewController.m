//
//  MJXWordProcessingViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/7.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXWordProcessingViewController.h"

@interface MJXWordProcessingViewController ()

@property (nonatomic,strong)UITextField *textField;
@end

@implementation MJXWordProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleStr];
    [self addBackButton];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, APPLICATION_WIDTH-20, 150)];
    _textField.placeholder = _titleStr;
    _textField.font = [UIFont systemFontOfSize:18];
    _textField.textColor = [UIColor colorWithHexString:@"#666666"];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;  //垂直居中

    [self.view addSubview:_textField];
    
    // Do any additional setup after loading the view.
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_textField.text);
    }
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
    _textField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
