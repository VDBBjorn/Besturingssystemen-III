#domein iii.hogent.be:
#vervang zoeknaam en .... door je eigen naam
dsquery user -name zoeknaam

dsquery * "CN=.... ,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be" -attr mail objectclass

#thuis (vervang ook loginname door je eigen loginname) :
dsquery user -s 193.190.126.71 -u loginname -p * -name zoeknaam

dsquery * "CN=zoeknaam,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be" -s 193.190.126.71
           -u loginname -p * -attr mail objectclass

#domein ugent.be - niet ingelogd
#vervang loginnaam door je eigen loginnaam:
dsquery user -s "ugentdc1.ugent.be" -u loginnaam@ugent.be -p * -name loginnaam  #je zoek dus je loginnaam

dsquery * "CN=...,ou=...,ou=UGentUsers,DC=Ugent,DC=be" -s "ugentdc1.ugent.be" -u loginnaam@ugent.be -p * -attr mail #container UGentUsers is mogelijks niet juist - niet gecontroleerd voor een student.


