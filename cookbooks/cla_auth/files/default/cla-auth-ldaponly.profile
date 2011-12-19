[cla-auth-ldaponly]
nss_passwd=passwd: files
nss_group=group: files
nss_shadow=shadow: files
nss_netgroup=netgroup: nis
pam_auth=auth       required     pam_env.so
        auth       sufficient   pam_unix.so likeauth nullok
        auth       sufficient   pam_ldap.so use_first_pass
        auth       required     pam_deny.so
pam_account=account    sufficient   pam_unix.so
        account    sufficient   pam_ldap.so
        account    required     pam_deny.so
pam_password=password   required     pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
        password   sufficient   pam_unix.so nullok md5 shadow use_authtok
        password   sufficient   pam_ldap.so use_first_pass
        password   required     pam_deny.so
pam_session=session    required     pam_limits.so
        session    required     pam_unix.so
        session    optional     pam_ldap.so

