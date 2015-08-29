//
//  LocationViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MagicalRecord/MagicalRecord.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationViewController.h"
#import "Masonry.h"
#import "TMTeam.h"
#import "UIColor+Helper.h"
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"

@interface LocationViewController () <ComposeViewControllerProtocol, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) UIButton *locationButton;
@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) TeamButtons *teamButtons;

@property (strong, nonatomic) UIView *alternativeLocationsMenu;
@property (strong, nonatomic) UIView *selectedFlag;
@property (strong, nonatomic) NSArray *alternativeLocations;
@property (strong, nonatomic) NSString *selectedLocation;
@property (strong, nonatomic) MASConstraint *selectedFlagCenterYConstraint;

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
    [publishButton addTarget:self action:@selector(preparePublish:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [map mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20).priorityHigh();
        make.right.equalTo(self.view).offset(-20).priorityHigh();
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
    UIView *alternativeLocationsMenu = [UIView new];
    alternativeLocationsMenu.backgroundColor = [UIColor colorWithRGBA:0xDDDDDDFF];
    
    UIButton *prevButton;
    __block UIButton *firstButton;
    
    // 可选地址
    for (int i = 0; i < self.alternativeLocations.count; i++) {
        NSString *location = self.alternativeLocations[i];
        
        UIButton *currentButton = [UIButton new];
        currentButton.backgroundColor = [UIColor whiteColor];
        currentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        currentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        currentButton.titleLabel.textColor = [UIColor blackColor];
        currentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [currentButton addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
        [currentButton setTitle:location forState:UIControlStateNormal];
        [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [alternativeLocationsMenu addSubview:currentButton];
        [currentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(alternativeLocationsMenu);
            make.height.equalTo(@45);
            
            if (i == 0) {
                make.top.equalTo(alternativeLocationsMenu);
                firstButton = currentButton;
            } else {
                make.top.equalTo(prevButton.mas_bottom).offset(1);
            }
            
            if (i == self.alternativeLocations.count - 1) {
                make.bottom.equalTo(alternativeLocationsMenu);
            }
        }];
        
        prevButton = currentButton;
    }
    
    // 选中标记
    UIView *selectedFlag = [UIView new];
    self.selectedFlag = selectedFlag;
    selectedFlag.backgroundColor = [UIColor colorWithRGBA:0x54B884FF];
    selectedFlag.layer.cornerRadius = 4;
    selectedFlag.layer.masksToBounds = YES;
    [alternativeLocationsMenu addSubview:selectedFlag];
    [selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(alternativeLocationsMenu).offset(-15);
        self.selectedFlagCenterYConstraint = make.centerY.equalTo(firstButton);
        make.size.equalTo(@8);
        make.height.equalTo(@8);
    }];
    
    return alternativeLocationsMenu;
}

// 显示可选地址菜单
- (void)showAlternativeLocations
{
    UIView *alternativeLocationsMenu;
    
    if (!self.alternativeLocationsMenu) {
        alternativeLocationsMenu = [self createLocationsView];
        self.alternativeLocationsMenu = alternativeLocationsMenu;
    } else {
        alternativeLocationsMenu = self.alternativeLocationsMenu;
    }
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideComposePager" object:nil];
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
        
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showComposePager" object:nil];
    }];
}

// 选择地址
- (void)selectLocation:(UIButton *)sender
{
    self.selectedLocation = sender.titleLabel.text;
    
    [self.selectedFlagCenterYConstraint uninstall];
    [self.selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        self.selectedFlagCenterYConstraint = make.centerY.equalTo(sender);
    }];
    
    [self hideAlternativeLocations];
    [self.locationButton setTitle:self.selectedLocation forState:UIControlStateNormal];
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

- (void)preparePublish:(UIButton *)sender
{
    if (self.buttonsViewBeginSlidingUp) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideComposePager" object:nil];
    
    self.buttonsViewBeginSlidingUp = YES;
    
    // 团队按钮
    TeamButtons *teamButtons = [[TeamButtons alloc] initWithTeams:self.teams];
    [self.view addSubview:teamButtons];
    self.teamButtons = teamButtons;
    teamButtons.delegate = self;
    
    [teamButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
    
    [teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.buttonsViewBeginSlidingUp = NO;
    }];
}

- (void)cancelPublish:(UIButton *)sender
{
    [self hideButtons];
}

- (void)hideButtons
{
    [self.teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.teamButtons removeFromSuperview];
        self.teamButtons = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showComposePager" object:nil];
    }];
}

- (void)publish:(UIButton *)sender
{
    NSInteger teamId = sender.tag;
    NSLog(@"%ld", (long)teamId);
}

- (void)resetLayout
{
    [self hideButtons];
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

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    return _teams;
}

@end
