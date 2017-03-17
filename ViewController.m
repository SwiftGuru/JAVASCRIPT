//
//  ViewController.m
//  FloridaDemo
//
//  Created by Rudych, Ihor on 4/3/15.
//  Copyright (c) 2015 Ihor Rudych. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property(strong)AGSGraphicsLayer *graphicLayer;
@property(strong)AGSGraphicsLayer *graphicLayer2;
@property(strong)AGSGraphicsLayer *graphicLayer3;
@property(strong)AGSSketchGraphicsLayer *sketchLayer;
@property(strong)AGSMutablePolygon *sPolygon;



@end

@implementation ViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize opacitySlider;



#pragma FeatureLayer Stuff
typedef enum {
    SpringFertilizer = 0,
    Ryegrass,
    FallFertilizer,
    BroadleafSpray
    
} GraphicType;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.mapView.callout.delegate = self;
    AGSLocalTiledLayer *locTiles = [AGSLocalTiledLayer localTiledLayerWithName:@"florida"];
    AGSSpatialReference *ref = [AGSSpatialReference spatialReferenceWithWKID:102100];
    self.graphicLayer = [[AGSGraphicsLayer alloc]initWithSpatialReference:ref];
    self.graphicLayer2 = [[AGSGraphicsLayer alloc]initWithSpatialReference:ref];
    self.graphicLayer3 = [[AGSGraphicsLayer alloc]initWithSpatialReference:ref];
    [self.mapView addMapLayer:locTiles];
    [self.mapView addMapLayer:self.graphicLayer];
    [self.mapView addMapLayer:self.graphicLayer2];
    [self.mapView addMapLayer:self.graphicLayer3];
    
    self.mapView.callout.delegate = self;
    
    [self grabFeaturesAndDraw];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateData:(id)sender {
    [self syncUtilities];
}
-(void)syncUtilities{
    NSString *utilityServiceBaseURL = @"http://agngis2:6080/arcgis/rest/services/FLDemoService/MapServer/";
    NSString *utilityServiceFeatureURL = @"/query?where=1%3D1&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&f=pjson";
    NSArray *featureLayerNames =  [[NSArray alloc] initWithObjects:@"T2015_SpringFertilizer", @"T2015_Ryegrass", @"T2015_FallFertilizer", @"T2015_BroadleafSpray",@"T2014_BroadleafSpray", @"T2014_FallFertilizer", @"T2014_Ryegrass",@"T2014_SpringFertilizer",@"T2013_BroadleafSpray", @"T2013_Ryegrass",@"T2013_SpringFertilizer",nil];
    
    for(int x=0;x<11;x++)
    {
        NSString *feature = [featureLayerNames objectAtIndex:x];
        [self getUtilitiesLayersUrl:[NSString stringWithFormat:@"%@%d?f=pjson",utilityServiceBaseURL,x]
                            forFile:[NSString stringWithFormat:@"%@Definition",feature]];
        [self getUtilitiesLayersUrl:[NSString stringWithFormat:@"%@%d%@",utilityServiceBaseURL,x,utilityServiceFeatureURL]
                            forFile:feature];
    }

    
}
- (void)getUtilitiesLayersUrl:(NSString*)_Url
                      forFile:(NSString*)layerFileName
{
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //live json data url
    NSString *stringURL = _Url;
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    //attempt to download live data
    if (urlData)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.json", documentsDirectory,layerFileName];
        NSLog(@"writing file: %@",filePath);
        [urlData writeToFile:filePath atomically:YES];
    }
}
-(void)grabFeaturesAndDraw
{
    AGSFeatureLayer *T2015_SpringFertilizer = [self getFeatureLayerFromPath:@"T2015_SpringFertilizer"];
    AGSFeatureLayer *T2015_Ryegrass= [self getFeatureLayerFromPath:@"T2015_Ryegrass"];
    AGSFeatureLayer *T2015_FallFertilizer = [self getFeatureLayerFromPath:@"T2015_FallFertilizer"];
    AGSFeatureLayer *T2015_BroadleafSpray = [self getFeatureLayerFromPath:@"T2015_BroadleafSpray"];
    AGSFeatureLayer *T2014_BroadleafSpray = [self getFeatureLayerFromPath:@"T2014_BroadleafSpray"];
    AGSFeatureLayer *T2014_FallFertilizer = [self getFeatureLayerFromPath:@"T2014_FallFertilizer"];
    AGSFeatureLayer *T2014_Ryegrass = [self getFeatureLayerFromPath:@"T2014_Ryegrass"];
    AGSFeatureLayer *T2014_SpringFertilizer = [self getFeatureLayerFromPath:@"T2014_SpringFertilizer"];
    AGSFeatureLayer *T2013_BroadleafSpray = [self getFeatureLayerFromPath:@"T2013_BroadleafSpray"];
    AGSFeatureLayer *T2013_Ryegrass = [self getFeatureLayerFromPath:@"T2013_Ryegrass"];
    AGSFeatureLayer *T2013_SpringFertilizer = [self getFeatureLayerFromPath:@"T2013_SpringFertilizer"];
    
    
    [self addFeaturesToGraphicsLayer3:T2015_SpringFertilizer hasCallout:YES withGraphicType:SpringFertilizer];
    [self addFeaturesToGraphicsLayer3:T2015_Ryegrass hasCallout:YES  withGraphicType:Ryegrass];
    [self addFeaturesToGraphicsLayer3:T2015_FallFertilizer hasCallout:YES withGraphicType:FallFertilizer];
    [self addFeaturesToGraphicsLayer3:T2015_BroadleafSpray hasCallout:YES withGraphicType:BroadleafSpray];
    [self addFeaturesToGraphicsLayer2:T2014_BroadleafSpray hasCallout:YES  withGraphicType:BroadleafSpray];
    [self addFeaturesToGraphicsLayer2:T2014_FallFertilizer hasCallout:YES  withGraphicType:FallFertilizer];
    [self addFeaturesToGraphicsLayer2:T2014_Ryegrass hasCallout:YES withGraphicType:Ryegrass];
    [self addFeaturesToGraphicsLayer2:T2014_SpringFertilizer hasCallout:YES withGraphicType:SpringFertilizer];
    [self addFeaturesToGraphicsLayer:T2013_BroadleafSpray hasCallout:YES  withGraphicType:BroadleafSpray];
    [self addFeaturesToGraphicsLayer:T2013_Ryegrass hasCallout:YES withGraphicType:Ryegrass];
    [self addFeaturesToGraphicsLayer:T2013_SpringFertilizer hasCallout:YES withGraphicType:SpringFertilizer];
    
    
    [self.graphicLayer refresh];
    [self.graphicLayer2 refresh];
    [self.graphicLayer3 refresh];
}
-(void)addFeaturesToGraphicsLayer:(AGSFeatureLayer*)_myFeature
                       hasCallout:(BOOL)_delegate
                  withGraphicType:(GraphicType)graphicType
{
    for(AGSGraphic *graphic in _myFeature.graphics)
    {
        graphic.symbol =[_myFeature.renderer symbolForFeature: graphic timeExtent:nil];
       
        if(_delegate)
         //  graphic.infoTemplateDelegate = self;
        [graphic setAttribute:[NSNumber numberWithInt:graphicType] forKey:@"GraphicType"];
        [self.graphicLayer addGraphic:graphic];
            }
}
-(void)addFeaturesToGraphicsLayer2:(AGSFeatureLayer*)_myFeature
                       hasCallout:(BOOL)_delegate
                  withGraphicType:(GraphicType)graphicType
{
    for(AGSGraphic *graphic in _myFeature.graphics)
    {
        graphic.symbol =[_myFeature.renderer symbolForFeature: graphic timeExtent:nil];
        
        if(_delegate)
            //  graphic.infoTemplateDelegate = self;
            [graphic setAttribute:[NSNumber numberWithInt:graphicType] forKey:@"GraphicType"];
        [self.graphicLayer2 addGraphic:graphic];
    }
}

