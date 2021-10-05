#ifndef PMTCM_MAP
#define PMTCM_MAP

const uint32_t trhr_calib_ch0 = 0xB0;
const uint32_t ctrl_addr = 0xD8;
const uint32_t stat_addr = 0xE8;

char run_lbl[][5] =  { "IDLE", "CONT", "TRIG" };
char run_lbl_g[][20] =  { "\x1b[32mIDLE\x1b[0m", "\x1b[32mCONT\x1b[0m", "\x1b[32mTRIG\x1b[0m" };
char run_lbl_r[][20] =  { "\x1b[31mIDLE\x1b[0m", "\x1b[31mCONT\x1b[0m", "\x1b[31mTRIG\x1b[0m" };
char bcsync_lbl[][30] =  { "\x1b[31mSTRT\x1b[0m", "\x1b[32mSYNC\x1b[0m", "\x1b[31mLOST\x1b[0m" };


const int pmtcm_total = 20;
const uint32_t pmtcm_map[pmtcm_total][5] = {
	
/***/
//FEE ID   ADDR  ON RDon
{0xF000, 0x0000, 0, 1, 0},
{0xF0A0, 0x0200, 0, 1, 1645},
{0xF0A1, 0x0400, 0, 1, 1785},
{0xF0A2, 0x0600, 0, 1, 2200},
{0xF0A3, 0x0800, 0, 1, 2190},
{0xF0A4, 0x0A00, 0, 1, 1634},
{0xF0A5, 0x0C00, 0, 1, 1590},
{0xF0A6, 0x0E00, 0, 1, 2200},
{0xF0A7, 0x1000, 0, 1, 1830},
{0xF0A9, 0x1400, 0, 1, 1903},
{0xF0C0, 0x1600, 1, 1, 1700},
{0xF0C1, 0x1800, 0, 1, 1728},
{0xF0C2, 0x1A00, 0, 1, 2200},
{0xF0C3, 0x1C00, 0, 1, 1825},
{0xF0C4, 0x1E00, 0, 1, 1697},
{0xF0C5, 0x2000, 0, 1, 1772},
{0xF0C6, 0x2200, 0, 1, 1568},
{0xF0C7, 0x2400, 0, 1, 1897},
{0xF0C8, 0x2600, 0, 1, 1431},
{0xF0C9, 0x2800, 0, 1, 1776}
};
/***/


#endif // PMTCM_MAP

