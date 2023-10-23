#ifndef IPBUS_CONNECTION_H
#define IPBUS_CONNECTION_H

#include <string.h>
#include "udp_socket.h"
#include "ipbus_format.h"

#define is_debug_print 0
#define is_action_print 0

class ipbus_connection {
    
public:
    ipbus_connection();
    ~ipbus_connection();
    
    void set_board_port(const unsigned short int port) {
	board_port = port;
    }
    void set_board_ip(const char *ip_addr) {
	strcpy(board_ip, ip_addr);
    }
    
    void set_local_port(const unsigned short int port) {
	local_port = port;
    }
    void set_local_ip(const char *ip_addr) {
	strcpy(local_ip, ip_addr);
    }
    
    int connect_to_board();
    int request_status();
    
    int read_registers(uint32_t *data, uint8_t &nwords, uint32_t addr, bool is_noinc = false);
    uint32_t read_single(uint32_t addr);
    int write_registers(uint32_t *data, uint8_t &nwords, uint32_t addr);
    void write_single(uint32_t data, uint32_t addr);
    
    void printout_buffer(int nwords) {
	for (int word = 0; word < (nwords > bufload ? bufload : nwords); word++)
	    printf("%i: %08x\n", word, buffer[word]);
    }
    
    udp_socket* get_board_socket() {
	return &board_socket;
    }
    
 //   static const int buflen = 1024;
    static const int buflen = 4096;
    uint32_t buffer[buflen];
    int bufload;
    
private:
    
    unsigned short int board_port;
    char board_ip[20];
    unsigned short int local_port;
    char local_ip[20];
    
    unsigned int UDP_PACKET_MTU;
    unsigned int next_pk_id;
    
    
    udp_socket board_socket;
    ipbus_status_packet board_status;
    
    int send_buffer();
    int recv_buffer();
    int convert_buffer_to_net() {
	for (int word = 0; word < bufload; word++)
	    buffer[word] = htonl(buffer[word]);
    }
    int convert_buffer_to_hst() {
	for (int word = 0; word < bufload; word++)
	    buffer[word] = ntohl(buffer[word]);
    }
    
    void empty_buff() {
	memset(buffer, 0, sizeof(uint32_t) * buflen);
	bufload = 0;
    }
    ;
    
};

ipbus_connection::ipbus_connection() {
    set_board_port(50001);
    set_board_ip("172.20.75.95");
    set_local_port(0); //ANY
    set_local_ip("0"); //ANY
    
    empty_buff();
    
//    UDP_PACKET_MTU = 256;
    UDP_PACKET_MTU = 1024;
    next_pk_id = 0;
}

ipbus_connection::~ipbus_connection() {
    if (board_socket.get_status() == 1) {
	board_socket.close_socket();
    } else if (board_socket.get_status() < 0) {
	board_socket.accept_error();
	board_socket.close_socket();
    }
}

int ipbus_connection::send_buffer() {
    if (bufload * 4 > UDP_PACKET_MTU) {
	printf(
	            "ipbus_connection::send_buffer WARNING buffer load %u (%u byte) more than MTU %u\n",
	            bufload, bufload * 4, UDP_PACKET_MTU);
	bufload = UDP_PACKET_MTU / 4;
    }
    
    if (is_debug_print) {
	printf("ipbus_connection::send_buffer sending buffer:\n");
	printout_buffer(buflen);
    };
    convert_buffer_to_net();
    if (is_debug_print) {
	printf("ipbus_connection::send_buffer network type:\n");
	printout_buffer(buflen);
    };
    
    board_socket.send_packet(reinterpret_cast<char*>(buffer), 4 * bufload);
}

int ipbus_connection::recv_buffer() {
    empty_buff();
    bufload = board_socket.recv_packet(reinterpret_cast<char*>(buffer),
                                       UDP_PACKET_MTU) / 4;
    if (is_debug_print) {
	printf("ipbus_connection::recv_buffer received buffer:\n");
	printout_buffer(buflen);
    };
    convert_buffer_to_hst();
    if (is_debug_print) {
	printf("ipbus_connection::recv_buffer host type:\n");
	printout_buffer(buflen);
    };
}

