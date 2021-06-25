#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <string.h>
#include <strings.h>
#include <arpa/inet.h>
#include <unistd.h>


int status = 2; // 0: end, 1: waiting, 2: start

typedef struct t_data
{
	char student_id[256];
	char email[256];
} data;

/* Write to the client */
void send_message(int streamfd, char* response, char* message)
{
	int n;
	bzero(response, 256);
	strcpy(response, message);
	n = write(streamfd, response, 255);
	if (n < 0) 
	{
		perror("ERROR writing to socket");
		exit(1);
	}
}

int main ()
{	
	struct sockaddr_in server_addr, client_addr;	
	int sockfd, streamfd, port;
	socklen_t addr_size;
	char str_buf[256], response[256], message[256];
	int n;
	struct hostent *host;

	/* create the query table */
	FILE *fp;
	int size = 0;
	data table[100];
	fp = fopen("query.txt", "r");
	for(size = 0; fscanf(fp, "%s%s", table[size].student_id, table[size].email) != EOF; size++){}

	/* initialize socket structure */
	bzero (&server_addr, sizeof(server_addr));
	port = 1234;

	server_addr.sin_family = AF_INET;	
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	server_addr.sin_port = htons(port); // port	

	/* First call to socket() function */	
	sockfd = socket (PF_INET, SOCK_STREAM, 0);
	if (sockfd < 0) 
	{
		perror("ERROR opening socket");
		exit(1);
   	}

	/* Now bind the host address using bind() call.*/
	if (bind (sockfd, (struct sockaddr *) &server_addr, sizeof(struct sockaddr_in))< 0) 
	{
		perror("ERROR on binding");
		exit(1);
   	}

	/* Now start listening for the clients, here process will
		* go in sleep mode and will wait for the incoming connection
	*/
	while(status){
		listen(sockfd,10);
		addr_size = sizeof(client_addr);

		/* Accept actual connection from the client */
		streamfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_size);			
		if (streamfd < 0)
		{
			perror("ERROR on accept");
			exit(1);
		}

		/* If connection is established then start communicating */
		while(1)
		{
			/* Write to the client */
			send_message(streamfd, response, (char *)"What's your requirement? 1.DNS 2.QUERY 3.QUIT 4.CLOSE SERVER : ");
			
			/* Read from the client */
			bzero(str_buf,256);
			n = read(streamfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			
			if(str_buf[0] == '1')
			{
				/* Write to the client */
				send_message(streamfd, response, (char *)"Input URL address : ");

				/* Read from the client */
				bzero(str_buf,256);
				n = read(streamfd, str_buf, 255);
				if (n < 0) 
				{
					perror("ERROR reading from socket");
					exit(1);
				}
				printf("Get URL from client: %s\n", str_buf);

				/* Get host by name */
				host = gethostbyname(str_buf);

				if(host == NULL)
				{
					/* Write to the client */
					/* 1 */
					strcpy(message, "1");
					send_message(streamfd, response, message);
					
					/* Write to the client */
					/* "No such URL.\n" */
					send_message(streamfd, response, (char *)"No such URL.");
					printf("Found result: No such URL.\n");
				}
				else
				{
					/* Find number of address */
					int addr_num = 0;
					struct in_addr **addr_list;
					addr_list = (struct in_addr **)host->h_addr_list;
					for(addr_num = 0; addr_list[addr_num] != NULL; addr_num++){}

					/* Write to the client */
					/* addr_num times */
					sprintf(message, "%d", addr_num);
					send_message(streamfd, response, message);

					/* Write addr_num times to the client */
					for(addr_num = 0; addr_list[addr_num] != NULL; addr_num++)
					{
						send_message(streamfd, response, (char *)(inet_ntoa(*addr_list[addr_num])));
						printf("Found result: %s\n", (char *)(inet_ntoa(*addr_list[addr_num])));
					}
				}

			}
			else if(str_buf[0] == '2')
			{
				/* Write to the client */
				send_message(streamfd, response, (char *)"Input student ID : ");

				/* Read from the client */
				bzero(str_buf,256);
				n = read(streamfd, str_buf, 255);
				if (n < 0) 
				{
					perror("ERROR reading from socket");
					exit(1);
				}
				printf("Get student ID from client: %s\n", str_buf);

				/* Check if the table have student ID */
				strcpy(message, "No such student ID.");
				for(int i = 0; i < size; i++)
				{
					if(strcmp(str_buf, table[i].student_id) == 0)
					{
						bzero(message, 256);
						strcpy(message, table[i].email);
					}
				}

				/* Write to the client */
				send_message(streamfd, response, message);
				printf("Found result: %s\n", message);
			}
			else if(str_buf[0] == '3')
			{
				/* Write to the client */
				send_message(streamfd, response, (char *)"Bye client.");
				status = 1;
				break;
			}
			else if(str_buf[0] == '4')
			{
				/* Write to the client */
				send_message(streamfd, response, (char *)"Bye.");
				status = 0;
				break;
			}
			else
			{
				/* Write to the client */
				send_message(streamfd, response, (char *)"Try again.");
			}
		}
   	}
   	return 0;
}