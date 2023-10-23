#ifndef UDP_SOCKET_H
#define UDP_SOCKET_H

#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

// class open connection to server (FPGA board)
// send packets and receive response
class udp_socket {
public:
	udp_socket();
	~udp_socket();

	void set_local_addr(const char *ip_addr = "",
			const unsigned short int port = -1);
	void set_remote_addr(const char *ip_addr = "",
			const unsigned short int port = -1);
	int open_socket();
	int send_packet(char* packet, const int packet_size);
	int recv_packet(char* packet, const int packet_size);
	int close_socket();

	int get_status() {
		return status;
	}
	;
	void accept_error() {
		status = 0;
	}
	;

private:
	struct sockaddr_in local_addr;
	struct sockaddr_in remote_addr;
	int sck_connection;
	int status; // 1-socket opened; 0-socket closed; -1 error

};

udp_socket::udp_socket() {
	//set_local_addr();
	//set_remote_addr();
	status = 0;
}

udp_socket::~udp_socket() {
	close_socket();
}

void udp_socket::set_local_addr(const char *ip_addr,
		const unsigned short int port) {
	memset(&local_addr, 0, sizeof(local_addr));
	local_addr.sin_family = AF_INET;

	if (strlen(ip_addr) < 7) {
		local_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	} else {
		local_addr.sin_addr.s_addr = inet_addr(ip_addr);
	}

	if (port <= 0) {
		local_addr.sin_port = htons((u_short) 50010);
	} else {
		local_addr.sin_port = htons((u_short) port);
	}
	printf("set local address IP: %s:%u\n", inet_ntoa(local_addr.sin_addr),
			ntohs(local_addr.sin_port));
}

void udp_socket::set_remote_addr(const char *ip_addr,
		const unsigned short int port) {
	memset(&remote_addr, 0, sizeof(remote_addr));
	remote_addr.sin_family = AF_INET;

	if (strlen(ip_addr) < 7) {
		remote_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	} else {
		remote_addr.sin_addr.s_addr = inet_addr(ip_addr);
	}

	if (port <= 0) {
		remote_addr.sin_port = htons((u_short) 50005);
	} else {
		remote_addr.sin_port = htons((u_short) port);
	}
	printf("set remote address IP: %s:%u\n", inet_ntoa(remote_addr.sin_addr),
			ntohs(remote_addr.sin_port));
}

int udp_socket::open_socket() {
	if (status == -1) {
		printf("open_socket: udp_socket in error state\n");
		return 0;
	}

	if (status == 1)
		close_socket();

	sck_connection = socket(AF_INET, SOCK_DGRAM, 0);
	if (sck_connection < 0) {
		printf("open_socket: can't create UDP socket\n");
		status = -1;
		return 0;
	} else {
		printf("open_socket: socket created\n");
	}

	if (bind(sck_connection, (struct sockaddr *) &local_addr,
			sizeof(local_addr)) < 0) {
		printf("open_socket: bind error\n");
		status = -1;
		return 0;
	} else {
		printf("open_socket: loc address binded\n");
	}

	if (connect(sck_connection, (struct sockaddr *) &remote_addr,
			sizeof(remote_addr)) < 0) {
		printf("open_socket: connect error\n");
		status = -1;
		return 0;
	} else {
		printf("open_socket: socket connected\n");
	}

	status = 1;
	return sck_connection;
}

int udp_socket::send_packet(char* packet, const int packet_size) {
	if (status == -1) {
		printf("send_packet: udp_socket in error state\n");
		return 0;
	}

	int bt_sent = send(sck_connection, packet, packet_size, 0);

	if (bt_sent != packet_size) {
		printf("send_packet: packet size %i; sent %i byte\n", packet_size,
				bt_sent);
	}

	return bt_sent;
}

int udp_socket::recv_packet(char* packet, const int packet_size) {
	if (status == -1) {
		printf("recv_packet: udp_socket in error state\n");
		return 0;
	}

	int bt_recv = recv(sck_connection, packet, packet_size, 0);

	if (bt_recv != packet_size) {
		//printf("recv_packet: buffer size %i; recv %i byte\n", packet_size, bt_recv);
	}

	return bt_recv;
}

int udp_socket::close_socket() {
	if (status == -1) {
		printf("close_socket: udp_socket in error state\n");
		return 0;
	}

	if (status == 0)
		return 1;

	int cl_msg = close(sck_connection);
	if (cl_msg < 0) {
		printf("close_socket: connect error\n");
		status = -1;
	} else {
		printf("close_socket: socket closed\n");
		status = 0;
	}
	return cl_msg;
}

#endif // UDP_SOCKET_H

