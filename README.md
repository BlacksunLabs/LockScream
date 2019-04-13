<p align="center" ><img src="https://gist.github.com/n0ncetonic/bf506d5f6c979c9445095f30de6d618f/raw/915629750edb584884025ea846c9b4a32653c636/LockScream_512.png"></p>

# LockScream
macOS Client-Side Phishing lock screen payload.

Emulates the macOS lock screen by dynamically determining a user's wallpaper, username, and user icon. Makes use of Core Services and Collaboration Services to verify entered credentials before allowing the program to close.

## Features
- **Credentials are XOR encrypted and stored as a base64 encoded stringusing User Defaults**
  - Operators are free to push LockScream to remote implants and retrieve credentials at a later time
- **Fullscreen Kiosk mode**
  - Menu bar hidden
  - Dock hidden
  - Cmd+Tab disabled
  - Force Quit (Option + Cmd + Esc) disabled
  - All Apple System menus disabled
  - Expose/Mission Control disabled
  - Cannot switch Spaces
  - Power button disabled 
    - Note that hardbooting the machine by holding the power button until the machine shuts down still works
- **Credential Validation**
  - LockScream will not close until correct credentials are provided
- **Lock Screen impersonation**
  - Password input box "shakes" side to side if given incorrect credentials
  - Clicking the "Cancel" button invokes false screensaver
  - Pressing escape key invokes false screensaver
  - Keyboard input automatically focuses password box
  - Keyboard input automatically adds "arrow-in-circle" icon next to password box
  - User's wallpaper determined programatically and blurred when LockScream is invoked
- **False Screensaver**
  - Leverages the same functionality as System Preferences to call users's set Screensaver in "test" mode
  - Does not cause the real lock screen to trigger when exiting screensaver
  - Moving the cursor during false screensaver will cause it to close and bring back LockScream
  
## Where are the creds ?!
At the moment LockScream uses `User Defaults` to store credentials entered by the user.  
When compiling LockScream the bundle identifier can be changed from `com.blacksun.research.labs.LockScream` to any bundle identifier desired. The bundle identifier should be noted as it is important for retrieving user credentials later. 

For the sake of example, the default value of `com.blacksun.research.labs.LockScream` will be used and commands should be modified appropriately should you use a different bundle identifier.

```
$ defaults read com.blacksun.research.labs.LockScream
{
  crTkgKENXxuWDk3 = "MQs7Bx4lPRciFAMd2BAoCU0EGcl1ZZgY="
}
```

The command above returns a key-value pair in which a randomly generated string is used as the key and the value is a base64 encoded string.  
The secret to converting this key-value pair into a user's plain-text password is to first base64 decode the value to get a data blob. The key is also conveniently used as the key used to XOR the password and can be used to turn the data blob back into a plain-text password ready for use.

A simple PoC oneliner for decrypting the stored password is provided below with no guarantee of compatibility with any version of macOS outside of 10.14

```
$ enc="Base64 String From defaults read Command";key="Key from defaults read Command"; python -c "from itertools import izip,cycle;import base64;data = base64.decodestring(\"$enc\");xored = ''.join(chr(ord(x) ^ ord(y)) for (x,y) in izip(data,cycle(\"$key\")));print xored"
```

If you want to clean up after retrieving the plain-text credential issue a  `defaults delete` command as follows

```
defaults delete com.blacksun.research.labs.LockScream
```


n0ncetonic. Blacksun Research Labs 2019
