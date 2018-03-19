//
//  ChangeThemeInfoViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ChangeThemeInfoViewController.h"
#import "ThemeTool.h"

@interface ChangeThemeInfoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *redColorBtn;
@property (strong, nonatomic) IBOutlet UIButton *blueColorBtn;
@property (strong, nonatomic) IBOutlet UIButton *greenColorBtn;
@property (strong, nonatomic) IBOutlet UIImageView *redImage;
@property (strong, nonatomic) IBOutlet UIImageView *blueImage;
@property (strong, nonatomic) IBOutlet UIImageView *greenImage;

@end

@implementation ChangeThemeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _redColorBtn.tag = 1;
    _blueColorBtn.tag = 2;
    _greenColorBtn.tag = 3;
    [self setThemeColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)setThemeColor{
    UIColor * color = [[ThemeTool shareInstance] getThemeColor];
    NSString * colorStr = [[Appsetting sharedInstance] toStrByUIColor:color];
    UIColor * c = RGBA_COLOR(217, 0, 21, 1);
    NSString * cStr = [[Appsetting sharedInstance] toStrByUIColor:c];
    UIColor * green = RGBA_COLOR(27, 206, 12, 1);
    NSString * gStr = [[Appsetting sharedInstance] toStrByUIColor:green];
    if ([colorStr isEqualToString:cStr]) {
        _redImage.image = [UIImage imageNamed:@"对号"];
        _blueImage.image = nil;
        _greenImage.image = nil;
    }else if ([colorStr isEqualToString:gStr]){
        _redImage.image = nil;
        _blueImage.image = nil;
        _greenImage.image = [UIImage imageNamed:@"对号"];
    }else{
        _redImage.image = nil;
        _blueImage.image = [UIImage imageNamed:@"对号"];
        _greenImage.image = nil;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeTheme:(UIButton *)sender {
    if (sender.tag == 1) {
        [[ThemeTool shareInstance] setThemeColor:RGBA_COLOR(217, 0, 21, 1)];
        [self setThemeColor];
    }else if (sender.tag ==3){
        [[ThemeTool shareInstance] setThemeColor:RGBA_COLOR(27, 206, 12, 1)];
        [self setThemeColor];
    }else{
        [[ThemeTool shareInstance] setThemeColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [self setThemeColor];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeColorChangeNotification object:nil];
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
