ssh_ping() {
  echo "
    TCPKeepAlive yes
    ServerAliveInterval 60
  " >> ~/.ssh/config
}

ssh_ping
