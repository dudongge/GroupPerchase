//
//  DUAboutUsController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUAboutUsController.h"

@interface DUAboutUsController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLable;


@end

@implementation DUAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    

    _aboutUsLable.center = self.view.center;
 _aboutUsLable.text =@"感谢您使用这款软件，这是一款时尚购物推荐的即时软件，在这里，为您提供最新的购物资讯，品类齐全，价格低廉，为繁忙的生活增加一份色彩，是购物时尚达人，潮男潮女，辣妈们必备的神器，引领购物时尚潮流，尽在一手掌握.指尖轻点，生活改变，足不出户的为您筛选生活的方方面面。";
    
    _aboutUsLable.backgroundColor = [UIColor clearColor];
    _aboutUsLable.clipsToBounds = YES;
    _aboutUsLable.layer.cornerRadius = 8;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personalback"]];
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
