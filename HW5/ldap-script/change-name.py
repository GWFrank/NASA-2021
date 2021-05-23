import ldap
from getpass import getpass

server_ip = "localhost"
username = raw_input("Your username:")
pwd = getpass("Your password:")

base = "uid="+username+",ou=people,dc=giver,dc=csie,dc=ntu"
con = ldap.initialize("ldap://"+server_ip)

try:
    con.start_tls_s()
except:
    print("LDAP over TLS failed, using unsecure connection")

auth = con.simple_bind_s(base, pwd)

if not isinstance(auth, tuple):
    print("connection failed")
    exit()

new_given_name = raw_input("New given name:")
modlist = [(ldap.MOD_REPLACE, "givenName", new_given_name)]
con.modify_s(base, modlist)
