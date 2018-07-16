//
//  MJXNavigationController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXNavigationController.h"

@interface MJXNavigationController ()
@property(nonatomic,assign) NSUInteger maxstacksize;
@property(nonatomic,strong) NSMutableArray *delegateArray;

@end

@implementation MJXNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self=[super init];
    if (self != nil) {
        self.maxstacksize=4;
        self.delegateArray=[[NSMutableArray alloc]initWithCapacity:self.maxstacksize];
    }
    return [super initWithRootViewController: rootViewController];// UINavigationController本身没有显示的内容，所以它需要另外一个ViewController结合一起，initWithRootViewController是指定显示的第一个viewController
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *vcs=self.viewControllers;
    if ([vcs indexOfObject:viewController] != NSNotFound)
    {
        return;
    }
    // 执行推入下级页面前禁用滑动返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    // SQRNavigationViewController 只push 3层，再多就把前面第一层的controller 去掉
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];
//    if ([controllers count] >= 4)
//    {
//        [controllers removeObjectAtIndex:1];
//        [self.delegateArray removeObjectAtIndex:1];
//    }
    [self setViewControllers:controllers animated:NO];
    if (self.MJXNavdelegate){
        [self.delegateArray addObject:self.MJXNavdelegate];
    }else{
        if (self.delegate){
            [self.delegateArray addObject:self.delegate];
        }else{
            [self.delegateArray addObject:self];
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    id <MJXNavigationControllerDelegate> mydelegate;
    UIViewController *popView;
    mydelegate=self.delegateArray[self.delegateArray.count-1];
    popView=self.viewControllers[self.viewControllers.count-1];
    if (self.delegateArray.count > 1) {
        if (mydelegate!=self.delegate) {
            
            [mydelegate onViewPopup:popView];
        }
        [self.delegateArray removeLastObject];
    }
    
    return [super popViewControllerAnimated:animated];
}
#pragma mark - UINavigationControllerDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 界面展示后设置滑动返回手势可用
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
