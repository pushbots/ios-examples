//
//  PaymentViewController.m
//  RichNotificationExample
//
//  Created by Atiaa on 2/23/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.numberLabel.text = [NSString stringWithFormat:@"Payemnt #%@",self.payementID];
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
