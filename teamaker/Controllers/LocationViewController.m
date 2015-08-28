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

@property (weak, nonatomic) MKMapView *map;
@property (weak, nonatomic) UILabel *locationLabel;
@property (weak, nonatomic) TeamButtons *buttonsView;
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
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = @"朝阳区青年路润丰水尚西区";
    locationLabel.backgroundColor = [UIColor grayColor];
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.layer.cornerRadius = 3;
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.layer.masksToBounds = YES;
    self.locationLabel = locationLabel;
    [self.view addSubview:locationLabel];
    
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
    
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
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

- (IBAction)cancelPublish:(UIButton *)sender
{
    CGRect frame = self.buttonsView.frame;
    frame.origin.y = self.view.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonsView.frame = frame;
    } completion:^(BOOL finished) {
        [self.buttonsView removeFromSuperview];
    }];
}

- (IBAction)publishToTeam:(UIButton *)sender
{
    NSInteger teamId = sender.tag;
    NSLog(@"%ld", (long)teamId);
}

- (void)resetLayout
{

}

@end
