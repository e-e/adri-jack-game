## utility scripts:
  
### send build files to remote server

scp -i ~/.ssh/wakeru-api.pem -r ./_builds/linux ec2-user@wakeru.yomutomu.com:~/game-server-build
