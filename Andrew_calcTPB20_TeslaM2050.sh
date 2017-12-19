#!/bin/sh

if [ $# -lt 1 ]; then
  echo "usage: calcTPB regPerThread [sharedMem]"
  exit 1
fi

verbose=0
if [ $1 = "-v" ]; then
  verbose=1
  shift
fi

smpb=0
if [ $# -eq 2 ]; then
  smpb=$2
fi

awk -v rpt=$1 -v smpb=$smpb -v verbose=$verbose 'BEGIN {
#hardware constants
  // register granularity
  myAllocationSize=64;
  warpGranularity=1;
  smGranularity=128;

  // registers per multiprocessor
  limitRPM=32768;
  // threads per warp
  limitTPW=32;
  // warps per multiprocessor
  limitWPM=48;
  // shared mem per multiprocesor
  limitSMPM=49152
  // blocks per multiprocessor
  limitBPM=8;

  nMultiprocessors=14;   // TeslaM2050

#actual calculations
  smpb=sprintf("%d", (smpb+smGranularity-1)/smGranularity)*smGranularity;
  maxTPM=0;
  tpb_maxTPM=0;
  for (tpb=16; tpb<=512; tpb+=16) {
    // warps per block
    wpb=sprintf("%d", (tpb+limitTPW-1)/limitTPW)+0;
    wpb=sprintf("%d", (wpb+warpGranularity-1)/warpGranularity)*warpGranularity;
    // registers per warp
    rpw=limitTPW*rpt;
    // register granularity enforced at warp level
    rpw=sprintf("%d", (rpw+myAllocationSize-1)/myAllocationSize)*myAllocationSize;
    // registers per block
    rpb=wpb*rpw;
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
    if (verbose) print tpb, tpm;
  }
  print tpb_maxTPM, maxTPM*nMultiprocessors;
}'
