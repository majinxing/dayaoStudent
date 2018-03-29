//
//  MJXEditTheTextViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/13.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXEditTheTextViewController.h"
#import "MJXRootViewController.h"
@interface MJXEditTheTextViewController ()
@property (nonatomic,strong)UITextView *textField;


@end

@implementation MJXEditTheTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleStr];
    [self addBackButton];
    
    _textField = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, APPLICATION_WIDTH-20, 200)];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    _textField.font = [UIFont systemFontOfSize:15];
  
    [self.view addSubview:_textField];
    // Do any additional setup after loading the view.
}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
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
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

-(void)save{
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_textField.text);
    }
    [self back];
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
