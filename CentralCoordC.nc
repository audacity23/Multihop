#include <Timer.h>
#include "CentralCoord.h"
#include "RCbroadcast.h"
#include "printf.h"
 
 module CentralCoordC {
   uses interface Boot;
   uses interface Leds;
   uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Receive;
}
 
 implementation {

 message_t pkt;
 uint16_t temp;
 uint8_t counter;
 uint16_t data;

   event void Boot.booted() {
	call AMControl.start();
	}

    event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
        call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
   	}
	else {
	call AMControl.start();
	}
}

	event void AMControl.stopDone(error_t err) {
	}

    	event void Timer0.fired() {
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(CentralCoordMsg)) {
			CentralCoordMsg* newpkt = (CentralCoordMsg*)payload;	
			//temp = newpkt->data;
			//temp++;
			//printf("Done");
			temp = newpkt->nodeid;

			if (temp == 1 || temp==2 || temp==3 || temp==4 || temp==5 || temp==6){			//only if it belongs to a Room coordi	
				counter = newpkt->counter;
				data = newpkt->data;			//data kya receive hoga?		
				call Leds.set(newpkt->counter);
				printf("node number : %u \t",nodeid);
				}
			}
		return msg;
		}
 }
 
