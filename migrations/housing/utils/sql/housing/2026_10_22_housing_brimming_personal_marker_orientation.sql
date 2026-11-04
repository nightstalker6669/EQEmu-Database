-- 101 Brimming Way: original OBP_LOTSQUARE half-turn with pivot compensation.
-- Preserve world XY envelope (float32 residual below 0.00004 units).
-- Legal regions, ownership, prices and placed-item transforms remain unchanged.
-- Only the known original content pose is eligible; repeat application is a no-op.
UPDATE doors SET pos_x=pos_x-1.4228439331054688,pos_y=pos_y+0.8645858764648438,heading=128
WHERE zone='neighborhood' AND version=0 AND doorid=19 AND name='OBP_LOTSQUARE'
 AND size=100 AND opentype=160 AND ABS(pos_x-1249.1400146484375)<0.001
 AND ABS(pos_y+2017.31005859375)<0.001 AND ABS(pos_z+29.74799919128418)<0.001 AND heading=384;
