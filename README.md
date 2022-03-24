# ArDronePharo : Pharo API for controlling the AR.Drone 2.0

## Description
The main purpose of this API is to provide simple functions to communicate the Parrot's AR.Drone 2.0. It implements methods for sending control and configuration commands to the drone, and also provides a simple way to receive and interpret the navigation data published by the drone. The API's main class is called ARDrone. It contains the whole public API necessary for communicating with the drone.

## Public messages summary
The next are the public messages included within this API, they are categorized by role:

### ARDrone - instance

- ```uniqueInstance```
  - As the ARDrone class implements singleton pattern, this message returns the only instance available of this class. It also starts all processes related to it.
- ```newUniqueInstance```
  - It forces the initialization of the uniqueInstance class variable. All the rest is the same as uniqueInstance


### ARDrone - connection
- ```startSession```
  - Establishes connection with the AR.Drone and starts all processes related to the arDrone instance. If the connection can't be established, it returns false. The API is able to reconnect every time the connection is lost, so the user must use this message only once at the beginning of the session.
- ```terminateSession```
  - Interrupts the connection with the drone and finishes all processes related to the arDrone instance. It is the user's responsibility to call this function when the instance is not longer needed, otherwise, background processes will keep running.


### ARDrone - movement control

- ```takeOff```
  - Takes off the drone
- ```land```
  - Lands the drone

- ```elevate: aVerticalSpeed```
  - Sets the drone's vertical speed. The set value persists until it is changed by the user
  - *arguments:*
    - **aVerticalSpeed** float in range [-1,1], represents a percentage of the drone's maximum vertical speed, (+) ascends, (-) descends.
- ```roll: aLeftRightTilt```
  - Sets the drone's lateral tilt. The set value persists until it is changed by the user
  - *arguments:*
    - **aLeftRightTilt** float in range [-1,1], represents a percentage of the drone's maximum lateral tilt, (+) for right inclination, (-) for left inclination
- ```pitch: aFrontBackTilt```
  - Sets the drone's frontal tilt. The set value persists until it is changed by the user
  - *arguments:*
    - **aLeftRightTilt** float in range [-1,1], represents a percentage of the drone's maximum frontal tilt, (-) for front inclination (nose descends), (+) for back inclination (nose rises)
- ```yaw: anAngularSpeed```
  - Sets the drone's angular speed with respect to the yaw angle. The set value persists until it is changed by the user
  - *arguments:*
    - **anAngularSpeed** float in range [-1,1], represents a percentage of the drone's maximum angular speed, (+) for front spinning to the right, (+) for spinning to the left (nose rises)
- ```moveByLeftRightTilt: aLeftRightTilt frontBackTilt: aFrontBackTilt angularSpeed: anAngularSpeed verticalSpeed: aVerticalSpeed```
  - Sets all drone's motion variables at once. The set values persist until they are changed by the user
  - *arguments:* must respect the same rules as the other motion commands
    - **aLeftRightTilt**
    - **aFrontBackTilt**
    - **anAngularSpeed**
    - **aVerticalSpeed**

### ARDrone - LEDs control

- ```animateLEDs: aLEDAnimationNumber frequency: aFrequency duration: aDuration```
  - Animates the drone's LED
  - *arguments:*
    - **aLEDAnimationNumber** integer (from a defined enumeration), it determines the animation colors and sequence.
    - **aFrequency** in Hertz, it defines the frequency of the animation cycle.
    - **aDuration** in seconds, sets the time the animation will be played.

### ARDrone - Navdata reception

- ```receiveNavdataAndDo: aBlock```
  - Replaces the current navdata receiver process by a new process that incorporates the excecution of aBlock once for every navigation datagram received.
  - *arguments:*
    - **aBlock** a Smalltalk block, must receive the datagram as parameter.

## Usage indications and Example
The following example presents the way this API must be used.

```
01 | arDrone |
02 arDrone := ARDrone uniqueInstance.
```

First we get an ARDrone instance. Since this class implements the singleton pattern, this must be done using the message uniqueInstance

```
03 arDrone startSession. 
04 arDrone setReceiverProcessCallback: [ :datagram | Transcript show: datagram asString ].
```

Line 03 connects with the drone. Line 04 set a behavior related to getting navdatas. In this example, each datagram is showed in the Transcript.

```
05 arDrone 
06     animateLEDs: ARDCommand ledAnimation_FIRE
07     frequency: 2.5
08     duration: 5.
```

Lines 05 to 08 show how to send a LED animation commands. Notice that the animation parameter, corresponds to an enumeration defined in ARDCommand class side

```
09 arDrone takeOff.
10 (Delay forSeconds: 5) wait.
11 arDrone pitch -0.5.
12 (Delay forSeconds: 1) wait.
13 arDrone pitch 0.
14 (Delay forSeconds: 1) wait.
15 arDrone land.
16 (Delay forSeconds: 5) wait.
```

Lines 09 to 16 manipulate drone's movements. This example takes off the drone, then makes it go forward (by setting its pitch) for 1 second, then stop, by stabilizing its pitch; then makes it go backwards for another second, and finally it lands the drone.

```
17 arDrone terminateSession.
```

This final call is very important and must be done to prevent associated processes from keep running on background
