import ldap
from getpass import getpass

server_ip = "localhost"

pwd = getpass("Root password:")
acc_base = "ou=people,dc=giver,dc=csie,dc=ntu"
acc_filter = "objectClass=account"

con = ldap.initialize("ldap://"+server_ip)

try:
    con.start_tls_s()
except:
    print("LDAP over TLS failed, using unsecure connection")

auth = con.simple_bind_s("cn=giver,dc=giver,dc=csie,dc=ntu", pwd)

if not isinstance(auth, tuple):
    print("connection failed")
    exit()

while True:
    while True:
        locking = raw_input("Locking user? (y/n)")
        if locking != "y" and locking != "n":
            locking = raw_input("Locking user? (y/n)")
        else:
            break
    username = raw_input("Username:")
    base = "uid="+username+","+acc_base
    s_re = con.search_s(acc_base, ldap.SCOPE_SUBTREE, "uid="+username, ["userPassword"])
    passwd = s_re[0][1]["userPassword"][0]
    if locking == "y":
        passwd = "LOCKED" + passwd
    else:
        while passwd[0:6] == "LOCKED":
            passwd = passwd[6:]
    modlist = [(ldap.MOD_REPLACE, "userPassword", passwd)]
    con.modify_s(base, modlist)

    while True:
        keep = raw_input("Managing more users? (y/n)")
        if keep != "y" and keep != "n":
            is_ta = raw_input("Managing more users? (y/n)")
        else:
            break