//
//  GroupPeopleViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/9.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "GroupPeopleViewController.h"
#import "DYHeader.h"
#import "SignPeople.h"

@interface GroupPeopleViewController ()
@property (nonatomic,strong)NSMutableArray *a;
@end

@implementation GroupPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_group.groupId,@"groupId", nil];
    [[NetworkRequest sharedInstance] GET:GroupPeople dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                [s setInfoWithDict:ary[i]];
            }
        }else{
            [UIUtils showInfoMessage:@"获取数据失败"];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络"];
    }];
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
