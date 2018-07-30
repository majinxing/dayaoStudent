//
//  CourseListALLViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/27.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CourseListALLViewController.h"
#import "SignInViewController.h"
#import "NavBarNavigationController.h"

@interface CourseListALLViewController ()
@property (nonatomic,strong)SignInViewController * OldVC;
@property (nonatomic,strong)SignInViewController * nVC;
@property (nonatomic,strong)NSMutableArray * FLDayAry;
@end

@implementation CourseListALLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewVC];
    
    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:priv];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
    self.title = @"课堂";
    
    // Do any additional setup after loading the view from its nib.
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        
        _nVC = [[SignInViewController alloc] init];
        
        
        _nVC.view.frame = CGRectMake(APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        _nVC.selfNavigationVC = self;
        
        if (_FLDayAry.count==4) {
            _nVC.monthStr = _FLDayAry[3];
            
            NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:_FLDayAry[2]]];
            
            _nVC.dictDay = [UIUtils getWeekTimeWithType:_FLDayAry[2]];
            
            _nVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
            
            if (ary.count>=10) {
                [_FLDayAry removeAllObjects];
                [_FLDayAry addObject:ary[7]];
                [_FLDayAry addObject:ary[8]];
                [_FLDayAry addObject:ary[9]];
                [_FLDayAry addObject:ary[10]];
                
            }
        }
        
        [self addChildViewController:_nVC];

        
        [self.view addSubview:_nVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{

            _OldVC.view.frame = CGRectMake(-APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);//CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
            
            _nVC.view.transform = CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
        } completion:^(BOOL finished) {
            
            [_OldVC.view removeFromSuperview];
            
            [_OldVC removeFromParentViewController];
            
            _OldVC = _nVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);

            });
            

        }];
        
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        _nVC = [[SignInViewController alloc] init];
        
        [self addChildViewController:_nVC];
        
        _nVC.view.frame = CGRectMake(-APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        _nVC.selfNavigationVC = self;
        
        if (_FLDayAry.count==4) {
            _nVC.monthStr = _FLDayAry[1];
            
            NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:_FLDayAry[0]]];
            
            _nVC.dictDay = [UIUtils getWeekTimeWithType:_FLDayAry[0]];
            
            _nVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
            
            if (ary.count>=10) {
                [_FLDayAry removeAllObjects];
                [_FLDayAry addObject:ary[7]];
                [_FLDayAry addObject:ary[8]];
                [_FLDayAry addObject:ary[9]];
                [_FLDayAry addObject:ary[10]];
                
            }
        }
        
        
        [self.view addSubview:_nVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _OldVC.view.frame = CGRectMake(APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);//CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
            
            _nVC.view.transform = CGAffineTransformMakeTranslation(APPLICATION_WIDTH, 0);
        } completion:^(BOOL finished) {
            
            [_OldVC removeFromParentViewController];
            
            _OldVC = _nVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
                
            });
            
            
        }];
        
    }
    
    
}


-(void)addChildViewVC{
    
    NSDictionary * dictDay = [UIUtils getWeekTimeWithType:[UIUtils getTime]];

    self.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    _OldVC = [[SignInViewController alloc] init];
    
    _OldVC.dictDay = [NSDictionary dictionaryWithDictionary:dictDay];
    
    _OldVC.monthStr = [UIUtils getMonth];
    
    NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:[_OldVC.dictDay objectForKey:@"firstDay"]]];
    
    _FLDayAry = [NSMutableArray arrayWithCapacity:1];
    if (ary.count>=10) {
        [_FLDayAry addObject:ary[7]];
        [_FLDayAry addObject:ary[8]];
        [_FLDayAry addObject:ary[9]];
        [_FLDayAry addObject:ary[10]];
    }
    _OldVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
    
    
    [self addChildViewController:_OldVC];
    
    _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    _OldVC.selfNavigationVC = self;
    
    [self.view addSubview:_OldVC.view];
    
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
