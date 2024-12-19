#!/bin/bash
##
source $CONFIGFILES/client.sh
source $CONFIGFILES/default_vars.sh

if [ ! -f "$PKI_DIR/private/${OVPN_SERVER_CN}.key" ]; then
 echo  >&2
 echo "**" >&2
 echo "The server key wasn't found, which means that something's" >&2
 echo "gone wrong with generating the certificates.  Try running" >&2
 echo "the container again with the REGENERATE_CERTS environmental" >&2
 echo "variable set to 'true'" >&2
 echo "**" >&2
 echo  >&2
 exit 1
fi


CLIENTCONFIG=$PKI_DIR/client-export/clientldap.ovpn    
touch $CLIENTCONFIG
cat <<Part01 >>$CLIENTCONFIG
   
client
dev tun
persist-key
persist-tun
remote $OVPN_SERVER_CN $OVPN_PORT_CLIENT_SIDE $OVPN_PROTOCOL
remote-cert-tls server
auth SHA512
proto $OVPN_PROTOCOL
reneg-sec 0    
Part01

    if [ "${OVPN_ROUTES}x" == "x" ] ; then
        echo "redirect-gateway def1">>$CLIENTCONFIG
    fi


# Windows: this can force some windows clients to load the DNS configuration
    if [ "${OVPN_REGISTER_DNS}" == "true" ]; then 
        echo "register-dns">>$CLIENTCONFIG
    fi 
    
  cat <<Part02 >>$CLIENTCONFIG   
verb $OVPN_VERBOSITY
float
nobind
ca ca.crt
tls-auth ta.key 1        
auth-user-pass
Part02

zip -r $PKI_DIR/client-export/client.zip $PKI_DIR/client-export/


 
