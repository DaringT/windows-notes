# Script Process
### [auto_logon.bat](auto_logon.bat)
### [auto_logon.ps1](auto_logon.ps1)
<br>

# Mannal Process
1. Open Register Editor: regedit.exe

2. Go to the following path: `**HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon**`[![](https://windowsreport.com/wp-content/uploads/2021/09/regedit-navigation-1.png)]

3. Click on **Edit** on the top menu, select _New_, choose **DWORD (32-bit) Value** and name it _AutoAdminLogon_.[![](https://windowsreport.com/wp-content/uploads/2021/09/edit.png)]

4. Double-click the key to edit it and give it the value **1**.[![](https://windowsreport.com/wp-content/uploads/2021/09/logon-key-1.png)]

5. Now click again on **Edit**, select _New_, choose **String Value** and name it _DefaultUserName_.[![](https://windowsreport.com/wp-content/uploads/2021/09/Default-UserName-1.png)]

6. Double-click the value and change the **Value data** with your user name.[![](https://windowsreport.com/wp-content/uploads/2021/09/user-value.png)]

7. Next, click on **Edit**, select _New_, then **String Value** and name it _DefaultPassword_.[![](https://windowsreport.com/wp-content/uploads/2021/09/default-password.png)]
7. Fill in your password, then click **OK**.