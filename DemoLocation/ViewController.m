//
//  ViewController.m
//  DemoLocation
//
//  Created by Glority_Lee on 17/1/23.
//  Copyright © 2017年 Glority_Lee. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>

#define YSiOSLeastVersion(iOSVersion) (([[[UIDevice currentDevice] systemVersion] floatValue]) >= (iOSVersion))

@interface ViewController ()<MAMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *maMapView;
@property (nonatomic, strong) CLLocationManager *locationM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initMapView];
    [self initUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMapView {
    _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _maMapView.delegate = self;
    [self.view addSubview:_maMapView];
    [self.view sendSubviewToBack:_maMapView];
    
    _maMapView.showsCompass = NO;
    _maMapView.showsScale = NO;
    [_maMapView setZoomLevel:14.1 animated:NO];
    
    MAUserLocationRepresentation *userRt = [[MAUserLocationRepresentation alloc] init];
    userRt.image = nil;
    userRt.showsAccuracyRing = NO;
    userRt.showsHeadingIndicator = NO;
    [_maMapView updateUserLocationRepresentation:userRt];
    
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined)) {
        //用户已经操作了定位权限
        _maMapView.showsUserLocation = YES;
        [_maMapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];
    }
}

- (void)initUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"点一点开定位权限" forState:UIControlStateNormal];
    btn.frame = (CGRect){0, 200, 100, 60};
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
    
}


#pragma mark - lazy loading
- (CLLocationManager *)locationM {
    if (_locationM == nil) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
    }
    return _locationM;
}

#pragma mark - Location Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (status == kCLAuthorizationStatusAuthorized ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        
    }else if(status == kCLAuthorizationStatusNotDetermined) {
        //忽略不记录
    }else {
        //其他的是不允许定位
    }
#pragma clang diagnostic pop
}

#pragma mark - Action Methods
- (void)btnAction:(UIButton *)sender {
    //配置定位权限
    if (YSiOSLeastVersion(8.0)) {
        if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            [self.locationM requestWhenInUseAuthorization];
        }else {
            //[self.parentViewController performSelector:@selector(clickLocationButton)];
        }
        _maMapView.showsUserLocation = YES;
        [_maMapView setUserTrackingMode:MAUserTrackingModeFollow animated:NO];
    }
}

@end
