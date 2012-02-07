[cla-auth-winbind]
nss_passwd=passwd:	files winbind
nss_group=group:	files winbind
nss_shadow=shadow:	files winbind
nss_netgroup=netgroup:	nis
nss_automount=automount:	files
nss_hosts=hosts:	files dns
pam_auth=auth	required	pam_env.so
        auth	[success=2 new_authtok_reqd=done default=ignore]	pam_winbind.so
        auth	[success=1 default=ignore]	pam_unix.so use_first_pass use_authtok
        auth	requisite	pam_deny.so
        auth	required	pam_permit.so
pam_account=account	[success=2 new_authtok_reqd=done default=ignore]	pam_winbind.so
        account	[success=1 default=ignore]	pam_unix.so	use_first_pass	use_authtok
        account	requisite	pam_deny.so
        account	required	pam_permit.so
pam_password=password	[success=2 default=ignore]  pam_unix.so     obscure sha512
        password	[success=1 default=ignore]  pam_winbind.so  use_first_pass  md5  use_authtok
        password	requisite	pam_deny.so
        password	required	pam_permit.so
pam_session=session	required	pam_limits.so
        session	optional	pam_winbind.so
        session	required	pam_unix.so