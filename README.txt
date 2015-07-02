Environment:
	Signal Hound BB60C Spectrum Analyzer/RF Recorder
	3.0 USB on 64-bit Window 7 computer
	86 BB API Version 3.0.4 (included with Spike 64 bit 3.0.8 download)
	32-bit Matalab
Equipment: (See equipment_schematic.PNG)
	Com Power Combilog Antenna AC-220 25MHz - 2GHz
	FLT201A/N FM Notch Filter
	DC Power Block
	
Configuration Settings for Sweeping Mode:
		traces	 		Min & Max
		power scaling 		Log Scale
		Center			510 MHz
		Span 			980 MHz
		reference 		-30dBm
		attenuation 		auto
		rbw			10kHz
		vbw			10kHz
		sweep time		100msec
		
********FOLLOWING NOT ENOUGH EXPERIENCE TO JUDGE IF CORRECT*********************
		rbwType 		Non-native - needs to be tested in Native
		rejection		No spur rejection
		window			flat top (b/c Non-native chosen)
		vbw units		Power - need to be tested in Log
********************************************************************************		
Data Description:
	Frequencies Span from 20 MHz - 1GHz with 401408 frequency bins,
	Accordingly, every power measurement or calculation has same dimension.
	