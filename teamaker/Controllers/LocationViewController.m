//
//  LocationViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationViewController.h"
#import "Masonry.h"
#import "UIColor+Helper.h"
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"

@interface LocationViewController () <ComposeViewControllerProtocol, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) UIButton *locationButton;
@property (strong, nonatomic) TeamButtons *buttonsView;
@property (strong, nonatomic) UIView *alternativeLocationsMenu;
@property (strong, nonatomic) NSArray *alternativeLocations;
@property (strong, nonatomic) NSString *selectedLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL buttonsViewBeginSlidingUp;

@end

@implementation LocationViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // 地图
    MKMapView *map = [[MKMapView alloc] init];
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeStandard;
    map.rotateEnabled = NO;
    map.pitchEnabled = NO;
    map.zoomEnabled = NO;
    map.scrollEnabled = NO;
    [self.view addSubview:map];
    self.map = map;
    
    // 地址
    UIButton *locationButton = [UIButton new];
    [locationButton setTitle:@"朝阳区青年路润丰水尚西区" forState:UIControlStateNormal];
    locationButton.backgroundColor = [UIColor grayColor];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    locationButton.titleLabel.textColor = [UIColor whiteColor];
    locationButton.layer.cornerRadius = 3;
    locationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    locationButton.layer.masksToBounds = YES;
    [locationButton addTarget:self action:@selector(showAlternativeLocations) forControlEvents:UIControlEventTouchUpInside];
    self.locationButton = locationButton;
    [self.view addSubview:locationButton];
    
    // 发布按钮
    UIButton *publishButton = [[UIButton alloc] init];
    publishButton.backgroundColor = [UIColor colorWithRGBA:0x999999FF];
    publishButton.layer.cornerRadius = 25;
    publishButton.layer.masksToBounds = YES;
    [self.view addSubview:publishButton];
    [publishButton addTarget:self action:@selector(publishLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [map mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30).priorityHigh();
        make.right.equalTo(self.view).offset(-30).priorityHigh();
        make.height.equalTo(@40);
        make.top.equalTo(self.view).with.offset(30);
    }];

    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    self.locationManager = locationManager;
    locationManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (UIView *)createLocationsView
{
    if (self.alternativeLocationsMenu) {
        [self.alternativeLocationsMenu removeFromSuperview];
    }
    
    UIView *alternativeLocationsMenu = [UIView new];
    alternativeLocationsMenu.backgroundColor = [UIColor colorWithRGBA:0xDDDDDDFF];
    
    UIButton *prevButton;
    
    // 可选地址
    for (int i = 0; i < self.alternativeLocations.count; i++) {
        NSString *location = self.alternativeLocations[i];
        
        UIButton *currentButton = [UIButton new];
        currentButton.backgroundColor = [UIColor whiteColor];
        currentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        currentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        currentButton.titleLabel.textColor = [UIColor blackColor];
        currentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [currentButton setTitle:location forState:UIControlStateNormal];
        [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [alternativeLocationsMenu addSubview:currentButton];
        [currentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(alternativeLocationsMenu);
            make.height.equalTo(@45);
            
            if (i == 0) {
                make.top.equalTo(alternativeLocationsMenu);
            } else {
                make.top.equalTo(prevButton.mas_bottom).offset(1);
            }
            
            if (i == self.alternativeLocations.count - 1) {
                make.bottom.equalTo(alternativeLocationsMenu);
            }
        }];
        
        prevButton = currentButton;
    }
    
    return alternativeLocationsMenu;
}

// 显示可选地址菜单
- (void)showAlternativeLocations
{
    UIView *alternativeLocationsMenu = [self createLocationsView];
    self.alternativeLocationsMenu = alternativeLocationsMenu;
    [self.view addSubview:self.alternativeLocationsMenu];
    
    [alternativeLocationsMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top);
    }];
    
    [self.view layoutIfNeeded];
    
    [alternativeLocationsMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 隐藏可选地址菜单
- (void)hideAlternativeLocations
{
    [self.alternativeLocationsMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];

    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    CGFloat zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    [gc reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark* place in placemarks) {
            if (place.region) {
                NSLog( @"%@", place.region);
            }
            
            if (place.thoroughfare) {
                NSLog( @"%@ %@", place.subThoroughfare, place.thoroughfare);
            }
            
            for (NSString* aoi in place.areasOfInterest) {
                NSLog( @"%@", aoi);
            }
        }
    }];
}

- (void)publishLocation:(UIButton *)sender
{
    if (self.buttonsViewBeginSlidingUp) {
        return;
    }
    
    [self hideAlternativeLocations];
    
    self.buttonsViewBeginSlidingUp = YES;
    TeamButtons *buttonsView = [[TeamButtons alloc] initWithController:self cancelAction:@selector(cancelPublish:) publishAction:@selector(publishToTeam:)];
    self.buttonsView = buttonsView;
    [self.view addSubview:buttonsView];
    
    CGRect frame = buttonsView.frame;
    frame.origin.y = frame.origin.y - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        buttonsView.frame = frame;
    } completion:^(BOOL finished) {
        self.buttonsViewBeginSlidingUp = NO;
    }];
}

- (void)cancelPublish:(UIButton *)sender
{
    CGRect frame = self.buttonsView.frame;
    frame.origin.y = self.view.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonsView.frame = frame;
    } completion:^(BOOL finished) {
        [self.buttonsView removeFromSuperview];
    }];
}

- (void)publishToTeam:(UIButton *)sender
{
    NSInteger teamId = sender.tag;
    NSLog(@"%ld", (long)teamId);
}

- (void)resetLayout
{

}

- (NSArray *)alternativeLocations
{
    if (!_alternativeLocations) {
        _alternativeLocations = @[@"朝阳区青年路润枫水尚西区",
                                  @"漫咖啡（十里堡店）",
                                  @"华纺易城",
                                  @"十里堡",
                                  @"润枫水尚"];
    }
    
    return _alternativeLocations;
}

@end
