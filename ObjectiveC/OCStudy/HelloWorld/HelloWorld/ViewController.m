//
//  ViewController.m
//  HelloWorld
//
//  Created by Kim Dong-woo on 2017. 2. 26..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ButtonClk:(id)sender {
    NSString* str = [_textURL text];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:req];
    
}

@end
