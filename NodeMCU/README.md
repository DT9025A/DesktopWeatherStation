# DesktopWeatherStation/NodeMCU
本目录下主要放置与NodeMCU有关的文件

LUA脚本 :
- dht11.lua : 与DHT11有关的操作
- extend.lua : 一些自定义的扩展方法
- httpRequest.lua : 实现HTTP请求
- ntp.lua : NTP时间服务
- timeStamp.lua : Unix 时间戳转换

其他文件 :
- nocemcu-firmware.bin 这里使用的NodeMCU固件 (float版本)

NodeMCU引脚接线示意

		---------------------
		|	-----	-----	|
		|	|	|	|		|
		|	|	-----		|
		|	|				|
		|					|
		|					|
	RST |RST			 TXD| RXD
		|ADC			 RXD| TXD
	EN  |EN 			   5|
	DHT |16 			   4|
	SCLK|14 			   0| IRQ_STM
	MISO|12 			   2| IRQ_XPT
	MOSI|13				  15| CS_XPT
	VCC |VCC			 GND| GND
		---------------------
		
	RST:		复位
	EN:			更新固件时拉低
	DHT:		接DHT11
	SCLK:		SPI 时钟线
	MISO:		SPI MISO线
	MOSI:		SPI MOSI线
	VCC:		VCC
	GND:		GND
	CS_XPT:		XPT2046片选
	IRQ_XPT:	接收XPT2046的中断信号
	IRQ_STM:	给STM32发中断信号
