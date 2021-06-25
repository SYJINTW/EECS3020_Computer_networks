#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

void s_gets(char* dest, int n)
{
    char* ret_val = NULL;
    int i = 0;
 
    ret_val = fgets(dest, n, stdin);
    if (ret_val)
    {
        while (dest[i] != '\n' && dest[i] != '\0')
            i++;
 
        if (dest[i] == '\n')
        {
            dest[i] = '\0';
        }
        else
        {
            while (getchar() != '\n')
                continue;
        }
    }
 
    return; 
}

int main ()
{	
	struct sockaddr_in server_addr;	
	int sockfd;	
	char str_buf[256];
	int n;

	/* setup the server address	*/
	server_addr.sin_family = AF_INET;	
	server_addr.sin_port = htons(1234);	
	server_addr.sin_addr.s_addr = inet_addr ("127.0.0.1");	
	
	/* create a socket */
	sockfd = socket (PF_INET, SOCK_STREAM, 0);
	if(sockfd < 0){
        perror("ERROR opening socket");
        exit(1);
    }

	/* connect to the server */
	if(connect (sockfd, (struct sockaddr *) &server_addr, sizeof(struct sockaddr_in)) < 0)
	{
		perror("ERROR connecting");
        exit(1);
	}

	
	while(1)
	{
		/* Read from server */
		/* "What's your requirement? 1.DNS 2.QUERY 3.QUIT 4.CLOSE SERVER : " */
        bzero(str_buf,256);
        n = read(sockfd, str_buf, 255);
		if (n < 0) 
		{
			perror("ERROR reading from socket");
			exit(1);
		}
        printf("%s", str_buf);

		/* Send message to the server */
		bzero(str_buf,256);
		fgets(str_buf,255,stdin);
		n = write(sockfd, str_buf, strlen(str_buf));
		if (n < 0) {
			perror("ERROR writing to socket");
			exit(1);
		}

		if(str_buf[0] == '1')
		{
			/* Read from server */
			/* "Input URL address : " */
			bzero(str_buf,256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s", str_buf);

			/* Send message to the server */
			bzero(str_buf,256);
			s_gets(str_buf, 255);
			n = write(sockfd, str_buf, strlen(str_buf));
			if (n < 0) {
				perror("ERROR writing to socket");
				exit(1);
			}

			/* Read from server */
			/* The result -> num to read */
			bzero(str_buf,256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}

			/* Read from server addr_num times */
			/* The result -> address */
			int addr_num = std::stoi(str_buf);
			for(int i = 0; i < addr_num; i++)
			{
				bzero(str_buf,256);
				n = read(sockfd, str_buf, 255);
				if (n < 0) 
				{
					perror("ERROR reading from socket");
					exit(1);
				}
				printf("%s\n", str_buf);
			}
				
		}
		else if(str_buf[0] == '2')
		{
			/* Read from server */
			/* "Input student ID : " */
			bzero(str_buf,256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s", str_buf);

			/* Send message to the server */
			bzero(str_buf,256);
			s_gets(str_buf, 255);
			n = write(sockfd, str_buf, strlen(str_buf));
			if (n < 0) {
				perror("ERROR writing to socket");
				exit(1);
			}

			/* Read from server */
			/* get email */
			bzero(str_buf, 256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s\n", str_buf);
		}
		else if(str_buf[0] == '3')
		{
			/* Read from server */
			/* "Bye client" */
			bzero(str_buf,256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s", str_buf);
			break;
		}
		else if(str_buf[0] == '4')
		{
			/* Read from server */
			/* "Bye" */
			bzero(str_buf,256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s", str_buf);
			break;
		}
		else
		{
			/* Read from server */
			bzero(str_buf, 256);
			n = read(sockfd, str_buf, 255);
			if (n < 0) 
			{
				perror("ERROR reading from socket");
				exit(1);
			}
			printf("%s\n", str_buf);
		}
	}
	
	close(sockfd);	
	return 0;
}