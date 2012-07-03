#!/bin/sh
# DynDNS Update Client for the Linux NSLU2
#
# Script version - (used for user-agent)
VER=NSLU2-Linux-DNSUPD-0.9.4beta

# User configurable Section
#
# USER=<dnsuser>
# PASSWD=<dnspasswd>
# DOMAIN=<domain.name.org,domain2.name.org,domain3.name.org>
# SYSTEM=[dyndns|statdns|custom]
# WILDCARD=[ON|OFF|NOCHG]
# MX=[mailexchanger.name.org|NOCHG]
# BACKMX=[YES|NO|NOCHG]
# OFFLINE=[YES|NO] or leave blank

USER=usuario_en_dyndns.org
PASSWD=clave_del_usuario
DOMAIN=el_dominio.que_toque.cx
SYSTEM=dyndns
WILDCARD=ON
MX=NOCHG
BACKMX=NOCHG
OFFLINE=

# Var folder, Set VAR to either '/var' or '/opt/var', '/opt/var' recommended for Unslung users
VAR=/var

# Update using either 'http' or 'https' (openssl and wget-ssl are needed for https)
HTTP=https
# For https set SSL=--no-check-certificate
SSL=--no-check-certificate

# Paths to program files
WGET=/usr/bin/wget
FIND=/usr/bin/find
CHMOD=/bin/chmod
MKDIR=/bin/mkdir
GREP=/bin/grep
ECHO=/bin/echo
DATE=/bin/date
CAT=/bin/cat
SED=/bin/sed
CP=/bin/cp
RM=/bin/rm
# A beep command equivalent to 'printf "\a"'
#BEEP='Set_Led beep1'  #unslung
# sgtes para slugos o debian
#BEEP='/sbin/leds beep'
BEEP='/usr/bin/beep'

# Dyndns script update section
# 
# Check and create folders
if [ ! -d ${VAR}/log ]; then
  ${MKDIR} -p ${VAR}/log
  ${CHMOD} 755 ${VAR}/log
fi
if [ ! -d ${VAR}/tmp ]; then
  ${MKDIR} -p ${VAR}/tmp
  ${CHMOD} 755 ${VAR}/tmp
fi

# Check and create err.ip
if [ ! -f ${VAR}/tmp/err.ip ]
then
  ${ECHO} "off" > ${VAR}/tmp/err.ip
fi

# Check for Fatal error file,  disable script and error beep if file exists
if [ -f ${VAR}/log/dyndns.fatal.error ]
then
  ${BEEP}
  ${BEEP}
  exit 0
fi

# Fetch current IP Address.
###########################
# 
# --- original:
# ${WGET} -q -t 1 -T 30 -U ${VER} -O ${VAR}/tmp/now.ip http://checkip.dyndns.com:8245/
# --- increased parameter t (tries) to avoid error "not updated: read error on ip fetch") 
#     into ip_hist.log
${WGET} -q -t 12 -T 30 -U ${VER} -O ${VAR}/tmp/now.ip http://checkip.dyndns.com:8245/
# --- This could be changed to get the ip address from router >  > ${VAR}/tmp/now.ip 

