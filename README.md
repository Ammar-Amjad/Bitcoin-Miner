# Bitcoin-Miner

# Task:

To make a Erlang based Bitcoin miner able to mine 0’s based on the input that user enters, Outputting the required stats
and messages.

# Components:

1- Server: That supervises all the worker nodes.

2- Local workers: Workers that fire up after the server is instantiated.

3- Remote workers: Added to server’s nodes as they become available. Remote workers communicate their
availability to the server.

# Instructions:

1- Start server terminal with erl -sname server.

2- Complie c(project).

3- Run project:server(n). where n is the number of bitcoin zeros we want. Not only the server but
the maximum number of workers the server can have will also be spawned to start mining on the server.

4- In another terminal, Start worker terminal with erl -sname w1.

5- Run project:starthasher(server@IP). where server is name of server, IP is the IP address
of server.

6- Run multiple instances or same or different machines with above command at step 5.

7- Hash and the string used to find the hash, will be displayed by server when any of the workers/hashers
finds the desired hash.

8- For distributed communication, we can run this on multiple machines on different PC’s, the commands
are on page 3. We will additionally need to setup the connection for remote workers and an example is
shown on page 4.

# Input:
n - desired number of zeros - input from terminal

# Output:
1- String used to find hash
2- The hash
---------------------------------------------------------------------------------------------------------
# Commands to connect from remote PC:

Run these commands based on either windows or linux machines, Terminal must be run under administrator
modes on both machines:

On both machine start terminal in administrator mode.

# For Linux:

Step 1:

Linux machine 1:

erl -name freebsd_node1@10.20.23.44 -setcookie ’mycookie’

Linux machine 2:

erl -name freebsd_node2@10.20.23.37 -setcookie ’mycookie’

Step 2:

Linux machine 1:

net_kernel:connect_node(’freebsd_node2@10.20.23.37’)

Linux machine 2:

net_kernel:connect_node(’freebsd_node1@10.20.23.44’)

------------------

# For Windows:

Step 1:

Windows machine 1:

werl -name windows_node1@10.20.23.44 -setcookie ’mycookie’

Windows machine 2:

werl -name windows_node2@10.20.23.37 -setcookie ’mycookie’

Step 2:

Windows machine 1:

net_adm:ping(’windows_node2@10.20.23.37’)

Windows machine 2:

net_adm:ping(’windows_node1@10.20.23.44’)

nodes( ).

