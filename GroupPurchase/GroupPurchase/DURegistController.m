//
//  DURegistController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DURegistController.h"
#import "DUDBmanager.h"
#import "DUUserViewController.h"


@interface DURegistController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCode;
- (IBAction)registAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation DURegistController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = @"注册";
    //改变Button的样式
    self.registButton.clipsToBounds = YES;
    self.registButton.layer.cornerRadius = 4;
    self.nameTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.confirmCode.delegate = self;
    self.codeTextField.secureTextEntry = YES;
    self.confirmCode.secureTextEntry = YES;
   
}





- (IBAction)registAction:(id)sender
{
    BOOL isExist = [[DUDBmanager sharedManager]isExists:_nameTextField.text];
    if (isExist) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [[DUDBmanager sharedManager]insertUsername:_nameTextField.text withPassword:_codeTextField.text];
        
        DUUserViewController *userVC = [[DUUserViewController alloc]init];
        userVC.username = _nameTextField.text;
        [self.navigationController pushViewController:userVC animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

//点击空白处，收起键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.confirmCode resignFirstResponder];
}





@end