-(void)addFeaturesToGraphicsLayer3:(AGSFeatureLayer*)_myFeature
                       hasCallout:(BOOL)_delegate
                  withGraphicType:(GraphicType)graphicType
{
    for(AGSGraphic *graphic in _myFeature.graphics)
    {
        graphic.symbol =[_myFeature.renderer symbolForFeature: graphic timeExtent:nil];
        
        if(_delegate)
            //  graphic.infoTemplateDelegate = self;
            [graphic setAttribute:[NSNumber numberWithInt:graphicType] forKey:@"GraphicType"];
        [self.graphicLayer3 addGraphic:graphic];
    }
}



-(AGSFeatureLayer*)getFeatureLayerFromPath:(NSString*)_path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *definitionFilename = [NSString stringWithFormat:@"%@Definition.json",_path ];
    NSString *definitionFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,definitionFilename];
    
    NSLog(@"getting file: %@",definitionFilePath);
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:definitionFilePath encoding:NSUTF8StringEncoding error:nil];
    
    AGSSBJsonParser *parser = [[AGSSBJsonParser alloc] init];
    NSDictionary *definition = (NSDictionary *) [parser objectWithString:fileContent error:nil];
    
    NSString *featureFileName = [NSString stringWithFormat:@"%@.json",_path ];
    NSString *featureFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,featureFileName];
    NSLog(@"getting file: %@",featureFilePath);
    NSString *featureFileContent = [[NSString alloc] initWithContentsOfFile:featureFilePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *featureSet = (NSDictionary *) [parser objectWithString:featureFileContent error:nil];
    AGSFeatureLayer *myFeatureLayer = [[AGSFeatureLayer alloc] initWithLayerDefinitionJSON:definition featureSetJSON:featureSet];
    return myFeatureLayer;
}
- (IBAction)loadData:(id)sender {
    [self grabFeaturesAndDraw];
}
- (BOOL)callout:(AGSCallout *)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable> *)layer mapPoint:(AGSPoint *)mapPoint {
    mapView.callout.title = (NSString *)[feature attributeForKey:@"Treat_Type"];
    mapView.callout.detail = (NSString *)[feature attributeForKey:@"Year"];
    mapView.callout.image = [UIImage imageNamed:@"dcc-gen29.png"];
    return YES;
}
/*- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic {
    NSNumber *typeNumber = (NSNumber*)[graphic attributeAsStringForKey:@"GraphicType"];
    GraphicType graphicType = typeNumber.intValue;
    if(typeNumber<[NSNumber numberWithInt:10]){
        NSString *myCalloutTitle;
        NSString *myCalloutDetails;
        switch (graphicType)
        {
            case SpringFertilizer:
                
                myCalloutTitle = @"Spring Fertilizer";
                myCalloutDetails = [NSString stringWithFormat:@"Unit #: %@ \n %8s%8s \n\nPasture: %@",
                                    [graphic attributeAsStringForKey:@"Pasture"],[@" " UTF8String],
                                    [[graphic attributeAsStringForKey:@"Treat_Type"] UTF8String],
                                    [graphic attributeAsStringForKey:@"Acres"]];
                break;
            case Ryegrass:
                myCalloutTitle = @"Ryegrass";
                myCalloutDetails = [NSString stringWithFormat:@"Unit #:\t%@ \n"
                                    "Grid #: %@ \n"
                                    "Feeder ID: %@ \n"
                                    "Rating: %@KVA",
                                    [graphic attributeAsStringForKey:@"TEMPU_NUM"],
                                    [graphic attributeAsStringForKey:@"TEMPGRIDNU"],
                                    [graphic attributeAsStringForKey:@"FEEDERID"],
                                    [graphic attributeAsStringForKey:@"RATEDKVA"]];
                break;
            case FallFertilizer:
                myCalloutTitle = @"Fall Fertilizer";
                myCalloutDetails = [NSString stringWithFormat:@"Badge #:\t%@ "
                                    "\nFeeder ID:\t%@",
                                    [graphic attributeAsStringForKey:@"BADGE_NBR"],
                                    [graphic attributeAsStringForKey:@"FEEDERID"]];
                break;
            case BroadleafSpray:
                myCalloutTitle = @"Broadleaf Spray";
                break;
            default:
                myCalloutTitle = nil;
                myCalloutDetails = nil;
                break;
        }
        
        self.mapView.callout.customView = self.utilityCallout.view;
        [self.utilityCallout loadViewWithTitle:myCalloutTitle withDetails:myCalloutDetails];
        
        
    }
return YES;
}*/

