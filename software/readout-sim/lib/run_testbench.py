# class to work with FIT readout unit control registers

import lib.control_reg as cntrl_reg
import lib.RDH_data as rdh_data
import lib.pylog as pylog
import lib.readout_constants as rdconst

log = pylog.log


class run_testbench_class:
    def __init__(self, simulation, run_num=0):

        # data set
        self.simulation = simulation
        self.run_num = run_num
        self.run_data = self.simulation.runs_list[self.run_num]

        # run data
        self.rdh_data_list = []

        # testbench results
        self.errors_messages = []




        # test procedure
        log.info("")
        log.info("Reading run data ... ")

        res = self.read_run_data_check()

        if res == 1:
            log.info("Run rdh data successfully read ... ")
        else:
            log.info(" run rdh data read with %i errors:" % (len(self.errors_messages)))
            for message in self.errors_messages: log.info("%s"%(message))

        log.info("Read %i events"%(len(self.rdh_data_list)))
        self.errors_messages = []


        log.info("")
        log.info("Checking run ... ")
        self.check_run_data()

        log.info("")
        log.info("Run tested with %i errors" % (len(self.errors_messages)))
        for message in self.errors_messages: log.info("%s"%(message))




    # def print_info(self):
    #     log.info("############################# SIMULATION RUN  INFO ####################################")
    #     log.info("\ninputs files:")
    #     log.info("data position run start: %d"%(self.pos_run_start))
    #     log.info("data position run stop: %d"%(self.pos_run_stop))
    #     log.info("data position post run idle: %d"%(self.pos_run_postidl))

    # read continuously rdh data
    def read_run_data(self):
        self.rdh_data_list = []
        dyn_event = rdh_data.rdh_data_class()
        pos = self.run_data.pos_gbt_start
        while pos < self.run_data.pos_gbt_postidl:
            pos = dyn_event.read_data(self.simulation.gbt_data_list, pos)
            dyn_event.print_raw()
            dyn_event.print_struct()
            self.rdh_data_list.append(dyn_event)

    # read rdh data with errors checking
    def read_run_data_check(self):
        self.rdh_data_list = []

        dyn_pos = self.run_data.pos_gbt_start

        # EVENT loop --------------------------------------------
        while dyn_pos < self.run_data.pos_gbt_postidl:
            dyn_rdh_header = rdh_data.rdh_header_class()
            dyn_rdh_trailer = rdh_data.rdh_trailer_class()
            dyn_rdh_data = rdh_data.rdh_data_class()


            # HEADER --------------------------------------------
            new_dyn_pos = dyn_rdh_header.read_data(self.simulation.gbt_data_list, dyn_pos)

            if dyn_rdh_header.fee_id != self.run_data.run_control.RDH_feeid:
                self.errors_messages.append("Wrong FEE ID: %x, expected: %x"%(dyn_rdh_header.fee_id, self.run_data.run_control.RDH_feeid))
                return -1

            if dyn_rdh_header.par_bit != self.run_data.run_control.RDH_par:
                self.errors_messages.append("Wrong PAR ID: %x, expected: %x"%(dyn_rdh_header.par_bit, self.run_data.run_control.RDH_par))
                return -1

            if dyn_rdh_header.det_field != self.run_data.run_control.RDH_detf:
                self.errors_messages.append("Wrong DEF_F ID: %x, expected: %x"%(dyn_rdh_header.det_field, self.run_data.run_control.RDH_detf))
                return -1

            n_dw_in_packet = dyn_rdh_header.block_lenght / 10
            if n_dw_in_packet > 512-4:
                self.errors_messages.append("Block length is too high: %x, expected: %x"%(n_dw_in_packet, 512-4))
                return -1

            dyn_rdh_data.rdh_header = dyn_rdh_header
            dyn_pos = new_dyn_pos



            # DATA --------------------------------------------
            packet_start = dyn_pos
            dyn_rdh_data.event_list = []
            while dyn_pos < packet_start + n_dw_in_packet:
                dyn_rdh_detdata = rdh_data.detector_event_class()
                new_dyn_pos = dyn_rdh_detdata.read_data(self.simulation.gbt_data_list, dyn_pos)

                if dyn_rdh_detdata.magic != 0xF:
                    self.errors_messages.append("Wrong detector header magic: %x, expected: %x" % (dyn_rdh_detdata.magic, 0xF))
                    return -1

                dyn_rdh_data.event_list.append(dyn_rdh_detdata)
                # dyn_rdh_detdata.print_struct()
                dyn_pos = new_dyn_pos



            # TRAILER --------------------------------------------
            new_dyn_pos = dyn_rdh_trailer.read_data(self.simulation.gbt_data_list, dyn_pos)

            if dyn_rdh_trailer.magic != 0xFFFF:
                self.errors_messages.append("Wrong trailer magic : %x, expected: %x" % (dyn_rdh_detdata.magic, 0xFFFF))
                return -1

            dyn_rdh_data.rdh_trailer = dyn_rdh_trailer
            dyn_pos = new_dyn_pos

            # if len(dyn_rdh_data.event_list) > 2:
            #     dyn_rdh_data.event_list[0].print_struct()
            #     dyn_rdh_data.event_list[1].print_struct()
            # dyn_rdh_data.print_struct()
            self.rdh_data_list.append(dyn_rdh_data)

        return 1


    def check_run_data(self):


        # start and stop triggers --------------------------------------------------------------------------------------
        first_RDH_trg = self.rdh_data_list[0].rdh_header.trg_type
        last_RDH_trg = self.rdh_data_list[-1].rdh_header.trg_type

        if self.run_data.run_type == cntrl_reg.readout_cmd.continious:
            str_trg_val = rdconst.TRG_const_SOC
            stp_trg_val = rdconst.TRG_const_EOC
        else:
            str_trg_val = rdconst.TRG_const_SOT
            stp_trg_val = rdconst.TRG_const_EOT

        is_str_ok = first_RDH_trg & str_trg_val > 0
        is_stp_ok = last_RDH_trg & stp_trg_val > 0


        if not is_str_ok: self.errors_messages.append("First RDH don't contains SOx : %x, expected: %x" % (first_RDH_trg, str_trg_val))
        if not is_stp_ok: self.errors_messages.append("Last RDH don't contains EOx : %x, expected: %x" % (last_RDH_trg, stp_trg_val))

        if is_stp_ok and is_str_ok:
            log.info((pylog.c_OKGREEN+"First run trigger: %x [%s]"+pylog.c_ENDC) % (first_RDH_trg, is_str_ok))
            log.info((pylog.c_OKGREEN+"Last run trigger: %x [%s]"+pylog.c_ENDC) % (last_RDH_trg, is_stp_ok))
        else:
            log.info((pylog.c_FAIL+"First run trigger: %x [%s]"+pylog.c_ENDC) % (first_RDH_trg, is_str_ok))
            log.info((pylog.c_FAIL+"Last run trigger: %x [%s]"+pylog.c_ENDC) % (last_RDH_trg, is_stp_ok))


        # page counter -------------------------------------------------------------------------------------------------
        for ievent in range(1, len(self.rdh_data_list)):
            pc_curr = self.rdh_data_list[ievent].rdh_header.page_counter
            pc_prev = self.rdh_data_list[ievent-1].rdh_header.page_counter
            orbit_curr = self.rdh_data_list[ievent].rdh_header.orbit
            orbit_prev = self.rdh_data_list[ievent-1].rdh_header.orbit

            if orbit_curr == orbit_prev+1:
                if pc_curr != 0:
                    self.errors_messages.append("Page counter is not 0x0 with new orbit in event %i;" % (ievent))
                    return -1
            elif orbit_curr == orbit_prev:
                if pc_curr != pc_prev+1:
                    self.errors_messages.append("RDH page counter error in event %i : PC: %i, prev PC: %i" % (ievent, pc_curr, pc_prev))
                    return -1
            else:
                self.errors_messages.append("RDH orbit missed in event %i; orbit curr %x, orbit prev %x" % (ievent, orbit_curr, orbit_prev))
                return -1


        log.info(pylog.c_OKGREEN+"RDH page counters are correct ... "+pylog.c_ENDC)


        # stop bit -----------------------------------------------------------------------------------------------------
        for ievent in range(0, len(self.rdh_data_list)-1):
            orbit_curr = self.rdh_data_list[ievent].rdh_header.orbit
            orbit_next = self.rdh_data_list[ievent+1].rdh_header.orbit

            if orbit_curr+1 == orbit_next:
                if self.rdh_data_list[ievent].rdh_header.stop_bit != 0x1:
                    self.errors_messages.append("Stop bit is not 0x1 in event %i; curr orbit %x, next orbit %x" % (ievent, orbit_curr, orbit_next))
                    return -1
            else:
                if self.rdh_data_list[ievent].rdh_header.stop_bit != 0x0:
                    self.errors_messages.append("Stop bit is not 0x0 in event %i; curr orbit %x, next orbit %x" % (ievent, orbit_curr, orbit_next))
                    return -1

        log.info(pylog.c_OKGREEN+"RDH stop bits are correct ... "+pylog.c_ENDC)


        # orbit in rdh dara --------------------------------------------------------------------------------------------
        for ievent in range(0, len(self.rdh_data_list)):
            orbit_curr = self.rdh_data_list[ievent].rdh_header.orbit

            for idata in self.rdh_data_list[ievent].event_list:
                if idata.orbit != orbit_curr:
                    self.errors_messages.append("Wrong orbit in detector event %i; curr orbit %x, event orbit %x" % (ievent, orbit_curr, idata.orbit))
                    return -1

        log.info(pylog.c_OKGREEN+"Detectors orbits are correct ... "+pylog.c_ENDC)



        # data integrity -----------------------------------------------------------------------------------------------



        # # data counter -----------------------------------------------------------------------------------------------
        # event_iter = 0
        # for ievent in range(0, len(self.rdh_data_list)-1):
        #
        #     for idata in self.rdh_data_list[ievent].event_list:
        #
        #         for ichdata in idata.
        #         if idata.orbit != orbit_curr:
        #             self.errors_messages.append("Wrong orbit in detector event %i; curr orbit %x, умуте orbit %x" % (ievent, orbit_curr, idata.orbit))
        #             return -1
        #
        # log.info(pylog.c_OKGREEN+"Detectors orbits are correct ... "+pylog.c_ENDC)






        #data bc positions
        return 1



