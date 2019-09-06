#!/usr/bin/env bash
#
id ${USER} > /dev/null 2>&1
if [ "$?" -eq 1 ]; then
    /usr/sbin/addgroup ${USER}  > /dev/null 2>&1
    /usr/sbin/useradd -m -d /home/${USER} -s /bin/bash -g ${USER} -G sudo ${USER}
    su - user1 -c 'cat /dev/zero | ssh-keygen -q -N "" ' > /dev/null
fi

SSH_CMD='/usr/bin/ssh -o StrictHostKeyChecking=no'
SCP_CMD='/usr/bin/scp -o StrictHostKeyChecking=no'

YELLOW='\033[0;33m'
check_util() {
  TOOL_NAME=$1
  PACKAGES=$2
  if [[ -z "$2" ]]; then
    PACKAGES=$1
  fi
  echo -n "Checking $TOOL_NAME: "
  TEST_BIN=$(which $TOOL_NAME >/dev/null 2>&1 || echo "NOT_FOUND")
  if [[ $TEST_BIN == "NOT_FOUND" ]]; then
    echo "$TOOL_NAME is not found"
    echo -e "
${YELLOW}Warning: tool '$TOOL_NAME' is required to run this script.${NC}"
    echo -e "You can install it with command:"
    echo -e "${GREEN}${WITH_SUDO}apt-get install $PACKAGES${NC}
"
    MISSING_PACKAGES="$MISSING_PACKAGES $PACKAGES"
    # exit 1
  else
    echo "OK"
  fi
}

install_missing() {
  echo -e "
Do you want to install missing tools with the following command?"
  INSTALL_CMD="${WITH_SUDO}apt-get install -y $MISSING_PACKAGES"
  echo "> $INSTALL_CMD"
  read -r -p "Proceed? [Y/n]: "
  if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
    set -e
    eval $INSTALL_CMD
    set +e
  else
    echo -e "${RED}Fatal ERROR: required tools are missing!${NC}"
    exit 1
  fi
}

while true; do
  MISSING_PACKAGES=""
  check_util "sshpass"

  if [[ -n "$MISSING_PACKAGES" ]]; then
    install_missing
  else
    break
  fi
done

i=1
while (( i<=${SERVER_COUNT} )); do
  sshpass -p${SERVER_PASSWORD} $SCP_CMD /home/user1/.ssh/id_rsa.pub root@${SERVER_NAME}${i}:/tmp/.
  sshpass -p${SERVER_PASSWORD} $SCP_CMD `pwd`/prepare_server root@${SERVER_NAME}${i}:/root/prepare_server.sh
  sshpass -p${SERVER_PASSWORD} $SSH_CMD root@${SERVER_NAME}${i} "/bin/bash /root/prepare_server.sh" &

  (( i++ ))

done
