//
//  ZFSeatViewController.m
//
//
//  Created by qq 316917975  on 16/1/27.
//  Copyright © 2016年 qq 316917975 . All rights reserved.
//  gitHub地址：https://github.com/ZFbaby
//  后面还会增加多种样式（格瓦拉，淘票票，微票儿）实现UI可定制效果及开场动画样式，请关注更新！记得点星哦！！！
#import "ZFSeatViewController.h"
#import "MJExtension.h"
#import "ZFSeatsModel.h"
#import "ZFSeatSelectionView.h"
#import "MBProgressHUD.h"
#import "ZFSeatSelectionTool.h"
#import "DYHeader.h"

@interface ZFSeatViewController ()
/**按钮数组*/
@property (nonatomic, strong) NSMutableArray *selecetedSeats;

@property (nonatomic,strong) NSMutableDictionary *allAvailableSeats;//所有可选的座位

@property (nonatomic,strong) NSMutableArray *seatsModelArray;

@property (nonatomic,assign) int temp;

@property (nonatomic,copy) void (^actionBlock)(NSString * str);
@property (nonatomic,strong) UILabel * seatLable;
@end

@implementation ZFSeatViewController

-(instancetype)initWithAction:(void (^)(NSString * str))action{
    self = [super init];
    if (self) {
        self.actionBlock = action;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationTitle];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    __weak typeof(self) weakSelf = self;
    
    //模拟延迟加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        //  NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"seats %zd.plist",arc4random_uniform(5)] ofType:nil];
        
        //模拟网络加载数据
        
        //  NSDictionary *seatsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_seatTable];
        
        NSArray * ary = [strUrl componentsSeparatedByString:@"\n"];
        NSMutableArray * a = [NSMutableArray arrayWithCapacity:1];
        NSString * seatM ;
        NSString * seatN ;
        _temp = 1;
        
        if ([UIUtils isBlankString:_seat]) {
            
        }else{
            NSArray * m = [_seat componentsSeparatedByString:@"排"];
            seatM = m[0];
            seatN = m[1];
            seatN = [seatN substringWithRange:NSMakeRange(0,seatN.length-1)];
            if (![UIUtils isBlankString:_type]) {
                _temp = 100000;
            }
        }
        
        for (int j = 0; j<ary.count; j++) {
            NSMutableArray * aa = [NSMutableArray arrayWithCapacity:1];
            int seatNo = 0;
            for(int i =0; i < [ary[j] length]; i++)
            {
                NSString * newStr = ary[j];
                NSString * temp = [newStr substringWithRange:NSMakeRange(i,1)];
                if ([temp isEqualToString:@"+"]) {
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"columnId",@"",@"seatNo",@"E",@"st",nil];
                    [aa addObject:dict];
                }else if ([temp isEqualToString:@"@"]){
                    seatNo = seatNo + 1;
                    if ([[NSString stringWithFormat:@"%d",j+1] isEqualToString:seatM]&&[[NSString stringWithFormat:@"%d",_temp] isEqualToString:seatN]) {
                        _temp = _temp + 1;
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j+1,seatNo],@"seatNo",@"LK",@"st",nil];
                        /**座位状态 N/表示可以购票 LK／座位已售出 E/表示过道 */
                        
                        [aa addObject:dict];
                    }else{
                        if ([[NSString stringWithFormat:@"%d",j+1] isEqualToString:seatM]) {
                            _temp = _temp + 1;
                        }
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j+1,seatNo],@"seatNo",@"N",@"st",nil];
                        [aa addObject:dict];
                    }
                }else if([temp isEqualToString:@"-"]){
                    seatNo = seatNo + 1;
                    if ([[NSString stringWithFormat:@"%d",j+1] isEqualToString:seatM]&&[[NSString stringWithFormat:@"%d",seatNo] isEqualToString:seatN]) {
                        
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j+1,seatNo],@"seatNo",@"LK",@"st",nil];
                        /**座位状态 N/表示可以购票 LK／座位已售出 E/表示过道 */
                        
                        [aa addObject:dict];
                    }else{
                        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j+1,seatNo],@"seatNo",@"ss",@"st",nil];
                        [aa addObject:dict];
                    }
                }
                
            }
            NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:aa,@"columns",[NSString stringWithFormat:@"%d",j+1],@"rowId",[NSString stringWithFormat:@"%d",j+1],@"rowNum",nil];//与实际数值可能不符
            [a addObject:d];
        }
        _seatLable = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-50, 30, 100, 25)];
        if (![UIUtils isBlankString:_seat]) {
            _seatLable.text = [NSString stringWithFormat:@"座次:%@",_seat];
        }else{
            _seatLable.text = [NSString stringWithFormat:@"座次:未选座"];
        }
        _seatLable.font = [UIFont systemFontOfSize:15];
        _seatLable.textColor = [UIColor blackColor];
        _seatLable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_seatLable];
        
        __block  NSMutableArray *  seatsArray = a;//seatsDic[@"seats"];
        
        __block  NSMutableArray *seatsModelArray = [NSMutableArray array];
        
        [seatsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
            ZFSeatsModel *seatModel = [ZFSeatsModel mj_objectWithKeyValues:obj];
            [seatsModelArray addObject:seatModel];
        }];
        //        [HUD hideAnimated:YES];
        weakSelf.seatsModelArray = seatsModelArray;
        
        //数据回来初始化选座模块
        [weakSelf initSelectionView:seatsModelArray];
        
        [weakSelf setupSureBtn];
    });
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"座次表";
    if ([UIUtils isBlankString:_type]) {
        
    }else{
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"确定选座" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnAction)];
        
        self.navigationItem.rightBarButtonItem = myButton;
        
    }
    
}
//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    __weak typeof(self) weakSelf = self;
    
    ZFSeatSelectionView *selectionView = [[ZFSeatSelectionView alloc]initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width, 400)
                                                                        SeatsArray:seatsModelArray
                                                                          HallName:@"讲台"
                                                                              type:_type
                                                                seatBtnActionBlock:^(NSMutableArray *selecetedSeats, NSMutableDictionary *allAvailableSeats, NSString *errorStr) {
                                                                    
                                                                    //                                                                    NSLog(@"=====%zd个选中按钮===========%zd个可选座位==========errorStr====%@=========",selecetedSeats.count,allAvailableSeats.count,errorStr);
                                                                    
                                                                    if (errorStr) {
                                                                        //错误信息
                                                                        [self showMessage:errorStr];
                                                                    }else{
                                                                        //储存选好的座位及全部可选座位
                                                                        weakSelf.allAvailableSeats = allAvailableSeats;
                                                                        //                                                                        [weakSelf.selecetedSeats removeAllObjects];
                                                                        weakSelf.selecetedSeats = selecetedSeats;
                                                                    }
                                                                }];
    
    [self.view addSubview:selectionView];
}

