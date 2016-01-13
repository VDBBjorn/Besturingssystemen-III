# implementatie bind_object functie: zie sectie 5

use Win32::OLE::Variant;
$Win32::OLE::Warn = 0;

my $administrator = bind_object("CN=Administrator,CN=Users,DC=iii,DC=hogent,DC=be");
print "AccountDisabled                             : $administrator->{AccountDisabled}\n";
print "AccountExpirationDate (accountExpires)      : $administrator->{AccountExpirationDate}\n";
print "BadLoginCount (badPWDCount)                 : $administrator->{BadLoginCount}\n";
print "Department (department)                     : $administrator->{Department}\n";
print "Description (description)                   : $administrator->{Description}\n";
print "Division (division)                         : $administrator->{Division}\n";
print "EmailAddress (mail)                         : $administrator->{EmailAddress}\n";
print "EmployeeID (employeeID)                     : $administrator->{EmployeeID}\n";
print "FaxNumber (facsimileTelephoneNumber)        : $administrator->{FaxNumber}\n";
print "FirstName (givenName)                       : $administrator->{FirstName}\n";
print "FullName (displayName)                      : $administrator->{FullName}\n";
print "HomeDirectory (homeDirectory)               : $administrator->{HomeDirectory}\n";
print "HomePage (wWWHomePage)                      : $administrator->{HomePage}\n";
print "IsAccountLocked                             : $administrator->{IsAccountLocked}\n";
print "Languages (language)                        : $administrator->{Languages}\n";
print "LastFailedLogin (badPasswordTime)           : $administrator->{LastFailedLogin}\n";
print "LastLogin (lastLogon)                       : $administrator->{LastLogin}\n";
print "LastLogoff (lastLogoff)                     : $administrator->{LastLogoff}\n";
print "LastName (sn)                               : $administrator->{LastName}\n";
print "LoginScript (scriptpath)                    : $administrator->{LoginScript}\n";
print "Manager (manager)                           : $administrator->{Manager}\n";
print "MaxStorage (maxStorage)                     : $administrator->{MaxStorage}\n";
print "NamePrefix (personalTitle)                  : $administrator->{NamePrefix}\n";
print "NameSuffix (generationQualifier)            : $administrator->{NameSuffix}\n";
print "OfficeLocations (physicalDeliveryOfficeName): $administrator->{OfficeLocations}\n";
print "OtherName (middlename)                      : $administrator->{OtherName}\n";
print "PasswordLastChanged (pwdLastSet)            : $administrator->{PasswordLastChanged}\n";
print "PasswordRequired                            : $administrator->{PasswordRequired}\n";
print "Picture (thumbnailPhoto)                    : $administrator->{Picture}\n";
print "PostalCodes (postalCode)                    : $administrator->{PostalCodes}\n";
print "Profile (profilePath)                       : $administrator->{Profile}\n";
print "TelephoneHome (homePhone)                   : $administrator->{TelephoneHome}\n";
print "TelephoneMobile (mobile)                    : $administrator->{TelephoneMobile}\n";
print "TelephoneNumber (telephoneNumber)           : $administrator->{TelephoneNumber}\n";
print "TelephonePager (pager)                      : $administrator->{TelephonePager}\n";
print "Title (title)                               : $administrator->{Title}\n";


