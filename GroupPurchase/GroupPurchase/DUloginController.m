//
//  DUloginController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUloginController.h"
#import "DURegistController.h"
#import  "DUUserViewController.h"
#import "DUDBmanager.h"



@interface DUloginController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)registAction:(id)sender;

@end

@implementation DUloginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    //[button setTitle:@"注册" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"88-5-nc_new"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    _loginButton.clipsToBounds = YES;
    _loginButton.layer.cornerRadius = 4;
    
}

- (void)buttonAction
{
    DUUserViewController *usertVC = [[DUUserViewController alloc]init];
    
    [self.navigationController pushViewController:usertVC animated:YES];
    
}






#pragma mark --- 登陆按钮
- (IBAction)loginAction:(id)sender
{
//    BOOL isNull = (_usernameTextFeild.text = nil );
    
//    if (isNull) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        NSLog(@"%@%@",_usernameTextFeild.text,_passwordTextFeild.text);
//      
//       
//    }
// 
//    else{
   
   
        BOOL isExst = [[DUDBmanager sharedManager]isExists:_usernameTextFeild.text];
        if (isExst) {
            BOOL isRight = [[DUDBmanager sharedManager]isCorrect:_usernameTextFeild.text withPassword:_passwordTextFeild.text];
            if (isRight) {
                DUUserViewController *usertVC = [[DUUserViewController alloc]init];
                usertVC.username = _usernameTextFeild.text;
                [self.navigationController pushViewController:usertVC animated:YES];
            }
            else
            {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名和密码不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户不存在，请先注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
       
  
 

    }
    
}


#pragma mark -返回到注册按钮

- (IBAction)registAction:(id)sender
{
    DURegistController *registVC = [[DURegistController alloc]init];
    
    [self.navigationController pushViewController:registVC animated:YES];

    
}


#pragma mark ----点击空白处回收键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_usernameTextFeild resignFirstResponder];
    [_passwordTextFeild resignFirstResponder];
}





@end
