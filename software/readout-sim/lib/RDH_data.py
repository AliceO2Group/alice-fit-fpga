# class to work with FIT readout unit control registers

################################################################
################################################################
class detector_event_class:
    def __init__(self):
        self.dw_list = ["00000000000000000000"]

        self.magic = 0
        self.n_words = 0
        self.is_tcm = 0
        self.phase_err = 0
        self.phase = 0
        self.bc = 0
        self.orbit = 0
        self.ch_pmdata = [[0,""]]



    def print_struct(self):
        print("=== detector data ===")
        print("    magic:", hex(self.magic))
        print("    is_tcm:", hex(self.is_tcm))
        print("    n_words:", hex(self.n_words))
        print("    phase_err:", hex(self.phase_err))
        print("    phase:", hex(self.phase))
        print("    bc:", hex(self.bc))
        print("    orbit:", hex(self.orbit))
        print("    ch_pmdata:", self.ch_pmdata)

    def print_raw(self):
        print(self.dw_list)

    def read_data(self, line_list, pos):
        self.dw_list = [line_list[pos][-21:-1]]

# - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
#   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
        self.magic     = int(self.dw_list[0][-20 : -19], base=16)  # [79 - 76]
        self.n_words   = int(self.dw_list[0][-19 : -18], base=16)  # [75 - 72]
        self.is_tcm    = int(self.dw_list[0][-13 : -12], base=16)  # [75 - 72]
        pherr_         = int(self.dw_list[0][-12: -11], base=16)   # [47 - 44]
        self.phase = pherr_&0x7
        self.phase_err = (pherr_&0x8 > 0)
        self.orbit     = int(self.dw_list[0][-10: -3], base=16)    # [39 - 12]
        self.bc        = int(self.dw_list[0][-3 :  ], base=16)     # [11 - 0]

        self.ch_pmdata = []
        for iword in range(1, self.n_words+1):
            self.dw_list.append(line_list[pos + iword][-21:-1])
            if self.is_tcm == 0:
                ch1_no =    int(self.dw_list[iword][-20: -19], base=16)
                ch1_data =  int(self.dw_list[iword][-19: -10], base=16)
                ch2_no =    int(self.dw_list[iword][-10:  -9], base=16)
                ch2_data =  int(self.dw_list[iword][-9 :    ], base=16)

                if ch1_no > 0: self.ch_pmdata.append([ch1_no, ch1_data])
                if ch2_no > 0: self.ch_pmdata.append([ch2_no, ch2_data])
            else:
                ch_data = int(self.dw_list[iword][-19:  ], base=16)
                self.ch_pmdata.append([iword, ch_data])


        return pos+1+self.n_words
################################################################
################################################################
class rdh_header_class:
    def __init__(self):
        self.dw0 = "00000000000000000000"
        self.dw1 = "00000000000000000000"
        self.dw2 = "00000000000000000000"
        self.dw3 = "00000000000000000000"

        self.header_version = 0
        self.header_size = 0
        self.block_lenght = 0
        self.fee_id = 0
        self.priority_bit = 0
        self.bc = 0
        self.orbit = 0
        self.trg_type = 0
        self.trg_orbit = 0
        self.trg_bc = 0
        self.page_counter = 0
        self.stop_bit = 0
        self.det_field = 0
        self.par_bit = 0



    def print_struct(self):
        print("======== RDH ========")
        print("    header_version:", hex(self.header_version))
        print("    header_size:", hex(self.header_size))
        print("    block_lenght:", hex(self.block_lenght))
        print("    fee_id:", hex(self.fee_id))
        print("    priority_bit:", hex(self.priority_bit))
        print("    bc:", hex(self.bc))
        print("    orbit:", hex(self.orbit))
        print("    trg_type:", hex(self.trg_type))
        print("    trg_orbit:", hex(self.trg_orbit))
        print("    trg_bc:", hex(self.trg_bc))
        print("    page_counter:", hex(self.page_counter))
        print("    stop_bit:", hex(self.stop_bit))
        print("    det_field:", hex(self.det_field))
        print("    par_bit:", hex(self.par_bit))

    def print_raw(self):
        print(self.dw0)
        print(self.dw1)
        print(self.dw2)
        print(self.dw3)

    def read_data(self, line_list, pos):
        #print(line_list[pos][-3:-1])
        #print( int("0x"+self.dw0[-3:-1], base=16) )
        #print(line_list[pos][-5:-3])
        #dw0 = int("0x"+line_list[pos][-5:-1], base=16)
        self.dw0 = line_list[pos][-21:-1]
        self.dw1 = line_list[pos+1][-21:-1]
        self.dw2 = line_list[pos+2][-21:-1]
        self.dw3 = line_list[pos+3][-21:-1]


        self.header_version = int(self.dw0[-2:  ], base=16)  # [7  -  0]

        if self.header_version == 0x4:
# - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
#   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
            self.header_size    = int(self.dw0[-4 : -2], base=16)   # [15 -  8]
            self.block_lenght   = int(self.dw0[-8 : -4], base=16)   # [31 - 16]
            self.fee_id         = int(self.dw0[-12: -8], base=16)   # [47 - 32]
            self.priority_bit   = int(self.dw0[-14:-12], base=16)   # [55 - 48]

            self.trg_orbit      = int(self.dw1[-8 :   ], base=16)   # [31 - 0]
            self.orbit          = int(self.dw1[-16: -8], base=16)   # [63 - 32]

            self.trg_bc         = int(self.dw2[-3 :   ], base=16)   # [11 - 0]
            self.bc             = int(self.dw2[-7 : -4], base=16)   # [27 - 16]
            self.trg_type       = int(self.dw2[-16: -8], base=16)   # [63 - 32]

            self.det_field      = int(self.dw3[-4 :   ], base=16)   # [15 - 0]
            self.par_bit        = int(self.dw3[-8 : -4], base=16)   # [31 - 16]
            self.stop_bit       = int(self.dw3[-10: -8], base=16)   # [39 - 32]
            self.page_counter   = int(self.dw3[-14:-10], base=16)   # [55 - 40]


        if self.header_version == 0x6:
            # - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
            #   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
            self.header_size = int(self.dw0[-4: -2], base=16)
            self.fee_id = int(self.dw0[-8: -4], base=16)
            self.priority_bit = int(self.dw0[-10:-8], base=16)
            self.block_lenght = int(self.dw0[-20: -16], base=16)

            self.bc = int(self.dw1[-3:], base=16)
            self.orbit = int(self.dw1[-16: -8], base=16)

            self.trg_type = int(self.dw2[-8:], base=16)
            self.page_counter = int(self.dw2[-12:-8], base=16)
            self.stop_bit = int(self.dw2[-14: -12], base=16)

            self.det_field = int(self.dw3[-8:], base=16)
            self.par_bit = int(self.dw3[-12: -8], base=16)

            # not used in RDH v6
            self.trg_orbit = 0
            self.trg_bc = 0


        return pos+4
################################################################
################################################################
class rdh_trailer_class:
    def __init__(self):
        self.dw = "00000000000000000000"
        self.magic = 0

    def print_raw(self):
        print(self.dw)

    def print_struct(self):
        print("======== trailer ========")
        print("magic:", hex(self.magic))

    def read_data(self, line_list, pos):
        self.dw = line_list[pos][-21:-1]
        self.magic = int(self.dw[-20:-16], base=16)
        return pos+1
################################################################
################################################################
class rdh_data_class:
    def __init__(self):
        self.rdh_header = rdh_header_class()
        self.event_list = []
        self.rdh_trailer = rdh_trailer_class()

    def print_raw(self):
        self.rdh_header.print_raw()
        for event in self.event_list: event.print_raw()
        self.rdh_trailer.print_raw()


    def print_struct(self):
        print("===== RDH DATA =====")
        self.rdh_header.print_struct()
        for event in self.event_list: event.print_struct()
        self.rdh_trailer.print_struct()

    def read_data(self, line_list, pos):
        dyn_pos = self.rdh_header.read_data(line_list, pos)
        n_dw_in_packet = self.rdh_header.block_lenght / 16

        packet_start = dyn_pos
        while dyn_pos < packet_start + n_dw_in_packet:
            dyn_event = detector_event_class()
            dyn_pos = dyn_event.read_data(line_list, dyn_pos)
            self.event_list.append(dyn_event)

        dyn_pos = self.rdh_trailer.read_data(line_list,dyn_pos)

        return dyn_pos
################################################################
################################################################




