# class to work with FIT readout unit control registers

class rdh_class:
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

    def read_rdh(self, line_list, pos):
        #print(line_list[pos][-3:-1])
        #print(line_list[pos][-5:-3])
        #dw0 = int("0x"+line_list[pos][-5:-1], base=16)
        self.dw0 = line_list[pos][-21:-1]
        self.dw1 = line_list[pos+1][-21:-1]
        self.dw2 = line_list[pos+2][-21:-1]
        self.dw3 = line_list[pos+3][-21:-1]

# - 21-20 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1
#   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0

        self.header_version = int("0x"+self.dw0[-3:-1], base=16)  # [7  -  0]

        if self.header_version == 0x4:
            self.header_size    = int("0x"+self.dw0[-5 : -3], base=16)   # [15 -  8]
            self.block_lenght   = int("0x"+self.dw0[-9 : -5], base=16)   # [31 - 16]
            self.fee_id         = int("0x"+self.dw0[-13: -9], base=16)   # [47 - 32]
            self.priority_bit   = int("0x"+self.dw0[-15:-13], base=16)   # [55 - 48]

            self.trg_orbit      = int("0x"+self.dw1[-9 : -1], base=16)   # [31 - 0]
            self.orbit          = int("0x"+self.dw1[-17: -9], base=16)   # [63 - 32]

            self.trg_bc         = int("0x"+self.dw2[-4 : -1], base=16)   # [11 - 0]
            self.bc             = int("0x"+self.dw2[-8 : -5], base=16)   # [27 - 16]
            self.trg_type       = int("0x"+self.dw2[-17: -9], base=16)   # [63 - 32]

            self.det_field      = int("0x"+self.dw3[-5 : -1], base=16)   # [15 - 0]
            self.par_bit        = int("0x"+self.dw3[-9 : -5], base=16)   # [31 - 16]
            self.stop_bit       = int("0x"+self.dw3[-11: -9], base=16)   # [39 - 32]
            self.page_counter   = int("0x"+self.dw3[-15:-11], base=16)   # [55 - 40]

        return pos+4











