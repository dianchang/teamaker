//
//  LocationViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
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
@end

@implementation LocationViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // 地址
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = @"Location";
    self.locationLabel = locationLabel;
    [self.view addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(20);
    }];
    
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
    [map mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 发布按钮
    UIButton *publishButton = [[UIButton alloc] init];
    publishButton.backgroundColor = [UIColor colorWithRGBA:0x1E90FFFF];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.view addSubview:publishButton];
    [publishButton addTarget:self action:@selector(publishLocation:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
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

- (IBAction)publishLocation:(UIButton *)sender
{
    TeamButtons *buttonsView = [[TeamButtons alloc] initWithController:self cancelAction:@selector(cancelPublish:) publishAction:@selector(publishToTeam:)];
    self.buttonsView = buttonsView;
    [self.view addSubview:buttonsView];
    
    CGRect frame = buttonsView.frame;
    frame.origin.y = frame.origin.y - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        buttonsView.frame = frame;
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
