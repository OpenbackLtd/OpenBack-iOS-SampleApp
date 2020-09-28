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
    [OpenBack setValue:@"Bob" forCustomSegment:kOBKCustomSegment1];
}

- (IBAction)handleTrigger2:(id)sender {
    [OpenBack setValue:@(42) forCustomSegment:kOBKCustomSegment2];
}

- (IBAction)handleTrigger3:(id)sender {
    [OpenBack setValue:@(1.12f) forCustomSegment:kOBKCustomSegment3];
}

- (IBAction)handleUserInfo:(id)sender {
    [OpenBack setValue:self.firstNameLabel.text ? : @"" forAttribute:kOBKUserFirstName];
    [OpenBack setValue:self.lastNameLabel.text ? : @"" forAttribute:kOBKUserSurname];
}

@end
