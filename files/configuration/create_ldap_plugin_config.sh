LDAP_FILE="${OVPN_DIR}/ldap.conf"

if [ -f $LDAP_FILE ]; then
   rm $LDAP_FILE
fi

cat <<Part01 >>$LDAP_FILE

<LDAP>
	URL		    ldap://$OVPN_LDAP_HOST
	BindDN		"$OVPN_LDAP_BindDN"
	Password	$OVPN_LDAP_BindPassword
	Timeout		15
	TLSEnable	no
	FollowReferrals no
</LDAP>

<Authorization>
	BaseDN		    "$OVPN_LDAP_BaseDN"
	SearchFilter	"(&($OVPN_LDAP_USERATTRIBUTE=%u)(memberOf=$OVPN_LDAP_GROUPMEMBER))"
	RequireGroup	false
</Authorization>

Part01