# Verify the data is good.
PAT='Current IP Address: *[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'
if ${GREP} "$PAT" ${VAR}/tmp/now.ip >/dev/null;
then
  MYIP="`${SED} -e 's|.*Address: ||; s|</body>.*||' ${VAR}/tmp/now.ip`"
  # On good IP data.
  # Check for IP history.
  if [ -f ${VAR}/tmp/old.ip ]
  then
    # On history found.
    if [ "`${CAT} ${VAR}/tmp/err.ip`" = "on" ]
    then
      ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - not updated: Network connection restored." >> ${VAR}/log/ip_hist.log;
      # Turn err.ip Off
      ${ECHO} "off" > ${VAR}/tmp/err.ip
    fi
    # Check for settings change
    if [ ! "`${CAT} ${VAR}/tmp/update.para`" = "${USER}:${PASSWD}:${DOMAIN}:${SYSTEM}:${WILDCARD}:${MX}:${BACKMX}:${OFFLINE}:" ]
    then 
      ${WGET} -q -t 1 -T 30 -U ${VER} -O ${VAR}/tmp/upd.ip ${SSL} "${HTTP}://${USER}:${PASSWD}@members.dyndns.org/nic/update?system=${SYSTEM}&hostname=${DOMAIN}&myip=${MYIP}&wildcard=${WILDCARD}&mx=${MX}&backmx=${BACKMX}&offline=${OFFLINE}";
      # Log the settings change and notify user.
      ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - Settings - `${CAT} ${VAR}/tmp/upd.ip`" >> ${VAR}/log/ip_hist.log;
      ${ECHO} "`${DATE} +%x`" > ${VAR}/tmp/day.ip;
      ${RM} -f ${VAR}/tmp/old.ip;
      ${CP} ${VAR}/tmp/now.ip ${VAR}/tmp/old.ip;
      ${ECHO} "${USER}:${PASSWD}:${DOMAIN}:${SYSTEM}:${WILDCARD}:${MX}:${BACKMX}:${OFFLINE}:" > ${VAR}/tmp/update.para;
      ${BEEP}
    fi
    # Check for IP Change
    if [ "`${CAT} ${VAR}/tmp/now.ip`" = "`${CAT} ${VAR}/tmp/old.ip`" ]
    then
      # On no IP change
      # Check if 28 day refresh is needed.
      # you must enter the appropriate paths for the find command
      # but do not use variables in the string or it may not work correctly 
      /usr/bin/find /var/tmp/ -name old.ip -mtime +27 -exec rm {} \;
      if  [ -f ${VAR}/tmp/old.ip ]
      then
        # On no refresh needed.
        # Check for Next day. 
        if [ ! "`${CAT} ${VAR}/tmp/day.ip`" = "`${DATE} +%x`" ]
        then
          # On day change
          # Log entry
          ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - No update - `${CAT} ${VAR}/tmp/upd.ip`" >> ${VAR}/log/ip_hist.log;
          ${ECHO} "`${DATE} +%x`" > ${VAR}/tmp/day.ip;
        fi
      else
        # On refresh needed.
        # Do a 28 Day refresh and Notify user with a distinguishable beep.
        ${WGET} -q -t 1 -T 30 -U ${VER} -O ${VAR}/tmp/upd.ip ${SSL} "${HTTP}://${USER}:${PASSWD}@members.dyndns.org/nic/update?system=${SYSTEM}&hostname=${DOMAIN}&myip=${MYIP}&wildcard=${WILDCARD}&mx=${MX}&backmx=${BACKMX}&offline=${OFFLINE}";
        echo "`${DATE} +%Y%m%d.%H%M%S` - Refresh - `${CAT} ${VAR}/tmp/upd.ip`" >> ${VAR}/log/ip_hist.log;
        echo "`${DATE} +%x`" > ${VAR}/tmp/day.ip;
        ${CP} ${VAR}/tmp/now.ip ${VAR}/tmp/old.ip;
        ${BEEP}
      fi
    else
      # On IP change
      # Update DynDNS with new IP Address. 
      ${WGET} -q -t 1 -T 30 -U ${VER} -O ${VAR}/tmp/upd.ip ${SSL} "${HTTP}://${USER}:${PASSWD}@members.dyndns.org/nic/update?system=${SYSTEM}&hostname=${DOMAIN}&myip=${MYIP}&wildcard=${WILDCARD}&mx=${MX}&backmx=${BACKMX}&offline=${OFFLINE}";
      # Log the IP change and notify user.
      ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - Update - `${CAT} ${VAR}/tmp/upd.ip`" >> ${VAR}/log/ip_hist.log;
      ${ECHO} "`${DATE} +%x`" > ${VAR}/tmp/day.ip;
      ${RM} -f ${VAR}/tmp/old.ip;
      ${CP} ${VAR}/tmp/now.ip ${VAR}/tmp/old.ip;
      ${BEEP}
    fi
  else
    # On No History
    # Initialize client and Update DynDNS.
    # Check err.ip status
    if [ "`${CAT} ${VAR}/tmp/err.ip`" = "on" ]
    then
      # Log Service Restoral.
      ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - not updated: Network connection restored." >> ${VAR}/log/ip_hist.log;
    fi
    # Set err.ip off
    ${ECHO} "off" > ${VAR}/tmp/err.ip
    ${WGET} -q -t 1 -T 30 -U ${VER} -O ${VAR}/tmp/upd.ip ${SSL} "${HTTP}://${USER}:${PASSWD}@members.dyndns.org/nic/update?system=${SYSTEM}&hostname=${DOMAIN}&myip=${MYIP}&wildcard=${WILDCARD}&mx=${MX}&backmx=${BACKMX}&offline=${OFFLINE}";
    ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - Initialise - `${CAT} ${VAR}/tmp/upd.ip`" >> ${VAR}/log/ip_hist.log;
    ${ECHO} "`${DATE} +%x`" > ${VAR}/tmp/day.ip;
    ${CP} ${VAR}/tmp/now.ip ${VAR}/tmp/old.ip;
    ${ECHO} "${USER}:${PASSWD}:${DOMAIN}:${SYSTEM}:${WILDCARD}:${MX}:${BACKMX}:${OFFLINE}:" > ${VAR}/tmp/update.para
    ${BEEP}
  fi
  # Analyse and report any Fatal error return strings
  if ${GREP} "\!yours\|notfqdn\|abuse\|nohost\|badagent\|badauth\|badsys\|dnserr\|numhost\|911\|\!donator" ${VAR}/tmp/upd.ip >/dev/null
  then
    ${ECHO} "`${DATE} +%x` - Fatal Error Returned from Dyndns - `${CAT} ${VAR}/tmp/upd.ip` - Correct the error then delete this file to re-enable" > ${VAR}/log/dyndns.fatal.error;
    ${BEEP}
    ${BEEP}
    #
    # Place holder - for example - to send fatal error report by email
    # #############
    #
  fi
else
  # On IP read error
  # Check err.ip status
  if [ ! "`${CAT} ${VAR}/tmp/err.ip`" = "on" ]
  then
    # On err.ip = off - Log read error. 
    ${ECHO} "`${DATE} +%Y%m%d.%H%M%S` - not updated: read error on ip fetch" >> ${VAR}/log/ip_hist.log;
  fi
  # Set err.ip = On to allow only one error log on next run.
  ${ECHO} "on" > ${VAR}/tmp/err.ip
  # Notify user.
  ${BEEP}
  ${BEEP}
fi
# end

# ADD MANUALLY A CRON JOB CALLING THIS SCRIPT
# EXAMPLE FOR NSLU2:
# Set the interval of the next IP check using a crontab entry.
# Once every 15 minutes is good for a home server.
# */15 * * * * root /opt/bin/dnsupd &>/dev/null
#


