//
//  MeetingChooseSeatViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingChooseSeatViewController.h"
#import "MJExtension.h"
#import "ZFSeatsModel.h"
#import "ZFSeatSelectionView.h"
#import "MBProgressHUD.h"
#import "ZFSeatSelectionTool.h"

@interface MeetingChooseSeatViewController ()
/**按钮数组*/
@property (nonatomic, strong) NSMutableArray *selecetedSeats;

@property (nonatomic,strong) NSMutableDictionary *allAvailableSeats;//所有可选的座位

@property (nonatomic,strong) NSMutableArray *seatsModelArray;

@property (nonatomic,assign) int temp;
@end

@implementation MeetingChooseSeatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationTitle];
    
    [self addSeatView];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
  
    
    
    
}
-(void)addSeatView{
    __weak typeof(self) weakSelf = self;
    
    
    //模拟延迟加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        //模拟网络加载数据
        
        //  NSDictionary *seatsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_seatTable];
        NSArray * ary = [strUrl componentsSeparatedByString:@"\n"];
        NSMutableArray * a = [NSMutableArray arrayWithCapacity:1];
        
        NSArray * m = [_seat componentsSeparatedByString:@"排"];
        NSString * seatM = m[0];
        NSString * seatN = m[1];
        seatN = [seatN substringWithRange:NSMakeRange(0,seatN.length-1)];
        _temp = 1;
        
        
        for (int j = 0; j<ary.count; j++) {
            NSMutableArray * aa = [NSMutableArray arrayWithCapacity:1];
            for(int i =0; i < [ary[j] length]; i++)
            {
                NSString * newStr = ary[j];
                NSString * temp = [newStr substringWithRange:NSMakeRange(i,1)];
                
                if ([temp isEqualToString:@"+"]) {
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"columnId",@"",@"seatNo",@"E",@"st",nil];
                    [aa addObject:dict];
                }else if ([temp isEqualToString:@"@"]){
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j,i],@"seatNo",@"N",@"st",nil];
                    [aa addObject:dict];
                    
                    
                }else if ([temp isEqualToString:@"E"]){
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"0%d",j+1],@"columnId",[NSString stringWithFormat:@"%d,%d",j,i],@"seatNo",@"LK",@"st",nil];
                    [aa addObject:dict];
                }
                
            }
            NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:aa,@"columns",[NSString stringWithFormat:@"%d",j+1],@"rowId",[NSString stringWithFormat:@"%d",j+1],@"rowNum",nil];
            [a addObject:d];
        }
        
        
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
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"确定选座" style:UIBarButtonItemStylePlain target:self action:@selector(sureBtnAction)];
    
    self.navigationItem.rightBarButtonItem = myButton;
}
//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    __weak typeof(self) weakSelf = self;
    
    ZFSeatSelectionView *selectionView = [[ZFSeatSelectionView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width, 400)
                                                                         SeatsArray:seatsModelArray
                                                                           HallName:@"讲台"
                                                                               type:nil
                                                                 seatBtnActionBlock:^(NSMutableArray *selecetedSeats, NSMutableDictionary *allAvailableSeats, NSString *errorStr) {
                                                                     
                                                                     NSLog(@"=====%zd个选中按钮===========%zd个可选座位==========errorStr====%@=========",selecetedSeats.count,allAvailableSeats.count,errorStr);
                                                                     
                                                                     if (errorStr) {
                                                                         //错误信息
                                                                         [self showMessage:errorStr];
                                                                     }else{
                                                                         //储存选好的座位及全部可选座位
                                                                         weakSelf.allAvailableSeats = allAvailableSeats;
                                                                         weakSelf.selecetedSeats = selecetedSeats;
                                                                     }
                                                                 }];
    
    [self.view addSubview:selectionView];
}



-(void)setupSureBtn{
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定选座" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:[UIColor yellowColor]];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.frame = CGRectMake(200, 550, 100, 50);
    
    //[self.view addSubview:sureBtn];mjx
}

-(void)sureBtnAction{
    if (!self.selecetedSeats.count) {
        [self showMessage:@"您还为选座"];
        return;
    }
    //验证是否落单
    if (![ZFSeatSelectionTool verifySelectedSeatsWithSeatsDic:self.allAvailableSeats seatsArray:self.seatsModelArray]) {
        [self showMessage:@"落单"];
    }else{
        [self showMessage:@"选座成功"];
    }
}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}


@end

