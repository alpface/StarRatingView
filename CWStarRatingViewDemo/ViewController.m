//
//  ViewController.m
//  CWStarRatingViewDemo
//
//  Created by WANGCHAO on 14/11/8.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "CWStarRateView.h"

@interface ViewController ()

@property (strong, nonatomic) CWStarRateView *starRateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.starRateView = [[CWStarRateView alloc] initWithNumberOfStars:5];
    self.starRateView.scorePercent = 0.3;
    self.starRateView.allowIncompleteStar = YES;
    [self.view addSubview:self.starRateView];
    self.starRateView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint constraintWithItem:self.starRateView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.starRateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.starRateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.starRateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0].active = YES;
    
}

@end
