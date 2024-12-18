#SingleInstance Force


^!q::
	IfWinExist, arch [Running] - Oracle VirtualBox
	{
		InputBox, userInput, Text to Type, Please enter the text you want to type:
		if ErrorLevel
			return
		WinActivate
		Sleep, 200
		ControlSend,, %userInput%{Enter}
	}
return

^+w::
	IfWinExist, arch [Running] - Oracle VirtualBox
	{
		WinActivate
		Sleep, 300
		ControlSend,, bash <(curl -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/Arch/1.sh), arch [Running] - Oracle VirtualBox
		ControlSend,, {Enter}
	}
return

^+x::
	IfWinExist, arch [Running] - Oracle VirtualBox
	{
		WinActivate
		Sleep, 300
		ControlSend,, bash <(curl -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/Arch/2.sh), arch [Running] - Oracle VirtualBox
		ControlSend,, {Enter}
	}
return

^!t::
	IfWinExist, arch (After installing Gnome-terminal) [Running] - Oracle VirtualBox
	{
		WinActivate
		Sleep, 300
		ControlSend,, bash <(curl -L https://raw.githubusercontent.com/007BS/arch/refs/heads/Arch/config.sh), arch (After installing Gnome-terminal) [Running] - Oracle VirtualBox
		ControlSend,, {Enter}
	}
return

^!p::
	IfWinExist, arch (After installing Gnome-terminal) [Running] - Oracle VirtualBox
	{
		WinActivate
		Sleep, 300
		ControlSend,, bash <(curl -L https://raw.githubusercontent.com/007BS/arch/refs/heads/Arch/run_main.sh), arch (After installing Gnome-terminal) [Running] - Oracle VirtualBox
		ControlSend,, {Enter}
	}
return