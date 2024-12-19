# SET CONIG DIRECTORY
CONFIGFILES="/opt/configuration"


# IF SERVER CERTIFICATE WITH OVPN_SERVER COMMON NAME IS FIND OR $REGENERATE_CERTS IS SET TO TRUE WE ENTER THIS CONDITION
if [ ! -f "$PKI_DIR/issued/$OVPN_SERVER_CN.crt" ] || [ "$REGENERATE_CERTS" == 'true' ]; then

# init pki
 echo "easyrsa: creating server certs"
 sed -i 's/^RANDFILE/#RANDFILE/g' /opt/easyrsa/openssl-easyrsa.cnf
 EASYCMD="/opt/easyrsa/easyrsa"
 . /opt/easyrsa/pki_vars
 $EASYCMD init-pki
 

# GENERATE CA
 $EASYCMD build-ca nopass


# GENERATE DIFFIE-HELMAN
 $EASYCMD gen-dh
 openvpn --genkey secret $PKI_DIR/ta.key
 
 # GENERATE SERVER CERTIFICATE WITH OVPN_SERVER COMMON NAME
 $EASYCMD build-server-full "$OVPN_SERVER_CN" nopass


# GENERATE AN ARCHIVE WITH ca.crt, ta/key, CLIENT.crt,CLIENT.key to export configuration to your client HOST       
                mkdir -p $PKI_DIR/client-export/$
                cp $PKI_DIR/ta.key $PKI_DIR/client-export/${CLIENT}
                cp $PKI_DIR/ca.crt $PKI_DIR/client-export/${CLIENT}

else 
    echo "toto"
fi


