//
//  ViewController.h
//  FloridaDemo
//
//  Created by Rudych, Ihor on 4/3/15.
//  Copyright (c) 2015 Ihor Rudych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *updateDataBtn;
@property (strong,nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;


@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider2;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider3;
@property (weak, nonatomic) IBOutlet UISwitch *switchGPS;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@end

