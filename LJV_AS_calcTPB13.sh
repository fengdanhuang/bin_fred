#!/bin/sh

if [ $# -lt 1 ]; then
  echo "usage: calcTPB regPerThread [sharedMem]"
  exit 1
fi

smpb=0
if [ $# -eq 2 ]; then
  smpb=$2
fi

awk -v rpt=$1 -v smpb=$smpb 'BEGIN {
#hardware constants
  // register granularity
  myAllocationSize=512;
  warpGranularity=2;
  smGranularity=512;

  // registers per multiprocessor
  limitRPM=16384;
  // threads per warp
  limitTPW=32;
  // warps per multiprocessor
  limitWPM=32;
  // shared mem per multiprocesor
  limitSMPM=16384
  // blocks per multiprocessor
  limitBPM=8;

  nMultiprocessors=30;  // GTX295

#actual calculations
  smpb=sprintf("%d", (smpb+smGranularity-1)/smGranularity)*smGranularity;
  maxTPM=0;
  tpb_maxTPM=0;
  for (tpb=16; tpb<=512; tpb+=16) {
    // warps per block
    wpb=sprintf("%d", (tpb+limitTPW-1)/limitTPW)+0;
    wpb=sprintf("%d", (wpb+warpGranularity-1)/warpGranularity)*warpGranularity;
    rpb=wpb*limitTPW*rpt;
    // register granularity enforced at block level
    rpb=sprintf("%d", (rpb+myAllocationSize-1)/myAllocationSize)*myAllocationSize;
    bpm=sprintf("%d", limitRPM/rpb)+0;
    if (bpm>limitBPM)
      bpm=limitBPM;
    if (bpm*wpb>limitWPM)
      bpm = sprintf("%d", limitWPM/wpb)+0;
    if (bpm*smpb > limitSMPM)
      bpm = sprintf("%d", limitSMPM/smpb)+0;
    tpm=bpm*tpb;
    if (tpm>maxTPM) {
      maxTPM = tpm;
      tpb_maxTPM = tpb;
    }
  }
  print tpb_maxTPM, maxTPM*nMultiprocessors;
}'
