#ifndef CENTRALCOORD_H
 #define CENTRALCOORD_H
 
 enum {
   AM_CENTRALCOORD = 6,
   TIMER_PERIOD_MILLI = 10
 };
 
typedef nx_struct BroadcastbyCC{
 nx_uint16_t CCid;
 nx_uint16_t duplicateCCid;
 nx_uint16_t x;
 nx_uint16_t y;
} BroadcastbyCC;

typedef nx_struct CentralCoordMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t data;
} CentralCoordMsg;


 #endif
 
