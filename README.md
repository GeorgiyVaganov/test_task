# bronevik-test
This is simple scripts for deploy several servers.<br><br>

<b>What this script do:</b><br>
<ul>
    <li> Create user1 on master server and additional servers;</li>
    <li> Generate rsa key for user1 and upload it to additional servers;</li>
    <li> Making if non exist /var/www directory on additional servers and generate index.html file;</li>
    <li> Install docker CE;</li>
    <li> Download docker image nginx and run container with forwarded ports 80 and 443 on it;</li>
    <li> Configuring ssh server to deny root login and use only key authentication;</li>
    <li> Make default iptables INPUT policy to DROP;</li>
    <li> Open ICMP echo-request;</li>
    <li> Open SSH server port;</li>
 </ul>
 <p>On this firewall configuration docker container work properly, but other outbound traffic from host machine are droped.</p>

<b>Archive contain next files:</b><br>
<ul>
  <li><i>Install.sh</i> - startup script to run on master machine</li>
  <li><i>prepare_server</i> - script which will upload to additional servers</li>
  <li><i>env</i> - Enviroment variables</li></ul>
  
  <b>Variables descriptions</b>
<ul>
  <li><i>USER</i> - which user to create on LOCAL master machine</li>
  <li><i>SERVER_PASSWORD</i> - root password on additional servers</li>
  <li><i>SERVER_NAME</i> - DNS server prefix</li>
  <li><i>SERVER_COUNT</i> - how many servers we need to configure. If you set this var to "2", script will configure "server1" and "server2"
  </ul>
  
<b>Installation:</b>
<ul>
 <li>Unpack all files to some folder on master server;</li>
 <li>Edit <i>env</i> file as you need;</li>
 <li>Make Install.sh executable by doing <i>chmod +x Install.sh</i>;</li>
  <li>run <i>Install.sh</i> and have fun</i>
</ul>

