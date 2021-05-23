import ldap
from getpass import getpass

server_ip = "localhost"
stu_gid = "200"
ta_gid = "201"

pwd = getpass("Root password:")
gid_table = {"y": ta_gid, "n": stu_gid}
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
    username = raw_input("New username:")
    while True:
        is_ta = raw_input("Is the new user ta? (y/n)")
        if is_ta != "y" and is_ta != "n":
            is_ta = raw_input("Is the new user ta? (y/n)")
        else:
            break
    s_re = con.search_s(acc_base, ldap.SCOPE_SUBTREE, acc_filter, ["uidNumber"])
    available = list(range(10000, 50000))
    for i in s_re:
        available.remove(int(i[1]["uidNumber"][0]))

    new_uid = str(choice(available))
    new_gid = gid_table[is_ta]
    new_user = [
        ("objectClass", ["top", "account", "posixAccount", "shadowAccount"]),
        ("cn", [username]),
        ("uid", [username]),
        ("uidNumber", [new_uid]),
        ("gidNumber", [new_gid]),
        ("homeDirectory", ["/home/"+username]),
        ("loginShell", ["/bin/bash"])
    ]
    new_base = "uid="+username+","+acc_base
    print(new_base)
    con.add_s(new_base, new_user)
    passwd_re = con.passwd_s(new_base, None, username)
    while True:
        keep = raw_input("Add more users? (y/n)")
        if keep != "y" and keep != "n":
            is_ta = raw_input("Add more users? (y/n)")
        else:
            break
    if keep == "n":
        break