- (IBAction)toggleGPS:(UISwitch *)sender {
    if (self.switchGPS.on) {
        
        self.locationManager.delegate = self;
      
        
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        [self.mapView.locationDisplay startDataSource];
        self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        
        self.locLabel.text = [self.locationManager.location description];
        [self.mapView centerAtPoint:[self.mapView.locationDisplay mapLocation] animated:YES];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    }
    else
    {
        [self.mapView.locationDisplay stopDataSource];
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.locLabel.text = @"GPS is turned off";
        
    }
}
- (IBAction)opacityChanged:(id)sender {
    self.graphicLayer.opacity = self.opacitySlider.value;
}
- (IBAction)opacityChanged2:(id)sender {
    self.graphicLayer2.opacity = self.opacitySlider2.value;
}
- (IBAction)opacityChanged3:(id)sender {
    self.graphicLayer3.opacity = self.opacitySlider3.value;
}

- (IBAction)sketchDraw:(id)sender {
    self.sketchLayer = [[AGSSketchGraphicsLayer alloc]initWithGeometry:nil];
    [self.mapView addMapLayer:self.sketchLayer];
    
    self.sPolygon = [[AGSMutablePolygon alloc]initWithSpatialReference:self.mapView.spatialReference];
    self.sketchLayer.geometry = self.sPolygon;
    self.mapView.touchDelegate = self.sketchLayer;

}
/*- (IBAction)measure:(id)sender {
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    double area = [engine areaOfGeometry:self.sPolygon];
    NSNumber *meas = [NSNumber numberWithDouble:area];
    NSString *amen = [meas stringValue];
    self.locLabel.text = amen;
    self.mapView.touchDelegate = self;
}*/


@end
