//
//  CWStarRateView.m
//  StarRateDemo
//
//  Created by WANGCHAO on 14/11/4.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "CWStarRateView.h"

#define FOREGROUND_STAR_IMAGE_NAME @"icon_poi_star_h"
#define BACKGROUND_STAR_IMAGE_NAME @"icon_poi_star"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 0.2

@interface CWStarRateViewContentView : UIView

@property (nonatomic, strong) NSMutableArray *starWidthConstraints;
@property (nonatomic, assign) NSInteger numberOfStars;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars image:(UIImage *)image autoWidth:(BOOL)autoWidth;

@end

@interface CWStarRateView ()

@property (nonatomic, strong) CWStarRateViewContentView *foregroundStarView;
@property (nonatomic, strong) CWStarRateViewContentView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, strong) NSLayoutConstraint *foregroundStarViewWidth;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation CWStarRateView

#pragma mark - Init Methods
- (instancetype)init {
    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithNumberOfStars:DEFALUT_STAR_NUMBER];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        [self buildDataAndUI];
    }
    return self;
}

- (instancetype)initWithNumberOfStars:(NSInteger)numberOfStars {
    if (self = [super initWithFrame:CGRectZero]) {
        _numberOfStars = numberOfStars;
        [self buildDataAndUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)buildDataAndUI {
    _scorePercent = 1;//默认为1
    _allowIncompleteStar = NO;//默认为NO
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    self.backgroundStarView.translatesAutoresizingMaskIntoConstraints = false;
    self.foregroundStarView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint constraintWithItem:self.backgroundStarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.backgroundStarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.backgroundStarView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.backgroundStarView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.foregroundStarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.foregroundStarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.foregroundStarView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    _foregroundStarViewWidth = [NSLayoutConstraint constraintWithItem:self.foregroundStarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
    _foregroundStarViewWidth.active = YES;
}


- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    self.scorePercent = starScore / self.numberOfStars;
}

- (UIImageView *)createStarViewWithImage:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    return imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _foregroundStarViewWidth.constant = self.bounds.size.width * self.scorePercent;
}

#pragma mark - Get and Set Methods

- (void)setAllowTap:(BOOL)allowTap {
    if (_allowTap == allowTap) {
        return;
    }
    _allowTap = allowTap;
    if (allowTap && _tapGesture == nil) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    else {
        [self removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
}

- (void)setScorePercent:(CGFloat)scorePercent {
    [self setScorePercent:scorePercent animated:NO];
}

- (void)setScorePercent:(CGFloat)scroePercent animated:(BOOL)animated {
    if (_scorePercent == scroePercent) {
        return;
    }
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scroePercent;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)]) {
        [self.delegate starRateView:self scroePercentDidChange:scroePercent];
    }
    
    _foregroundStarViewWidth.constant = self.bounds.size.width * scroePercent;
    if (animated) {
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            [self layoutIfNeeded];
        }];
    }
}


- (CWStarRateViewContentView *)foregroundStarView {
    if (!_foregroundStarView) {
        CWStarRateViewContentView *view = [[CWStarRateViewContentView alloc] initWithFrame:self.bounds numberOfStars:self.numberOfStars image:[UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME] autoWidth:NO];
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor clearColor];
        _foregroundStarView = view;
    }
    return _foregroundStarView;
}

- (CWStarRateViewContentView *)backgroundStarView {
    if (!_backgroundStarView) {
        CWStarRateViewContentView *view = [[CWStarRateViewContentView alloc] initWithFrame:self.bounds numberOfStars:self.numberOfStars image:[UIImage imageNamed:BACKGROUND_STAR_IMAGE_NAME] autoWidth:YES];
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor clearColor];
        _backgroundStarView = view;
    }
    return _backgroundStarView;
}

@end

@implementation CWStarRateViewContentView {
    BOOL _autoWidth;
    UIImage *_image;
    
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars image:(UIImage *)image autoWidth:(BOOL)autoWidth {
    if (self = [super initWithFrame:frame]) {
        _autoWidth = autoWidth;
        _image = image;
        self.numberOfStars = numberOfStars;
    }
    return self;
}

- (void)setNumberOfStars:(NSInteger)numberOfStars {
    if (_numberOfStars == numberOfStars) {
        return;
    }
    _numberOfStars = numberOfStars;
    [self clearStar];
    
    NSMutableArray *viewKeys = @[].mutableCopy;
    NSMutableString *strM = @"".mutableCopy;
    NSMutableDictionary *viewDict = @{}.mutableCopy;
    for (NSInteger i = 0; i < numberOfStars; i++) {
        UIImageView *starView = [self createStarViewWithImage:_image];
        [self addSubview:starView];
        [NSLayoutConstraint constraintWithItem:starView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:starView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
        
        NSString *viewKey = [NSString stringWithFormat:@"Star%ld", i];
        [viewDict setObject:starView forKey:viewKey];
        NSString *previousKey = nil;
        if (i > 0) {
            previousKey = viewKeys[i-1];
        }
        if (_autoWidth) {
            [strM appendFormat:@"[%@%@]", viewKey, previousKey?[NSString stringWithFormat:@"(==%@)", previousKey]:@""];
        }
        else {
            [strM appendFormat:@"[%@]", viewKey];
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:starView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
            widthConstraint.active = YES;
            [self.starWidthConstraints addObject:widthConstraint];
        }
        [viewKeys addObject:viewKey];
    }
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@%@", strM, _autoWidth?@"|":@""] options:kNilOptions metrics:nil views:viewDict]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.superview) {
        for (NSLayoutConstraint *widthConstraint in self.starWidthConstraints) {
            CGFloat width = self.superview.bounds.size.width / self.numberOfStars;
            widthConstraint.constant = width;
        }
    }
}

- (UIImageView *)createStarViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    return imageView;
}

- (void)clearStar {
    [NSLayoutConstraint deactivateConstraints:self.starWidthConstraints];
    [self.starWidthConstraints removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [NSLayoutConstraint deactivateConstraints:self.constraints];
}

- (NSMutableArray *)starWidthConstraints {
    if (!_starWidthConstraints) {
        _starWidthConstraints = @[].mutableCopy;
    }
    return _starWidthConstraints;
}
@end
