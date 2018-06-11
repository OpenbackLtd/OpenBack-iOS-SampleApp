//
//  ViewController.m
//  SampleApp
//
//  Created by Nicolas on 6/11/18.
//  Copyright © 2018 OpenBack. All rights reserved.
//

@import OpenBack;
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTrigger1:(id)sender {
    NSError *error = nil;
    if (![OpenBack setValue:@"Bob" forCustomTrigger:kOBKCustomTrigger1 error:&error]) {
        NSLog(@"Oops! %@", error);
    }
}

- (IBAction)handleTrigger2:(id)sender {
    NSError *error = nil;
    if (![OpenBack setValue:@(42) forCustomTrigger:kOBKCustomTrigger2 error:&error]) {
        NSLog(@"Oops! %@", error);
    }
}

- (IBAction)handleTrigger3:(id)sender {
    NSError *error = nil;
    if (![OpenBack setValue:@(1.12f) forCustomTrigger:kOBKCustomTrigger3 error:&error]) {
        NSLog(@"Oops! %@", error);
    }
}

- (IBAction)handleUserInfo:(id)sender {
    NSDictionary *info = @{
        kOBKUserInfoFirstName: self.firstNameLabel.text ? : @"",
        kOBKUserInfoSurname: self.lastNameLabel.text ? : @"",
    };
    
    NSError *error = nil;
    if (![OpenBack setUserInfo:info error:&error]) {
        NSLog(@"Oops! %@", error);
    }
}

@end
