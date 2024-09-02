## utility scripts:
  
### send build files to remote server

scp -i \<path-to-pem\> -r ./_builds/linux ec2-user@\<host\>:~/game-server-build
