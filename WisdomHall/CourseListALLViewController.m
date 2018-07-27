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
@property (nonatomic,strong)UIViewController * vc;
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
    // Do any additional setup after loading the view from its nib.
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        
        SignInViewController * vc = [[SignInViewController alloc] init];
        
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        vc.selfNavigationVC = self;
        
        [self.view addSubview:vc.view];
        
        [UIView animateWithDuration:1 animations:^{
            UIViewController * vc1  = self.childViewControllers[0];

            vc1.view.transform = CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
            vc.view.transform = CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
        } completion:^(BOOL finished) {
//            UIViewController * vc1 = self.childViewControllers.firstObject;
            UIViewController * vc1 = self.childViewControllers[0];

            [vc1 removeFromParentViewController];
            
            vc.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);

        }];
        
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        
    }
    
    
}


-(void)addChildViewVC{
    self.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    SignInViewController * vc = [[SignInViewController alloc] init];
    
    [self addChildViewController:vc];
    
    vc.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    vc.selfNavigationVC = self;
    
    [self.view addSubview:vc.view];
    
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