int ipbus_connection::connect_to_board() {
    if (board_socket.get_status() == 1) {
	printf("connect_to_board: socket in error state, reseting\n");
	board_socket.accept_error();
    }
    
    if (board_socket.get_status() == 1)
	board_socket.close_socket();
    
    printf("\nConnecting to the board ...\n");
    
    board_socket.set_local_addr(local_ip, local_port);
    board_socket.set_remote_addr(board_ip, board_port);
    board_socket.open_socket();
    
    return request_status();
}

int ipbus_connection::request_status() {
    
    if (board_socket.get_status() != 1) {
	printf("request_status: no connection to board\n");
	return 0;
    }
    
    ipbus_header request_header;
    request_header.version = 2; 	//always 2
    request_header.packet_id = 0; 	//for status
    request_header.byte_order = 0xF; 	//always F
    request_header.packet_type = 1; //status request
    
    empty_buff();
    buffer[0] = request_header;
    bufload = 16;
    
    printf("\nRequesting board status ...\n");
    send_buffer();
    
    recv_buffer();
    board_status.clear();
    board_status = buffer;
    
    printf("Current status:\n");
    board_status.printout();
    
    if (is_debug_print) {
	board_status.printhex();
	printf("rceived header: ");
	board_status.get_header().printout();
	printf("next header: ");
	board_status.get_next_header().printout();
	printf("\n\n");
    }
    
    if ((board_status.get_header().version != 2)) {
	printf("request_status: wrong response header version: %u\n",
	       board_status.get_header().version);
	return -1;
    }
    
    if ((board_status.get_header().packet_type != 1)) {
	printf("request_status: wrong response header type: %u\n",
	       board_status.get_header().packet_type);
	return -1;
    }
    
    if ((board_status.get_header().packet_id != 0)) {
	printf("request_status: wrong response header ID: %u\n",
	       board_status.get_header().packet_id);
	return -1;
    }
    
    UDP_PACKET_MTU = board_status.cnt_MTU;
    next_pk_id = board_status.get_next_header().packet_id;
    
    return 1;
}

uint32_t ipbus_connection::read_single(uint32_t addr)
{
    uint8_t single_len = 1;
    uint32_t data[1] = { 0 };
    read_registers(data, single_len, addr);
    return data[0];
}

int ipbus_connection::read_registers(uint32_t *data, uint8_t &nwords,
                                     uint32_t addr, bool is_noinc) {
    
    if(is_action_print) printf("reading %u registers; base address: 0x%08x\n", nwords, addr);
    
    if (board_socket.get_status() != 1) {
	printf("read_registers: no connection to board\n");
	return 0;
    }
    
    //read response must less than MTU
    if (4 * (nwords + 2) > UDP_PACKET_MTU)
	nwords = UDP_PACKET_MTU / 4 - 2;
    
    ipbus_header control_header;
    control_header.version = 2; 			//always 2
    control_header.packet_id = next_pk_id++; 			//next id
    control_header.byte_order = 0xF; 		//always f
    control_header.packet_type = 0; 		//control
    //control_header.host_to_net();
    if (is_debug_print) {
	printf("read_registers: reading header: ");
	control_header.printhex();
    }
    
    ipbus_trs_header control_trs_header;
    control_trs_header.version = 2; 	//always 2
    control_trs_header.trnsctn_id = 1;	//first transaction
    control_trs_header.n_words = nwords;	//num of fords
    control_trs_header.type_id = is_noinc ? 0x2 : 0x0;		//read
    control_trs_header.info_code = 0xF; //request
    //control_trs_header.host_to_net();
    if (is_debug_print) {
	printf("read_registers: reading transaction: ");
	control_trs_header.printhex();
    }
    
    empty_buff();
    buffer[0] = control_header;
    buffer[1] = control_trs_header;
    buffer[2] = addr;
    bufload = 3;
    
    send_buffer();
    
    recv_buffer();
    
    ipbus_header response_header = buffer[0];
    ipbus_trs_header response_trs_header = buffer[1];
    
    if (((uint32_t) response_header != (uint32_t) control_header)) {
	printf("read_registers: wrong response header ");
	response_header.printout();
	printf("\nmust be: ");
	control_header.printout();
	printf("\n");
	return -1;
    }
    
    if (response_trs_header.info_code != 0) {
	printf("read_registers: response transaction error: %s\n",
	       get_info_code(response_trs_header.info_code));
	return -1;
    }
    
    if (is_debug_print) {
	printf("registers readed:\naddr       : word\n");
	for (int n = 0; n < nwords; n++)
	    printf("0x%08x : 0x%08x\n", addr + n, buffer[n + 2]);
	
    }
    
    memcpy(data, buffer + 2, nwords * 4);
    
}
/*
 * IPbus packet header		    (control_header)
 * 
 * IPbus transaction requests	    (control_trs_header)
 *	transaction header
 *	transaction body
 * 
 */

