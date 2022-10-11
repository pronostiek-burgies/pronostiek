# pronostiek

## How to generate refresh token
1. browse to: https://www.dropbox.com/oauth2/authorize?client_id=rl5hbzehmfwp85w&token_access_type=offline&response_type=code
2. copy the code
3. and exectute this command:
   ```shell
   curl -k https://api.dropbox.com/oauth2/token \     -d code=<AUTHORIZATION_CODE> \     -d grant_type=authorization_code \     -u rl5hbzehmfwp85w:3419vcnk49gjmzi
   ```