-(void)setupSureBtn{
    if ([UIUtils isBlankString:_type]) {
        return;
    }
    NSArray * ary = @[@"可选座次",@"不 可 选",@"当前已选",@"正 在 选"];
    NSArray * aryImage = @[@"kexuan",@"ss",@"yishou",@"xuanzhong"];
    
    for (int i = 0; i<4; i++) {
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20+(i%2)*140, APPLICATION_HEIGHT-150+(i/2)*25, 65, 20)];
        lable.text = ary[i];
        lable.font = [UIFont systemFontOfSize:14];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame), APPLICATION_HEIGHT-150+(i/2)*25, 20, 20)];
        image.image = [UIImage imageNamed:aryImage[i]];
        
        [self.view addSubview:lable];
        
        [self.view addSubview:image];
    }
}

-(void)sureBtnAction{
    if (!self.selecetedSeats.count) {
        [self showMessage:@"您还未选座"];
        return;
    }
    //    //验证是否落单
    //    if (![ZFSeatSelectionTool verifySelectedSeatsWithSeatsDic:self.allAvailableSeats seatsArray:self.seatsModelArray]) {
    //        [self showMessage:@"落单"];
    //    }else{
    //        [self showMessage:@"选座成功"];
    //    }
    ZFSeatButton * z = self.selecetedSeats[self.selecetedSeats.count-1];
    ZFSeatModel * m = z.seatmodel;
    //    ZFSeatsModel * n = z.seatsmodel;
    NSArray * a = [m.seatNo componentsSeparatedByString:@","];
    NSString * seat = [NSString stringWithFormat:@"%d排%d座",[a[0] intValue],[a[1] intValue]];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_classModel.courseDetailId],@"courseDetailId",user.peopleId,@"studentId",seat,@"seat", nil];
    [[NetworkRequest sharedInstance] POST:UpdateSeat dict:dict succeed:^(id data) {
        
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            [UIUtils showInfoMessage:@"选座成功" withVC:self];
            self.actionBlock(str);
            _seatLable.text = seat;
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString * str1 = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            [self showMessage:str1];
        }
    } failure:^(NSError *error) {
        [self showMessage:@"选座失败，请检查网络"];
    }];
}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