void ipbus_connection::write_single(uint32_t data, uint32_t addr)
{
    uint8_t single_len = 1;
    uint32_t data_a[1] = { data };
    write_registers(data_a, single_len, addr);
}

int ipbus_connection::write_registers(uint32_t *data, uint8_t &nwords, uint32_t addr) {
    
    //printf("writing %u registers; base address: 0x%08x\n", nwords, addr);
    
    if (board_socket.get_status() != 1) {
	printf("write_registers: no connection to board\n");
	return 0;
    }
    
    //read response must less than MTU
    if (4 * (nwords + 3) > UDP_PACKET_MTU)
	nwords = UDP_PACKET_MTU / 4 - 3;
    
    if(is_action_print)
    {
	printf("writing %u registers; base address: 0x%08x\n", nwords, addr);
	for (int n = 0; n < nwords; n++)
	    printf("0x%08x : 0x%08x\n", addr + n, data[n]);
    }
    
    ipbus_header control_header; // IPbus packet header
    control_header.version = 2; 		//always 2
    control_header.packet_id = next_pk_id++; 	//next id
    control_header.byte_order = 0xF; 		//always f
    control_header.packet_type = 0; 		//control packet
    //control_header.host_to_net();
    if (is_debug_print) {
	printf("write_registers: reading header: ");
	control_header.printhex();
    }
    
    ipbus_trs_header control_trs_header; //IPBus Transaction Header
    control_trs_header.version = 2; 	//always 2
    control_trs_header.trnsctn_id = 1;	//first transaction
    control_trs_header.n_words = nwords;	//num of fords
    control_trs_header.type_id = 1;		//non-incrementing read
    control_trs_header.info_code = 0xF; //request
    //control_trs_header.host_to_net();
    if (is_debug_print) {
	printf("write_registers: writing transaction: ");
	control_trs_header.printhex();
    }
    
    empty_buff();
    buffer[0] = control_header;
    buffer[1] = control_trs_header;
    buffer[2] = addr;
    memcpy(buffer + 3, data, nwords * 4);
    bufload = nwords + 3;
    
    send_buffer();
    
    recv_buffer();
    
    ipbus_header response_header = buffer[0];
    ipbus_trs_header response_trs_header = buffer[1];
    
    if (((uint32_t) response_header != (uint32_t) control_header)) {
	printf("write_registers: wrong response header ");
	response_header.printout();
	printf("\nmust be: ");
	control_header.printout();
	printf("\n");
	return -1;
    }
    
    if (response_trs_header.info_code != 0) {
	printf("write_registers: response transaction error: %s\n",
	       get_info_code(response_trs_header.info_code));
	return -1;
    }
    
}

#endif //IPBUS_CONNECTION_H
