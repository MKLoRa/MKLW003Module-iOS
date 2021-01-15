
typedef NS_ENUM(NSInteger, mk_lb_taskOperationID) {
    mk_lb_defaultTaskOperationID,
    
#pragma mark - Read
    mk_lb_taskReadBatteryPowerOperation,       //电池电量
    mk_lb_taskReadDeviceModelOperation,        //读取产品型号
    mk_lb_taskReadFirmwareOperation,           //读取固件版本
    mk_lb_taskReadHardwareOperation,           //读取硬件类型
    mk_lb_taskReadSoftwareOperation,           //读取软件版本
    mk_lb_taskReadManufacturerOperation,       //读取厂商信息
    mk_lb_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码特征
    mk_lb_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备系统应用信息读取
    mk_lb_taskReadDeviceInfoReportIntervalOperation,    //读取设备信息上报间隔
    mk_lb_taskReadBeaconReportIntervalOperation,        //读取iBeacon数据上报间隔
    mk_lb_taskReadBeaconReportDataTypeOperation,        //读取上报的iBeacon数据类型
    mk_lb_taskReadBeaconReportDataMaxLengthOperation,   //读取iBeacon最大上报数据长度
    mk_lb_taskReadMacAddressOperation,          //读取设备mac地址
    mk_lb_taskReadBeaconReportDataContentOperation, //读取iBeacon上报数据内容选择
    
#pragma mark - 设备LoRa参数读取
    mk_lb_taskReadLorawanRegionOperation,       //读取LoRaWAN频段
    mk_lb_taskReadLorawanModemOperation,        //读取LoRaWAN入网类型
    mk_lb_taskReadLorawanClassTypeOperation,    //读取LoRaWAN Class类型
    mk_lb_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_lb_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_lb_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_lb_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_lb_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_lb_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_lb_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_lb_taskReadLorawanMessageTypeOperation,      //读取上行数据类型
    mk_lb_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_lb_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_lb_taskReadLorawanADROperation,              //读取LoRaWAN ADR
    mk_lb_taskReadLorawanMulticastStatusOperation,  //读取LoRaWAN组播开关
    mk_lb_taskReadLorawanMulticastAddressOperation, //读取LoRaWAN组播地址
    mk_lb_taskReadLorawanMulticastAPPSKEYOperation, //读取LoRaWAN组播APPSKEY
    mk_lb_taskReadLorawanMulticastNWKSKEYOperation, //读取LoRaWAN组播NWKSKEY
    mk_lb_taskReadLorawanLinkcheckIntervalOperation,    //读取linkcheck检测间隔
    mk_lb_taskReadLorawanUplinkdwelltimeOperation,      //读取Uplinkdwelltime
    mk_lb_taskReadLorawanDutyCycleStatusOperation,      //读取dutycyle
    mk_lb_taskReadLorawanDevTimeSyncIntervalOperation,  //读取devtime指令同步间隔
    
    
    
#pragma mark - 设备系统应用信息配置
    mk_lb_taskConfigConnectNetworkOperation,            //配置设备入网/重启
    mk_lb_taskConfigDeviceInfoReportIntervalOperation,  //配置设备信息上报间隔
    mk_lb_taskConfigDeviceTimeOperation,                //同步设备时间
    
    mk_lb_taskConfigPasswordOperation,          //设置密码
    mk_lb_taskConfigBeaconReportIntervalOperation,      //配置iBeacon数据上报间隔
    mk_lb_taskConfigBeaconReportDataTypeOperation,      //配置iBeacon数据上报类型
    mk_lb_taskConfigBeaconReportDataMaxLenOperation,    //配置iBeacon数据最大上报长度
    mk_lb_taskConfigBeaconReportDataContentOperation,   //配置iBeacon上报数据内容选择
    
#pragma mark - 设备LoRa参数配置
    mk_lb_taskConfigRegionOperation,                    //配置LoRaWAN的region
    mk_lb_taskConfigModemOperation,                     //配置LoRaWAN的入网类型
    mk_lb_taskConfigClassTypeOperation,                 //配置LoRaWAN的class类型
    mk_lb_taskConfigDEVEUIOperation,                    //配置LoRaWAN的devEUI
    mk_lb_taskConfigAPPEUIOperation,                    //配置LoRaWAN的appEUI
    mk_lb_taskConfigAPPKEYOperation,                    //配置LoRaWAN的appKey
    mk_lb_taskConfigDEVADDROperation,                   //配置LoRaWAN的DevAddr
    mk_lb_taskConfigAPPSKEYOperation,                   //配置LoRaWAN的APPSKEY
    mk_lb_taskConfigNWKSKEYOperation,                   //配置LoRaWAN的NwkSKey
    mk_lb_taskConfigMessageTypeOperation,               //配置LoRaWAN的message type
    mk_lb_taskConfigCHValueOperation,                   //配置LoRaWAN的CH值
    mk_lb_taskConfigDRValueOperation,                   //配置LoRaWAN的DR值
    mk_lb_taskConfigADRStatusOperation,                 //配置LoRaWAN的ADR状态
    mk_lb_taskConfigMulticastStatusOperation,           //配置LoRaWAN的组播开关状态
    mk_lb_taskConfigMulticastAddressOperation,          //配置LoRaWAN的组播地址
    mk_lb_taskConfigMulticastAPPSKEYOperation,          //配置LoRaWAN组播的APPSKEY
    mk_lb_taskConfigMulticastNWKSKEYOperation,          //配置LoRaWAN的组播NWKSKEY
    mk_lb_taskConfigLinkCheckIntervalOperation,         //配置LoRaWAN的link check检测间隔
    mk_lb_taskConfigUpLinkeDellTimeOperation,           //配置LoRaWAN的UpLinkeDellTime
    mk_lb_taskConfigDutyCycleStatusOperation,           //配置LoRaWAN的duty cycle
    mk_lb_taskConfigTimeSyncIntervalOperation,          //配置LoRaWAN的同步指令间隔
};
