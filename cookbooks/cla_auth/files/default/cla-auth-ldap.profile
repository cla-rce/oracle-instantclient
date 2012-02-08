[cla-auth-ldap]
nss_passwd=passwd: 	files ldap
nss_group=group: 	files ldap
nss_shadow=shadow: 	files ldap
nss_netgroup=netgroup: 	ldap
nss_automount=automount:	files ldap
pam_auth=auth       required     pam_env.so
        auth       [success=2 default=ignore]   pam_unix.so nullok_secure
        auth       [success=1 default=ignore]   pam_ldap.so use_first_pass
        auth       required     pam_deny.so
        auth       requisite    pam_permit.so
pam_account=account    [success=2 new_authtok_reqd=done default=ignore]   pam_unix.so
        account    [success=1 default=ignore]   pam_ldap.so
        account    requisite    pam_deny.so
        account    required     pam_permit.so
pam_password= password   [success=2 default=ignore]   pam_unix.so obscure sha512 shadow
        password   [success=1 user_unknown=ignore default=die]   pam_ldap.so use_authtok use_first_pass
        password   requisite    pam_deny.so
        password   required     pam_permit.so
pam_session=session    [default=1]     pam_permit.so
        session    required     pam_deny.so
        session    required     pam_limits.so
        session    required     pam_unix.so
        session    optional     pam_ldap.so
        session    optional     pam_umask.so usergroups

