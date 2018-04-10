//
//  CreateChatViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateChatViewController.h"
#import "DYHeader.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"
#import <Hyphenate/Hyphenate.h>


@interface CreateChatViewController ()<UITextViewDelegate>
//@property (nonatomic,strong)UITableView * tableView;
@property (strong, nonatomic) IBOutlet UILabel *bLabel;
@property (strong, nonatomic) IBOutlet UITextView *introduction;
@property (strong, nonatomic) IBOutlet UITextField *groupName;
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong) NSMutableArray * selectPeople;
@property (strong, nonatomic) IBOutlet UILabel *selectNumber;

@end

@implementation CreateChatViewController

-(void)dealloc{
    [[EMClient sharedClient].groupManager removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationTitle];
    
    [self xib];
    
    [_groupName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    _selectPeople = [NSMutableArray arrayWithCapacity:1];
    
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)xib{
    _introduction.layer.masksToBounds = YES;
    _introduction.layer.cornerRadius = 5;
    _introduction.layer.borderWidth = 1;
    _introduction.layer.borderColor = RGBA_COLOR(212, 212, 212, 1).CGColor;
    _introduction.delegate = self;
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.title = @"创建群组";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(addPeople)];
    self.navigationItem.rightBarButtonItem = myButton;
}

-(void)addPeople{
    SelectPeopleToClassViewController * s = [[SelectPeopleToClassViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    s.selectPeople = [[NSMutableArray alloc] initWithArray:_selectPeople];
    [self.navigationController pushViewController:s animated:YES];
    [_dataAry removeAllObjects];
    [_selectPeople removeAllObjects];
    [s returnText:^(NSMutableArray *returnText) {
        for (int i = 0; i<returnText.count; i++) {
            SignPeople * s = returnText[i];
            [_selectPeople addObject:s];
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            [_dataAry addObject:[NSString stringWithFormat:@"%@%@",user.school,s.workNo]];
            _selectNumber.text = [NSString stringWithFormat:@"已选%lu人",(unsigned long)_dataAry.count];
        }
        
    }];

}
- (IBAction)createGroup:(UIButton *)sender {
    if (![UIUtils isBlankString:_introduction.text]&&![UIUtils isBlankString:_groupName.text]) {
        EMError *error = nil;
        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
        setting.maxUsersCount = 2000;
        setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        [_dataAry addObject:[NSString stringWithFormat:@"%@%@",user.school,user.studentId]];
        
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:_groupName.text description:_introduction.text invitees:_dataAry message:@"邀请您加入群组" setting:setting error:&error];
        
        if(!error){
            [UIUtils showInfoMessage:@"创建成功" withVC:self];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [UIUtils showInfoMessage:@"创建成功" withVC:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [UIUtils showInfoMessage:@"请填写完整信息" withVC:self];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange:(UITextField *)textFile{
    
}
#pragma  mark  UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if ([UIUtils isBlankString:textView.text]) {
        _bLabel.text = @"请输入群组简介";
    }else{
        _bLabel.text = @"";
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
