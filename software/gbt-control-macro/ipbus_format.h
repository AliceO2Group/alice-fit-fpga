#ifndef IPBUS_FORMAT_H_
#define IPBUS_FORMAT_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

char* get_info_code(uint8_t code) {
	switch (code) {
	case 0x0:
		return "Request handled successfully by target";

	case 0x1:
		return "Bad header";

	case 0x4:
		return "Bus error on read";

	case 0x5:
		return "Bus error on write";

	case 0x6:
		return "Bus timeout on read (256 IPbus clock cycles, 8us)";

	case 0x7:
		return "Bus timeout on write (256 IPbus clock cycles, 8us)";

	default:
		return "Outbound request";

	}
}

void print_by_byte(uint8_t *data, int size) {

	for (int byte = 0; byte < size; byte++) {
		if (byte % 4 == 0)
			printf("\nb%i: ", byte);
		printf("%02x ", *(data + byte));
		//if( (byte % 4 == 0) ) printf("\n");
	}
	printf("\n");
}

struct ipbus_header {
	uint packet_type :4;
	uint byte_order :4;
	uint packet_id :16;
	uint rsvd :4;
	uint version :4;

	void printout() {
		printf("ver: %u; type: %u; pk ID: %u\n", version, packet_type,
				packet_id);
	}
	void printhex() {
		printf("%x\n", *((uint32_t*) this));
	}
	void clear() {
		version = 0;
		rsvd = 0;
		packet_id = 0;
		packet_type = 0;
		byte_order = 0;
	}

	ipbus_header() {
		clear();
	}

	ipbus_header(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(buffer));
	}
	ipbus_header(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(&buffer));
	}
	operator uint8_t*() {
		return reinterpret_cast<uint8_t*>(this);
	}
	operator uint8_t() {
		return *(reinterpret_cast<uint8_t*>(this));
	}
	ipbus_header operator=(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(buffer));
		return *this;
	}
	ipbus_header operator=(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(&buffer));
		return *this;
	}

	ipbus_header(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(buffer));
	}
	ipbus_header(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(&buffer));
	}
	operator uint32_t*() {
		return reinterpret_cast<uint32_t*>(this);
	}
	operator uint32_t() {
		return *(reinterpret_cast<uint32_t*>(this));
	}
	ipbus_header operator=(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(buffer));
		return *this;
	}
	ipbus_header operator=(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_header*>(&buffer));
		return *this;
	}

	operator char*() {
		return reinterpret_cast<char*>(this);
	}

};

struct ipbus_trs_header {
	uint info_code :4;
	uint type_id :4;
	uint n_words :8;
	uint trnsctn_id :12;
	uint version :4;

	void printout() {
		printf("ver: %u; trns id: %u; n words: %u; type id %u; info code: %u\n",
				version, trnsctn_id, n_words, type_id, info_code);
	}
	void printhex() {
		printf("%08x\n", *((uint32_t*) this));
	}
	void clear() {
		version = 0;
		trnsctn_id = 0;
		n_words = 0;
		type_id = 0;
		info_code = 0;
	}

	ipbus_trs_header() {
		clear();
	}

	ipbus_trs_header(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(buffer));
	}
	ipbus_trs_header(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(&buffer));
	}
	operator uint8_t*() {
		return reinterpret_cast<uint8_t*>(this);
	}
	operator uint8_t() {
		return *(reinterpret_cast<uint8_t*>(this));
	}
	ipbus_trs_header operator=(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(buffer));
		return *this;
	}
	ipbus_trs_header operator=(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(&buffer));
		return *this;
	}

	ipbus_trs_header(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(buffer));
	}
	ipbus_trs_header(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(&buffer));
	}
	operator uint32_t*() {
		return reinterpret_cast<uint32_t*>(this);
	}
	operator uint32_t() {
		return *(reinterpret_cast<uint32_t*>(this));
	}
	ipbus_trs_header operator=(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(buffer));
		return *this;
	}
	ipbus_trs_header operator=(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_trs_header*>(&buffer));
		return *this;
	}

	operator char*() {
		return reinterpret_cast<char*>(this);
	}

};

//status response packet 32*16 bits
struct ipbus_status_packet {
	uint header :32;
	uint cnt_MTU :32;
	uint nResponseBuffers :32;
	uint next_pkt_header :32;
	uint8_t in_trf_hstr[16];
	uint32_t cntr_pkt_hstr_rcvd[4];

	uint32_t cntr_pkt_hstr_outg[4];

	ipbus_status_packet() {
		clear();
	}

	ipbus_header get_header() {
		return header;
	}
	ipbus_header get_next_header() {
		return next_pkt_header;
	}

	void printhex();
	void printout() {
		printf("MTU: %u; nResponseBuffers: %u; next pID: %u\n", cnt_MTU,
				nResponseBuffers, get_next_header().packet_id);
	}

	void clear() {
		memset(this, 0, sizeof(*this));
	}

	ipbus_status_packet(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(buffer));
	}
	ipbus_status_packet(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(&buffer));
	}
	operator uint8_t*() {
		return reinterpret_cast<uint8_t*>(this);
	}
	operator uint8_t() {
		return *(reinterpret_cast<uint8_t*>(this));
	}
	ipbus_status_packet operator=(uint8_t* buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(buffer));
		return *this;
	}
	ipbus_status_packet operator=(uint8_t buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(&buffer));
		return *this;
	}

	ipbus_status_packet(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(buffer));
	}
	ipbus_status_packet(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(&buffer));
	}
	operator uint32_t*() {
		return reinterpret_cast<uint32_t*>(this);
	}
	operator uint32_t() {
		return *(reinterpret_cast<uint32_t*>(this));
	}
	ipbus_status_packet operator=(uint32_t* buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(buffer));
		return *this;
	}
	ipbus_status_packet operator=(uint32_t buffer) {
		*this = *(reinterpret_cast<ipbus_status_packet*>(&buffer));
		return *this;
	}

	operator char*() {
		return reinterpret_cast<char*>(this);
	}

};

void ipbus_status_packet::printhex() {
	printf(
			"header %08x; MTU: %08x; nResponseBuffers: %08x; next_pkt_header: %08x\n",
			header, cnt_MTU, nResponseBuffers, next_pkt_header);

	printf("Incoming traffic history:\n");
	for (int n = 0; n < 16; n++)
		printf("%i: %02x\n", n, in_trf_hstr[n]);

	printf("Control packet history, received:\n");
	for (int n = 0; n < 4; n++)
		printf("%i: %08x\n", n, cntr_pkt_hstr_rcvd[n]);

	printf("Control packet history, outgoing:\n");
	for (int n = 0; n < 4; n++)
		printf("%i: %08x\n", n, cntr_pkt_hstr_outg[n]);
}

#endif /* IPBUS_FORMAT_H_ */
