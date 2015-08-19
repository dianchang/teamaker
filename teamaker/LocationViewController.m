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

@interface LocationViewController () <ComposeViewControllerProtocol, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) UILabel *locationLabel;
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

- (void)resetLayout
{

}

@end
