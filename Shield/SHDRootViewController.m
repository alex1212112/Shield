//
//  SHDRootViewController.m
//  Shield
//
//  Created by renguohua on 2021/8/12.
//

#import "SHDRootViewController.h"

@interface SHDRootViewController ()

@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) UIButton *button;

@property(nonatomic, strong) CADisplayLink *displayLink;

@property(nonatomic, assign) BOOL fpsing;

@property(nonatomic, assign) CGFloat lastTime;

@property(nonatomic, assign) NSInteger count;


@end

@implementation SHDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self configData];
    [self configViews];

    
}

- (void)configNavigationBar {
    self.navigationItem.title = @"Root";
}

- (void)configViews {
    [self configBackgroundView];
    [self configLabel];
    [self configButton];
}

- (void)configData {
    self.fpsing = NO;
    self.lastTime = 0;
    self.count = 0;
}

- (void)configBackgroundView {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configLabel {
   
    self.label.text = @"Hello, world";
    self.label.textColor = [UIColor redColor];
    [self.view addSubview:self.label];
}

- (void)configButton {
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self updateLabelConstraints];
    [self updateButtonConstraints];
}

- (void)updateLabelConstraints {
    
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *labelCenterXConstraits = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *labelCenterYConstraits = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSArray *labelConstraints = @[labelCenterXConstraits, labelCenterYConstraits];
    [NSLayoutConstraint activateConstraints:labelConstraints];
}

- (void)updateButtonConstraints {
    
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *buttonCenterXConstraits = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *buttonYConstraits = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    
    NSArray *constraints = @[buttonCenterXConstraits, buttonYConstraits];
    [NSLayoutConstraint activateConstraints:constraints];
}



#pragma mark - Others

- (void)startFps {
    self.displayLink.paused = NO;
    [self resetDisplayLinkData];
}

- (void)stopFps {
    self.displayLink.paused = YES;
    [self resetDisplayLinkData];
}

- (void)resetDisplayLinkData {
    self.lastTime = 0;
    self.count = 0;
}


#pragma mark - Event

- (void)buttonClick:(id)sender {
    if(self.fpsing) {
        [self stopFps];
        [_button setTitle: @"Start" forState:UIControlStateNormal];
    } else {
        [self startFps];
        [_button setTitle: @"Stop" forState:UIControlStateNormal];
    }
    self.fpsing = !self.fpsing;
}

- (void)displayLinkEventFired:(CADisplayLink *)displayLink {
    if(self.lastTime == 0) {
        self.lastTime = displayLink.timestamp;
        self.count = 0;
        return;
    }
    self.count++;
    NSLog(@"%ld===%f",self.count, displayLink.timestamp);
    CGFloat time = displayLink.timestamp - self.lastTime;
    if(time >= 1.0) {
        CGFloat hz =  self.count / time;
        NSString *string = [NSString stringWithFormat:@"%f",hz];
        self.label.text = string;
        self.lastTime = displayLink.timestamp;
        self.count = 0;
    }
    
}


#pragma mark - Setters and Getters


- (UILabel *)label {
    if(!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (UIButton *)button {
    if(!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button setTitle: @"Start" forState:UIControlStateNormal];
    }
    return _button;
}

- (CADisplayLink *)displayLink {
    if(!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkEventFired:)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
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
