"
I'm ARDConstant, I'm a static class that contains constant values defined by the AR.Drone firmware, that are necessary for communication.
"
Class {
	#name : #ARDConstant,
	#superclass : #Object,
	#category : #ARDrone
}

{ #category : #address }
ARDConstant class >> address_DRONE [
	"Returns the drone's IP address (set by ar drone's firmware)"
	^ '192.168.1.1'
]

{ #category : #'connection states' }
ARDConstant class >> connection_CONNECTED [
	^ 1
]

{ #category : #'connection states' }
ARDConstant class >> connection_CONNECTING [
	^ 2
]

{ #category : #'connection states' }
ARDConstant class >> connection_DISCONNECTED [
	^ 3
]

{ #category : #'control modes' }
ARDConstant class >> controlMode_ACK_CONTROL_MODE [
	"Used as argument in AT*CTRL, tells the drone to Reset command mask in navdata"
	^ 5
]

{ #category : #'control modes' }
ARDConstant class >> controlMode_CFG_GET_CONTROL_MODE [
	"Used as argument in AT*CTRL, tells the drone to send active configuration file to a client through the 'control' socket UDP 5559"
	^ 4
]

{ #category : #'ctrl states' }
ARDConstant class >> ctrlStates [
	^{'DEFAULT'.'INIT'.'LANDED'.'FLYING'.'HOVERING'.'TEST'.'FLYING_1'.'TAKING_OFF'.'LOOPING'.'LANDING'}
]

{ #category : #'detection types' }
ARDConstant class >> detectType_MULTIPLE_DETECTION_MODE [
	
	^ 10
]

{ #category : #'detection types' }
ARDConstant class >> detectType_NONE [

	^ 3
]

{ #category : #'detection types' }
ARDConstant class >> detectType_ORIENTED_COCARDE_BW [

	^ 12
]

{ #category : #'detection types' }
ARDConstant class >> detectType_VISION_V2 [

	^ 13
]

{ #category : #'detected tag' }
ARDConstant class >> detectedTag_OR_IN_CV [
	"Tag Oriented roundel detected in vertical camera"
	^ 2
]

{ #category : #'detected tag' }
ARDConstant class >> detectedTag_SH_IN_CH [
	"Tag Shell detected in horizontal camera"
	^ 1
]

{ #category : #'detection colors' }
ARDConstant class >> detectionColor_ORANGE_BLUE [
	^ 3
]

{ #category : #'detection colors' }
ARDConstant class >> detectionColor_ORANGE_GREEN [
	^ 1
]

{ #category : #'detection colors' }
ARDConstant class >> detectionColor_ORANGE_YELLOW [
	^ 2
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_DOUBLE_PHI_THETA_MIXED [
	^ 15
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_FLIP_AHEAD [
	^ 16
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_FLIP_BEHIND [
	^ 17
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_FLIP_LEFT [
	^ 18
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_FLIP_RIGHT [
	^ 19
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_PHI_30_DEG [
	^ 1
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_PHI_DANCE [
	^ 10
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_PHI_M30_DEG [
	^ 0
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_PHI_THETA_MIXED [
	^ 14
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_THETA_20DEG_YAW_200DEG [
	^ 4
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_THETA_20DEG_YAW_M200DEG [
	^ 5
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_THETA_30_DEG [
	^ 3
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_THETA_DANCE [
	^ 11
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_THETA_M30_DEG [
	^ 2
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_TURNAROUND [
	^ 6
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_TURNAROUND_GODOWN [
	^ 7
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_VZ_DANCE [
	^ 12
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_WAVE [
	^ 13
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_YAW_DANCE [
	^ 9
]

{ #category : #'flight animations' }
ARDConstant class >> flightAnimation_YAW_SHAKE [
	^ 8
]

{ #category : #'flying modes' }
ARDConstant class >> flyingMode_FREE_FLIGHT [
	"Flying mode for using in ARCommand >> configFlyingMode"
	^ 0 
]

{ #category : #'flying modes' }
ARDConstant class >> flyingMode_HOVER_ON_TOP_OF_ORIENTED_ROUNDEL [
	"Flying mode for using in ARCommand >> configFlyingMode"
	^ 1 << 1
]

{ #category : #'flying modes' }
ARDConstant class >> flyingMode_HOVER_ON_TOP_OF_ROUNDEL [
	"Flying mode for using in ARCommand >> configFlyingMode"
	^ 1 << 0
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLANK [
	
	^ 10
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLINK_GREEN [
	
	^ 1
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLINK_GREEN_RED [
	
	^ 0
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLINK_ORANGE [
	
	^ 3
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLINK_RED [
	
	^ 2
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_BLINK_STANDARD [
	
	^ 20
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_DOUBLE_MISSILE [
	
	^ 13
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_FIRE [
	
	^ 5
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_FRONT_LEFT_GREEN_OTHERS_RED [
	
	^ 14
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_FRONT_RIGHT_GREEN_OTHERS_RED [
	
	^ 15
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_GREEN [
	
	^ 8
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_LEFT_GREEN_RIGHT_RED [
	
	^ 18
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_LEFT_MISSILE [
	
	^ 12
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_LEFT_RED_RIGHT_GREEN [
	
	^ 19
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_READ_LEFT_GREEN_OTHERS_RED [
	
	^ 17
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_READ_RIGHT_GREEN_OTHERS_RED [
	
	^ 16
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_RED [
	
	^ 7
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_RED_SNAKE [
	
	^ 9
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_RIGHT_MISSILE [
	
	^ 11
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_SNAKE_GREEN_RED [
	
	^ 4
]

{ #category : #'led animations' }
ARDConstant class >> ledAnimation_STANDARD [
	
	^ 6
]

{ #category : #'navdata options' }
ARDConstant class >> option_DEMO [

	^ 0
]

{ #category : #'navdata options' }
ARDConstant class >> option_VISION_DETECT [

	^ 16
]

{ #category : #ports }
ARDConstant class >> port_AUTH [
	"Returns the port used for authenticating to the drone (set by ar drone's firmware)"
	^ 5552
]

{ #category : #ports }
ARDConstant class >> port_COMMAND [ 
	"Returns the port used by the ar drone to receive AT commands (set by ar drone's firmware)"
	^ 5556
]

{ #category : #ports }
ARDConstant class >> port_CONFIGURATION [
	"Returns the port used by the ar drone to send the configuration file (set by ar drone's firmware)"
	^ 5559
]

{ #category : #ports }
ARDConstant class >> port_NAVDATA [
	"Returns the port used by the ar drone to send navdata (set by ar drone's firmware)"
	^ 5554
]

{ #category : #'tag type' }
ARDConstant class >> tagType_BLACK_ROUNDEL [
	
	^ 1<<7
]

{ #category : #'tag type' }
ARDConstant class >> tagType_NONE [
	
	^ 0
]

{ #category : #'tag type' }
ARDConstant class >> tagType_SHELL_TAG_V2 [
	
	^ 1<<5
]

{ #category : #'video channels' }
ARDConstant class >> videoChannel_ZAP_CHANNEL_HORI [
	^ 0
]

{ #category : #'video channels' }
ARDConstant class >> videoChannel_ZAP_CHANNEL_VERT [
	^ 1
]

{ #category : #'video codecs' }
ARDConstant class >> videoCodec_H264_360P_CODEC [
	^ 129
]

{ #category : #'video codecs' }
ARDConstant class >> videoCodec_H264_720P_CODEC [
	^ 131
]
