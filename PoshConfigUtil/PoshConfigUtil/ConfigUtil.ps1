###################### USTAWIENIA SKRYPTU								
[bool]$HideConsole = 0
[bool]$MultiChoose = 0
[string]$CMMSDirectory = 'C:\Queris\CMMS'
$MultiChooseDirectories =   "C:\Queris\CMMS",
							"C:\Queris\FINLAND\CMMS_TEST",
							"C:\Queris\FINLAND\CMMS_PRODUCTION",
							"C:\Queris\RUSSIA\CMMS_TEST",
							"C:\Queris\RUSSIA\CMMS_PRODUCTION",
							"C:\Queris\SPAIN\CMMS_TEST",
							"C:\Queris\SPAIN\CMMS_PRODUCTION",
							"C:\Queris\SERBIA\CMMS_TEST",
							"C:\Queris\SERBIA\CMMS_PRODUCTION"
###################### UKRYCIE KONSOLI
if ($HideConsole -eq $True) {
	Add-Type -Name Window -Namespace Console -MemberDefinition '[DllImport("Kernel32.dll")]public static extern IntPtr GetConsoleWindow();[DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
	$consolePtr = [Console.Window]::GetConsoleWindow()
	[Console.Window]::ShowWindow($consolePtr, 0)
}
else{
	Write-Host "############################ Safe Mode ON ############################"
}
###################### ZALADOWANIE ZALEZNOSCI				
Add-Type -AssemblyName System.Windows.Forms, PresentationCore, PresentationFramework
###################### MULTIWYBÓR
function Directory-Check {
	###################### SPRAWDZANIE STRUKTURY KATALOGÓW & TWORZENIE ZMIENNYCH	
	Write-Host "-- Calling function Directory-Check --"
	Write-Host "Selected directory: $FilePath"
	$NewStructure = $FilePath + "\Service\"
	$OldStructure = $FilePath + "\RRM3Service\"
	$CheckNewPath = Test-Path $NewStructure
	$CheckOldPath = Test-Path $OldStructure
	if ($CheckNewPath -eq $True) {
		Write-Host "Check New Path succeded. Loaded path: $NewStructure"
		$global:RestFilePath = $FilePath + "\RestService\"
		$global:ServiceFilePath = $FilePath + "\Service\"
		$global:WebClientFilePath = $FilePath + "\WebClient\"
		$global:ClientFilePath = $FilePath + "\Client\"
		$global:Attachments = $FilePath + "\Attachments"
		$global:Labels = $FilePath + "\Service\Labels"
		$global:Temp = $FilePath + "\Service\Temp"
		$global:Mobile = $FilePath + "\Service\Temp\RRM3Mobile\RRM3Mobile.exe"
		$global:Apk = $FilePath + "\RestService\Android\CMMSMobile.apk"
		$global:TV = $FilePath + "\RestService\Tv\Tv.zip"
		$global:RestConfig = $RestFilePath + "Web.config"
		$global:ServiceConfig = $ServiceFilePath + "Web.config"
		$global:WebClientConfig = $WebClientFilePath + "Web.config"
		$global:ClientConfig = $ClientFilePath + "RRM3.exe.config"
		$global:ExeFile = $ClientFilePath + "RRM3.exe"
	}
	else {
		if ($CheckOldPath -eq $True) {
			Write-Host "Check Old Path succeded. Loaded path: $OldStructure"
		    $RestFilePath = $FilePath + "\RRM3RestService\"
			$ServiceFilePath = $FilePath + "\RRM3Services\"
			$WebClientFilePath = $FilePath + "\RRM3WebClient\"
			$ClientFilePath = $FilePath + "\RRM3Client\"
			$Attachments = $FilePath + "\Attachments"
			$Labels = $FilePath + "\RRM3Services\Labels"
			$Temp = $FilePath + "\RRM3Services\Temp"
			$Mobile = $FilePath + "\RRM3Services\Temp\RRM3Mobile\RRM3Mobile.exe"
			$Apk = $FilePath + "\RRM3RestService\Android\CMMSMobile.apk"
			$TV = $FilePath + "\RRM3RestService\Tv\Tv.zip"
			$RestConfig = $RestFilePath + "Web.config"
			$ServiceConfig = $ServiceFilePath + "Web.config"
			$WebClientConfig = $WebClientFilePath + "Web.config"
			$ClientConfig = $ClientFilePath + "RRM3.exe.config"
			$ExeFile = $ClientFilePath + "RRM3.exe"
		}
		else {
			Write-Host "Exception: $FilePath not found"
			[System.Windows.MessageBox]::Show("Nie odnaleziono struktury katalogow CMMS. Upewnij sie, ze sciezka w pliku ConfigScriptGui.config jest prawidlowa!.", "System failure!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
			return
		}
	}
	Write-Host "Loaded paths:"
	Write-Host "RestService: $RestFilePath"
	Write-Host "WebClient: $WebClientFilePath"
	Write-Host "Client: $ClientFilePath"
	Write-Host "Attachments: $Attachments"
	Write-Host "Labels: $Labels"
	Write-Host "Temp: $Temp"
	Write-Host "Mobile: $Mobile"
	Write-Host "Apk: $Apk"
	Write-Host "TV: $TV"
	Write-Host "RestService Config: $RestConfig"
	Write-Host "WebClient Config: $WebClientConfig"
	Write-Host "Client Config: $ClientConfig"
	Write-Host "Exe file: $ExeFile"
}
function Get-ConnString {	
	Write-Host "-- Calling function Get-ConnString --"
	###################### POBRANIE WERSJI Z RRM3.EXE	
	Write-Host "Starting loading client version from: $ClientConfig"				
	[xml]$ClientConfigContents = Get-Content $ClientConfig
	$ClientVersion = $ClientConfigContents.SelectSingleNode('/configuration/appSettings/add')
	$ClientVersion = $ClientVersion.Value
	###################### ZALADOWANIE DANYCH DO EDITBOXOW	
	Write-Host "Starting loading connectionstring from: $ServiceConfig"			
	[xml]$ServiceConfigContents = Get-Content $ServiceConfig
	$ConnectionString = $ServiceConfigContents.configuration.connectionStrings.add.ConnectionString
	$Results = new-object System.Collections.Specialized.StringCollection
	$regex = [regex] '=(\w.*?);'
	$match = $regex.Match($ConnectionString)
	while ($match.Success) {
		$Results.Add($match.Value) | out-null
		$match = $match.NextMatch()
	}
	$DBAddress = $Results[2]
	$DBName = $Results[3]
	$DBLogin = $Results[5]
	$DBPass = $Results[6]
	$DBAddress = $DBAddress.Replace('=', '')
	$DBAddress = $DBAddress.Replace(';', '')
	$DBName = $DBName.Replace('=', '')
	$DBName = $DBName.Replace(';', '')
	$DBLogin = $DBLogin.Replace('=', '')
	$DBLogin = $DBLogin.Replace(';', '')
	$DBPass = $DBPass.Replace('=', '')
	$DBPass = $DBPass.Replace(';', '')
}


if ($MultiChoose -eq 1) {
	$Form1ComboBox1 = New-Object System.Windows.Forms.Combobox
	$Form1ComboBox1.Location = New-Object System.Drawing.Point (120, 30)
	$Form1ComboBox1.Size = New-Object System.Drawing.Size(300,30)
	$Form1ComboBox1.Enabled = $False
	
	$Form1Label8 = New-Object System.Windows.Forms.Label
	$Form1Label8.Location = New-Object System.Drawing.Point(30,32)
	$Form1Label8.Size = New-Object System.Drawing.Size(80,20)

	$Form1Button8 = New-Object System.Windows.Forms.Button
	$Form1Button8.Text = "Multichoose disabled"
	$Form1Button8.Location = New-Object System.Drawing.Point(435, 15)
	$Form1Button8.Size = New-Object System.Drawing.Size(100, 50)
	$Form1Button8.Enabled = $False
	
	$Form1Button8.Enabled = $True
	$Form1Label8.Text = "Directory:"
	$Form1ComboBox1.Enabled = $True
	$Form1Button8.Text = "Load data"
	foreach ($Directory in $MultiChooseDirectories) {
            $Form1ComboBox1.Items.Add($Directory)
			}
	$Form1ComboBox1.SelectedIndex = 0
	$FilePath = $Form1ComboBox1.Text 
	$Form1Button8.Add_Click(
	{
		$Form1Label9 = New-Object System.Windows.Forms.Label
		$Form1Label9.Text = "CONFIG UTILITY"
		$Form1Label9.Font = new Font("Calibri", 38)
		$Form1Label9.Location = New-Object System.Drawing.Point(20,20)
		$Form1Label9.Size = New-Object System.Drawing.Size(700,50)

		$FilePath = $Form1ComboBox1.Text 
		Directory-Check
		Get-ConnString
	}	
)
}
else {
	$FilePath = $CMMSDirectory
	Directory-Check
	Get-ConnString
}

###################### DEFINIOWANIE GUI									
$Form1 = New-Object system.Windows.Forms.Form
$Form1.Text = "Informacje o kliencie CMMS"
$Form1.AutoScroll = $True
$Form1.Width = 570
$Form1.Height = 350
$Form1.MinimizeBox = $True
$Form1.MaximizeBox = $False
$Form1.WindowState = "Normal"
$Form1.FormBorderStyle = "FixedSingle"
$Form1.SizeGripStyle = "Hide"
$Form1.ShowInTaskbar = $True
$Font = New-Object System.Drawing.Font("Calibri", 12)
$Form1.Font = $Font

$Form2 = New-Object System.Windows.Forms.Form
$Form2.Text = "List of config files to modify"
$Form2.Width = 450
$Form2.Height = 220
$Form2.MinimizeBox = $True
$Form2.MaximizeBox = $False
$Form2.WindowState = "Normal"
$Form2.FormBorderStyle = "FixedSingle"
$Form2.SizeGripStyle = "Hide"
$Form2.ShowInTaskbar = $False
$Form2.Font = $Font

$Form3 = New-Object System.Windows.Forms.Form
$Form3.Text = "Database operations"
$Form3.Width = 690
$Form3.Height = 360
$Form3.MinimizeBox = $True
$Form3.MaximizeBox = $False
$Form3.WindowState = "Normal"
$Form3.FormBorderStyle = "FixedSingle"
$Form3.SizeGripStyle = "Hide"
$Form3.ShowInTaskbar = $False
$Form3.Font = $Font

$Form4 = New-Object System.Windows.Forms.Form
$Form4.Text = "Build-an-Endpoint Workshop"
$Form4.Width = 1050
$Form4.Height = 250
$Form4.MinimizeBox = $True
$Form4.MaximizeBox = $False
$Form4.WindowState = "Normal"
$Form4.FormBorderStyle = "FixedSingle"
$Form4.SizeGripStyle = "Hide"
$Form4.ShowInTaskbar = $False
$Form4.Font = $Font

$Form5 = New-Object System.Windows.Forms.Form
$Form5.Text = "Choose an instance"
$Form5.Width = 520
$Form5.Height = 110
$Form5.MinimizeBox = $False
$Form5.MaximizeBox = $False
$Form5.WindowState = "Normal"
$Form5.FormBorderStyle = "FixedSingle"
$Form5.SizeGripStyle = "Hide"
$Form5.ShowInTaskbar = $False
$Form5.Font = $Font

$Form1TextBox1 = New-Object System.Windows.Forms.TextBox
$Form1TextBox1.ReadOnly = $true
$Form1TextBox1.BorderStyle = 2
$Form1TextBox1.TabStop = $false
$Form1TextBox1.TabIndex = 1
$Form1TextBox1.Text = $DBAddress
$Form1TextBox1.Location = New-Object System.Drawing.Point(100, 105)
$Form1TextBox1.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox2 = New-Object System.Windows.Forms.TextBox
$Form1TextBox2.ReadOnly = $true
$Form1TextBox2.BorderStyle = 2
$Form1TextBox2.TabStop = $false
$Form1TextBox2.TabIndex = 2
$Form1TextBox2.Text = $DBName
$Form1TextBox2.Location = New-Object System.Drawing.Point(100, 135)
$Form1TextBox2.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox3 = New-Object System.Windows.Forms.TextBox
$Form1TextBox3.ReadOnly = $true
$Form1TextBox3.BorderStyle = 2
$Form1TextBox3.TabStop = $false
$Form1TextBox3.TabIndex = 3
$Form1TextBox3.Text = $DBLogin
$Form1TextBox3.Location = New-Object System.Drawing.Point(100, 165)
$Form1TextBox3.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox4 = New-Object System.Windows.Forms.TextBox
$Form1TextBox4.ReadOnly = $true
$Form1TextBox4.BorderStyle = 2
$Form1TextBox4.TabStop = $false
$Form1TextBox4.TabIndex = 4
$Form1TextBox4.Text = $DBPass
$Form1TextBox4.Location = New-Object System.Drawing.Point(100, 195)
$Form1TextBox4.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox5 = New-Object System.Windows.Forms.TextBox
$Form1TextBox5.ReadOnly = $true
$Form1TextBox5.BorderStyle = 2
$Form1TextBox5.TabStop = $false
$Form1TextBox5.TabIndex = 5
$Form1TextBox5.Text = $ClientVersion
$Form1TextBox5.Location = New-Object System.Drawing.Point(100, 225)
$Form1TextBox5.Size = New-Object System.Drawing.Size(180, 12)

$Form3ListBox1 = New-Object System.Windows.Forms.Listbox
$Form3ListBox1.BorderStyle = 1
$Form3ListBox1.Location = New-Object System.Drawing.Point(700, 40)

$Form3ListBox2 = New-Object System.Windows.Forms.Listbox
$Form3ListBox2.BorderStyle = 1
$Form3ListBox2.Location = New-Object System.Drawing.Point(920, 40)

$Form3ListBox3 = New-Object System.Windows.Forms.ListBox
$Form3ListBox3.BorderStyle = 1
$Form3ListBox3.Location = New-Object System.Drawing.Point(1140, 40)

$Form4ListBox1 = New-Object System.Windows.Forms.ListBox
$Form4ListBox1.BorderStyle = 1
$Form4ListBox1.Location = New-Object System.Drawing.Point(50, 60)
$Form4ListBox1.Size = New-Object System.Drawing.Size(180, 100)

$Form4TextBox1 = New-Object System.Windows.Forms.TextBox
$Form4TextBox1.BorderStyle = 2
$Form4TextBox1.TabStop = $false
$Form4TextBox1.TabIndex = 1
$Form4TextBox1.Location = New-Object System.Drawing.Point(270, 60)
$Form4TextBox1.Size = New-Object System.Drawing.Size(60, 12)

$Form1Label1 = New-Object System.Windows.Forms.Label
$Form1Label1.Text = "App configs:"
$Form1Label1.Location = New-Object System.Drawing.Point(20, 78)
$Form1Label1.Size = New-Object System.Drawing.Size(300, 30)

$Form1Label2 = New-Object System.Windows.Forms.Label
$Form1Label2.Text = "DB Adr:"
$Form1Label2.Location = New-Object System.Drawing.Point(20, 108)
$Form1Label2.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label3 = New-Object System.Windows.Forms.Label
$Form1Label3.Text = "DB Name:"
$Form1Label3.Location = New-Object System.Drawing.Point(20, 139)
$Form1Label3.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label4 = New-Object System.Windows.Forms.Label
$Form1Label4.Text = "DB Login:"
$Form1Label4.Location = New-Object System.Drawing.Point(20, 169)
$Form1Label4.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label5 = New-Object System.Windows.Forms.Label
$Form1Label5.Text = "DB Pwd:"
$Form1Label5.Location = New-Object System.Drawing.Point(20, 199)
$Form1Label5.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label6 = New-Object System.Windows.Forms.Label
$Form1Label6.Text = "Version:"
$Form1Label6.Location = New-Object System.Drawing.Point(20, 228)
$Form1Label6.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label7 = New-Object System.Windows.Forms.Label
$Form1Label7.Text = "scripted by mmendrygal@queris.pl"
$Form1Label7.Location = New-Object System.Drawing.Point(20, 270)
$Form1Label7.Size = New-Object System.Drawing.Size(400, 25)

$Form2Label1 = New-Object System.Windows.Forms.Label
$Form2Label1.Text = "Service Path: $ServiceConfig"
$Form2Label1.Location = New-Object System.Drawing.Point (20, 18)
$Form2Label1.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label2 = New-Object System.Windows.Forms.Label
$Form2Label2.Text = "RestService Path: $RestConfig"
$Form2Label2.Location = New-Object System.Drawing.Point (20, 48)
$Form2Label2.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label3 = New-Object System.Windows.Forms.Label
$Form2Label3.Text = "WebClient Path: $WebClientConfig"
$Form2Label3.Location = New-Object System.Drawing.Point (20, 78)
$Form2Label3.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label4 = New-Object System.Windows.Forms.Label
$Form2Label4.Text = "Client Path: $ClientConfig"
$Form2Label4.Location = New-Object System.Drawing.Point (20, 109)
$Form2Label4.Size = New-Object System.Drawing.Size(500, 20)

$Form3Label1 = New-Object System.Windows.Forms.Label
$Form3Label1.Location = New-Object System.Drawing.Point (120, 10)
$Form3Label1.Size = New-Object System.Drawing.Size(500, 20)

$Form3Label2 = New-Object System.Windows.Forms.Label
$Form3Label2.Text = "These buttons perform operations in database to`nmodify paths in user settings from selected CMMS installation"
$Form3Label2.Location = New-Object System.Drawing.Point (230, 55)
$Form3Label2.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label3 = New-Object System.Windows.Forms.Label
$Form3Label3.Location = New-Object System.Drawing.Point (700, 10)
$Form3Label3.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label4 = New-Object System.Windows.Forms.Label
$Form3Label4.Location = New-Object System.Drawing.Point (920, 10)
$Form3Label4.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label5 = New-Object System.Windows.Forms.Label
$Form3Label5.Text = "Clear UstawieniaBin for further processing"
$Form3Label5.Location = New-Object System.Drawing.Point (230, 125)
$Form3Label5.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label6 = New-Object System.Windows.Forms.Label
$Form3Label6.Text = "Get the list of scripts applied to this database and`nsearch for missing ones"
$Form3Label6.Location = New-Object System.Drawing.Point (230, 175)
$Form3Label6.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label7 = New-Object System.Windows.Forms.Label
$Form3Label7.Location = New-Object System.Drawing.Point (1140, 10)
$Form3Label7.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label8 = New-Object System.Windows.Forms.Label
$Form3Label8.Location = New-Object System.Drawing.Point (700, 290)
$Form3Label8.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label9 = New-Object System.Windows.Forms.Label
$Form3Label9.Location = New-Object System.Drawing.Point (920, 290)
$Form3Label9.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label10 = New-Object System.Windows.Forms.Label
$Form3Label10.Location = New-Object System.Drawing.Point (1140, 290)
$Form3Label10.Size = New-Object System.Drawing.Size(150, 20)

$Form4Label1 = New-Object System.Windows.Forms.Label
$Form4Label1.Location = New-Object System.Drawing.Point (50, 25)
$Form4Label1.Size = New-Object System.Drawing.Size(80 , 35)
$Form4Label1.Text = "Choose IP"

$Form4Label2 = New-Object System.Windows.Forms.Label
$Form4Label2.Location = New-Object System.Drawing.Point (265, 25)
$Form4Label2.Size = New-Object System.Drawing.Size(80, 35)
$Form4Label2.Text = "Type port"

$Form4Label3 = New-Object System.Windows.Forms.Label
$Form4Label3.Location = New-Object System.Drawing.Point (375, 25)
$Form4Label3.Size = New-Object System.Drawing.Size(400, 35)
$Form4Label3.Text = "Your endpoint address will look like this:"

$Form4Label4 = New-Object System.Windows.Forms.Label
$Form4Label4.Location = New-Object System.Drawing.Point (375, 55)
$Form4Label4.Size = New-Object System.Drawing.Size(600 , 35)

$Form4Label5 = New-Object System.Windows.Forms.Label
$Form4Label5.Location = New-Object System.Drawing.Point (375, 95)
$Form4Label5.Size = New-Object System.Drawing.Size(600 , 35)
$Form4Label5.Text = "Current endpoint address in config:"

$Form4Label6 = New-Object System.Windows.Forms.Label
$Form4Label6.Location = New-Object System.Drawing.Point (375, 125)
$Form4Label6.Size = New-Object System.Drawing.Size(600 , 35)

$Form1Button1 = New-Object System.Windows.Forms.Button
$Form1Button1.Text = "Edit`nconn. data"
$Form1Button1.Location = New-Object System.Drawing.Point(320, 80)
$Form1Button1.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button2 = New-Object System.Windows.Forms.Button
$Form1Button2.Text = "Accept`nand save"
$Form1Button2.Location = New-Object System.Drawing.Point(320, 135)
$Form1Button2.Size = New-Object System.Drawing.Size(100, 50)
$Form1Button2.Enabled = $false

$Form1Button3 = New-Object System.Windows.Forms.Button
$Form1Button3.Text = "List loaded paths"
$Form1Button3.Location = New-Object System.Drawing.Point(320, 190)
$Form1Button3.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button4 = New-Object System.Windows.Forms.Button
$Form1Button4.Text = "Run app"
$Form1Button4.Location = New-Object System.Drawing.Point(320, 245)
$Form1Button4.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button5 = New-Object System.Windows.Forms.Button
$Form1Button5.Text = "DB Operations"
$Form1Button5.Location = New-Object System.Drawing.Point(435, 80)
$Form1Button5.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button6 = New-Object System.Windows.Forms.Button
$Form1Button6.Text = "IIS Operations"
$Form1Button6.Location = New-Object System.Drawing.Point(435, 135)
$Form1Button6.Size = New-Object System.Drawing.Size(100, 50)
$Form1Button6.Enabled = $False

$Form1Button7 = New-Object System.Windows.Forms.Button
$Form1Button7.Text = "Modify endpoints"
$Form1Button7.Location = New-Object System.Drawing.Point(435, 190)
$Form1Button7.Size = New-Object System.Drawing.Size(100, 50)

$Form2Button1 = New-Object System.Windows.Forms.Button
$Form2Button1.Text = "OK"
$Form2Button1.Location = New-Object System.Drawing.Point(170, 142)
$Form2Button1.Size = New-Object System.Drawing.Size(100, 25)

$Form3Button1 = New-Object System.Windows.Forms.Button
$Form3Button1.Text = "Load User Settings"
$Form3Button1.Location = New-Object System.Drawing.Point (125, 50)
$Form3Button1.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button2 = New-Object System.Windows.Forms.Button
$Form3Button2.Text = "Modify User Settings"
$Form3Button2.Location = New-Object System.Drawing.Point (20, 50)
$Form3Button2.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button3 = New-Object System.Windows.Forms.Button
$Form3Button3.Text = "Clear BinSettings"
$Form3Button3.Location = New-Object System.Drawing.Point (20, 110)
$Form3Button3.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button4 = New-Object System.Windows.Forms.Button
$Form3Button4.Text = "Load Scripts List"
$Form3Button4.Location = New-Object System.Drawing.Point (20, 170)
$Form3Button4.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button5 = New-Object System.Windows.Forms.Button
$Form3Button5.Text = "Compare"
$Form3Button5.Location = New-Object System.Drawing.Point (125, 170)
$Form3Button5.Size = New-Object System.Drawing.Size(100, 50)
$Form3Button5.Enabled = $False

$Form4Button1 = New-Object System.Windows.Forms.Button
$Form4Button1.Text = "Save and set endpoints"
$Form4Button1.Location = New-Object System.Drawing.Point (780, 160)
$Form4Button1.Size = New-Object System.Drawing.Size(220,30)

###################### EDYCJA CONNECTIONSTRING							
$Form1Button1.Add_Click(
    {
        $Form1TextBox1.ReadOnly = $False
        $Form1TextBox2.ReadOnly = $False
        $Form1TextBox3.ReadOnly = $False
        $Form1TextBox4.ReadOnly = $False
        $Form1TextBox5.ReadOnly = $False
        $Form1Button1.Enabled = $False
        $Form1Button2.Enabled = $True
        $Form1Button3.Enabled = $False
		$Form1Button8.Enabled = $False
    }
)
###################### ZAPIS DO PLIKÓW									
$Form1Button2.Add_Click(
    {
        $Form1TextBox1.ReadOnly = $True
        $Form1TextBox2.ReadOnly = $True
        $Form1TextBox3.ReadOnly = $True
        $Form1TextBox4.ReadOnly = $True
        $Form1TextBox5.ReadOnly = $True
        $Form1Button1.Enabled = $True
        $Form1Button2.Enabled = $False
        $Form1Button3.Enabled = $True
        $Form1Button8.Enabled = $True
        $connectionString = 'metadata=res://*/RrmDBModel.csdl|res://*/RrmDBModel.ssdl|res://*/RrmDBModel.msl;provider=System.Data.SqlClient;provider connection string="data source=' + $Form1TextBox1.Text + ';initial catalog=' + $Form1TextBox2.Text + ';persist security info=True;user id=' + $Form1TextBox3.Text + ';password=' + $Form1TextBox4.Text + ';MultipleActiveResultSets=True;App=EntityFramework"'
        
        [bool]$ErrorFlag = 0
        ###################### SPRAWDZENIE - WEBCLIENT ######################
        Try {
            $FileToEdit = $WebClientConfig
            [xml]$xml1 = Get-Content $FileToEdit
            $xml1.Load($FileToEdit)
            $node1 = $xml1.SelectSingleNode('/configuration/connectionStrings/add');
            $node1.SetAttribute('connectionString', $connectionString)
            $xml1.Save($FileToEdit)
            }
        Catch {
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -ilike "*null-valued*")
            {
                [string]$SaveWebClientMessage = "Saving WebClient config file - Path not found`n"
            }
            else
            {
                [string]$SaveRestServiceMessage = "Saving WebClient config file - Failed due to unknown reason`n"
            }
            $ErrorFlag = 1
        }
        ###################### SPRAWDZENIE - RESTSERVICE ######################
        Try {
            $FileToEdit2 = $RestConfig
            [xml]$xml2 = Get-Content $FileToEdit2
            $xml2.Load($FileToEdit2)
            $node2 = $xml2.SelectSingleNode('/configuration/connectionStrings/add');
            $node2.SetAttribute('connectionString', $connectionString)
            $xml2.Save($FileToEdit2)
            }
        Catch {
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -ilike "*null-valued*")
            {
                [string]$SaveWebClientMessage = "Saving RestService config file - Path not found`n"
            }
            else
            {
                [string]$SaveRestServiceMessage = "Saving RestService config file - Failed due to unknown reason`n"
            }
            $ErrorFlag = 1
        }
        ###################### SPRAWDZENIE - SERVICE ######################
        Try {
            $FileToEdit3 = $ServiceConfig
            [xml]$xml3 = Get-Content $FileToEdit3
            $xml3.Load($FileToEdit3)
            $node3 = $xml3.SelectSingleNode('/configuration/connectionStrings/add');
            $node3.SetAttribute('connectionString', $connectionString)
            $xml3.Save($FileToEdit3)
            }
        Catch {
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -ilike "*null-valued*")
            {
                [string]$SaveWebClientMessage = "Saving Service config file - Path not found`n"
            }
            else
            {
                [string]$SaveServiceMessage = "Saving Service config file - Failed due to unknown reason`n"
            }
            $ErrorFlag = 1
        }
        ###################### SPRAWDZENIE - EXE.CONFIG ######################
        Try {
            $FileToEdit4 = $ClientConfig
            [xml]$xml4 = Get-Content $FileToEdit4
            $xml4.Load($FileToEdit4)
            $node4 = $xml4.SelectSingleNode('/configuration/appSettings/add')
            $node4.SetAttribute('value', $Form1TextBox5.Text)
            $xml4.Save($FileToEdit4)
            }
        Catch {
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -ilike "*null-valued*")
            {
                [string]$SaveWebClientMessage = "Saving WebClient config file - Path not found`n"
            }
            else
            {
                [string]$SaveExeMessage = "Saving Exe config file - Failed due to unknown reason`n"
            }
            $ErrorFlag = 1
        }
            [string]$SaveErrorMessage = ($SaveWebClientMessage + $SaveRestServiceMessage + $SaveServiceMessage + $SaveExeMessage)
            if ($ErrorFlag -eq $True)
            {
                [System.Windows.MessageBox]::Show("Saved files with errors:`n $SaveErrorMessage", "Almost Great Success!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Information)     
            }
            else
            {
                [System.Windows.MessageBox]::Show("Successfuly saved all config files.", "Great Success!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Information)
           
            }
            
    }
)
###################### START RRM3										
$Form1Button4.Add_Click(
    {
        Start-Process -FilePath "$ExeFile"
    }
)
###################### KOPIOWANIE "TEGO"							
$Form1Label7.Add_Click(
    {
        $UselessCrap = "Admin" + $ClientVersion | clip.exe
    }
)
###################### FORMULARZ ENDPOINTY										
$Form1Button7.Add_Click(
	{
		$IPAddresses = Get-NetIPAddress -AddressFamily IPv4
		$Ip = @()
		Foreach ($item in $IPAddresses.IPv4Address)
		{
			$Ip = $IPAddresses.IPv4Address
		}
		Foreach ($Address in $Ip)
		{
			$Form4ListBox1.Items.Add($Address)
		}
		$Endpoint = $ClientConfigContents.SelectSingleNode('/configuration/system.serviceModel/client/endpoint')
		$Form4Label6.Text = $Endpoint.Address
		$Form4.ShowDialog()
	}
)
###################### EVENTHANDLERY DLA LABELA Z NOWYM ENPOINT ADRESEM
$Form4Listbox1.Add_Click(
	{
		$Form4Label4.Text = "net.tcp://" + $Form4Listbox1.SelectedItem + ":" + $Form4TextBox1.Text + "/RrmWcfServices.Services.AllServices.svc"
	}
)
$Form4ListBox1.Add_KeyUp(
	{
		$Form4Label4.Text = "net.tcp://" + $Form4Listbox1.SelectedItem + ":" + $Form4TextBox1.Text + "/RrmWcfServices.Services.AllServices.svc"
	}
)
$Form4TextBox1.Add_TextChanged(
	{
		$Form4Label4.Text = "net.tcp://" + $Form4Listbox1.Text + ":" + $Form4Textbox1.Text + "/RrmWcfServices.Services.AllServices.svc"
	}
)
###################### ZAPISANIE ENDPOINTÓW DO PLIKU
$Form4Button1.Add_Click(
	{
		Try {
			$AddressToSave = $Form4Label4.Text
			$FileToEdit5 = $ClientConfig
			[xml]$ClientXml = Get-Content $FileToEdit5
			$ClientXml.Load($FileToEdit5)
			$node5 = $ClientXml.SelectNodes('/configuration/system.serviceModel/client/endpoint')
			$node5.SetAttribute('address', $AddressToSave)
			$ClientXml.Save($FileToEdit5)
			$Endpoint = $ClientConfigContents.SelectSingleNode('/configuration/system.serviceModel/client/endpoint')
			$Form4Label6.Text = $AddressToSave
			$Counter = $($node5.Count)
			[System.Windows.MessageBox]::Show("Successfully modified $Counter endpoints in RRM3.exe.config", "Succsss!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Information)	
		}
		Catch
		{
			[System.Windows.MessageBox]::Show("Failed to save RRM3.exe.config.", "Error!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)	
		}
	}
)

###################### ZALADOWANIE USTAWIENIA APLIKACJI					
$Form3Button1.Add_Click(
    {
        
        if ($Form3.Width -eq 690) {}
        else {
            $Form3.Width = 690
        }
        if ($Form3ListBox1.Items) { 
            $Form3ListBox1.Items.Clear()
        }
        if ($Form3ListBox2.Items) {
            $Form3ListBox2.Items.Clear()
        }
        else {}
        $Form3ListBox1.Size = New-Object System.Drawing.Size (180, 230)
        $Form3ListBox2.Size = New-Object System.Drawing.Size (500, 230)
        $Form3Button5.Enabled = $False
        $Form3Label8.Text = ""
        $Form3Label9.Text = ""
        $Form3Label10.Text = ""
        $Form3Button1.Text = "Loading..."
        Try {
            $QueryResult = Invoke-Sqlcmd -ServerInstance $Form1Textbox1.Text -Database $Form1Textbox2.Text -Username $Form1Textbox3.Text -Password $Form1Textbox4.Text -Query "SELECT [Nazwa], [Wartosc] FROM dbo.UstawieniaAplikacji WHERE Id in (1, 6, 17, 23, 25, 46, 53)"
        }
        Catch {
            [System.Windows.MessageBox]::Show("Connection error. Check connection details.", "Error!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
        }
        $Nazwa = @()
        $Wartosc = @()
        foreach ($item in $QueryResult.Nazwa) {
            $Nazwa = $QueryResult.Nazwa
        }
        foreach ($item in $QueryResult.Wartosc) {
            $Wartosc = $QueryResult.Wartosc
        }
        foreach ($item in $Nazwa) {
            $Form3ListBox1.Items.Add($item)
        }
        foreach ($item in $Wartosc) {
            $Form3ListBox2.Items.Add($item)
        }
        $Form3Label3.Text = "Nazwa:"
        $Form3Label4.Text = "Wartosc:"
        $Form3Label7.Text = ""
        $Form3.Width = 1470
        $Form3Button1.Text = "Load User Settings"
        
    }
)
###################### MODYFIKACJA USTAWIENIA APLIKACJI 
$Form3Button2.Add_Click(
    {
        $modifyconfirmation = [System.Windows.Forms.MessageBox]::Show("Do you want to modify user settings?`nValues will be set based on location: $FilePath", 'Warning', 'YesNo', 'Warning')
        if ($modifyconfirmation -eq 'Yes') {
            $Form3Button2.Text = "Updating..."
            Try {
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$Attachments' WHERE Id = 1"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$Labels' WHERE Id = 6"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$ServiceFilePath' WHERE Id = 17"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$Temp' WHERE Id = 23"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$Mobile' WHERE Id = 25"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$Apk' WHERE Id = 46"
                Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "UPDATE [dbo].[UstawieniaAplikacji] SET [Wartosc] = '$TV' WHERE Id = 53"
            }
            Catch {
                [System.Windows.MessageBox]::Show("Connection error. Check connection details.", "Error!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
            }
            $Form3Button2.Text = "Modify User Settings"
        }
        else {}
    }
)
###################### CZYSZCZENIE USTAWIENIABIN 
$Form3Button3.Add_Click(
    {
        $clearbinconfirmation = [System.Windows.Forms.MessageBox]::Show("This option, when performed badly,  might completely break CMMS`nand prevent further usage until fixed by maintenance staff.`nAre you sure you want to clear bin settings?", 'Warning', 'YesNo', 'Warning')
        if ($clearbinconfirmation -eq 'Yes') {
            $Form3Button3.Text = "Clearing..."
            Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "DELETE FROM [dbo.UstawieniaBin] WHERE Id < 20"
            $Form3Button3.Text = "Clear BinSettings"
        }
        else {}
    }
)
###################### ŁADOWANIE SKRYPTÓW Z BAZY 
$Form3Button4.Add_Click(
    {
        if ($Form3.Width -eq 690) {}
        else {
            $Form3.Width = 690
        }
        if ($Form3ListBox1.Items) { 
            $Form3ListBox1.Items.Clear()
        }
        if ($Form3ListBox2.Items) {
            $Form3ListBox2.Items.Clear()
        }
        if ($Form3ListBox3.Items) {
            $Form3ListBox3.Items.Clear()
        }
        else {}
        $Form3ListBox1.Size = New-Object System.Drawing.Size (180, 230)
        $Form3ListBox2.Size = New-Object System.Drawing.Size (0, 0)
        $Form3Label3.Text = "Scripts installed:"
        $Form3Button4.Text = "Loading..."
        Try {
            $OutputSkrypty = Invoke-Sqlcmd -ConnectionTimeout "100" -ServerInstance $Form1TextBox1.Text -Database $Form1TextBox2.Text -Username $Form1TextBox3.Text -Password $Form1TextBox4.Text -Query "SELECT [Wersja] FROM dbo.Wersje_Skryptow"
        }
        Catch {
            [System.Windows.MessageBox]::Show("Connection error. Check connection details.", "Error!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
        }
        $Skrypty = @()
        $ArrSkrypty = @()
        foreach ($item in $OutputSkrypty.Wersja) {
            $Skrypty = $OutputSkrypty.Wersja
        }
        foreach ($item in $Skrypty) {
            $Form3ListBox1.Items.Add($item)
        }
        $ArrSkrypty = $Skrypty.Split(" ")
        $LB1Counter = $Form3ListBox1.Items.Count
        $Form3Label8.Text = "Count: $LB1Counter"
        $Form3Button4.Text = "Load Scripts List"
        $Form3Button5.Enabled = $True
        $Form3.Width = 930
    }
)
######################  INSTALACJA SKRYPTÓW - DO POPRAWY 
$Form3Button5.Add_Click(
    {
        if ($Form3ListBox2.Items) {
            $Form3ListBox2.Items.Clear()
        }
        if ($Form3ListBox3.Items) {
            $Form3ListBox3.Items.Clear()
        }
        $Form3ListBox2.Size = New-Object System.Drawing.Size(180, 230)
        $Form3ListBox3.Size = New-Object System.Drawing.Size(180, 230)
        $QueryResult = Invoke-Sqlcmd -ServerInstance "localhost" -Database "CMMS" -Username "rrm3user" -Password "RRM3Pass!1" -Query "SELECT [Wersja] FROM dbo.Wersje_Skryptow"
        $ScriptList = $AppConfig.SelectNodes('/configuration/scripts/scriptlist/script')
        $QueryValues = @()  
        $ArrScripts = @()
        $ArrQueryValues = @()
        foreach ($Value in $QueryResult.Wersja) {
            $QueryValues = $QueryResult.Wersja
        }
        $ArrQueryValues = $QueryValues.Split(" ")
        foreach ($item in $ScriptList.Value) {
            $Scripts = $ScriptList.Value
        }
        foreach ($item in $Scripts) {
            $Form3ListBox2.Items.Add($item)
        }
        $ArrScripts = $Scripts.Split(" ")
        for ($i = 0; $i -le $ArrScripts.Length; $i++) {
            if ($ArrQueryValues -contains $ArrScripts[$i]) {
            }
            else {
                $Form3ListBox3.Items.Add($ArrScripts[$i])
            }
        }
        $Form3Label4.Text = "Compl. list of scripts"
        $Form3.Width = 1350
        $Form3Label7.Text = "Missing scripts:"
        $LB2Counter = $Form3ListBox2.Items.Count
        $LB3Counter = $Form3ListBox3.Items.Count
        $Form3Label9.Text = "Count: $LB2Counter"
        $Form3Label10.Text = "Count: $LB3Counter"
    }
)
###################### WYSWIETLENIE SCIEZEK DO PLIKOW
$Form1Button3.Add_Click(
    {
        $Form2.ShowDialog()
    }
)
###################### ZAMYKANIE FORM2 
$Form2Button1.Add_Click(
    {
        $Form2.Close()
    }
)
###################### OTWARCIE MODULU SQL 
$Form1Button5.Add_Click(
    {
        $Form3.Width = 690
        $Form3Label1.Text = "Operating on database: " + $Form1TextBox2.Text + " on server:" + $Form1TextBox1.Text
        $Form3.ShowDialog()
    }
)

###################### INICJALIZACJA GUI 
######################  TextBoxy ###################### 
$Form1.Controls.Add($Form1TextBox1)
$Form1.Controls.Add($Form1TextBox2)
$Form1.Controls.Add($Form1TextBox3)
$Form1.Controls.Add($Form1TextBox4)
$Form1.Controls.Add($Form1TextBox5)
$Form4.Controls.Add($Form4TextBox1)
######################  ListBoxy ###################### 
$Form3.Controls.Add($Form3ListBox1)
$Form3.Controls.Add($Form3ListBox2)
$Form3.Controls.Add($Form3ListBox3)
$Form4.Controls.Add($Form4ListBox1)
######################  Buttony ###################### 
$Form1.Controls.Add($Form1Button1)
$Form1.Controls.Add($Form1Button2)
$Form1.Controls.Add($Form1Button3)
$Form1.Controls.Add($Form1Button4)
$Form1.Controls.Add($Form1Button5)
$Form1.Controls.Add($Form1Button6)
$Form1.Controls.Add($Form1Button7)
$Form1.Controls.Add($Form1Button8)
$Form2.Controls.Add($Form2Button1)
$Form3.Controls.Add($Form3Button1)
$Form3.Controls.Add($Form3Button2)
$Form3.Controls.Add($Form3Button3)
$Form3.Controls.Add($Form3Button4)
$Form4.Controls.Add($Form4Button1)
#$Form3.Controls.add($Form3Button5)   <---- Obsolete for now
######################  Labele ###################### 
$Form1.Controls.Add($Form1Label1)
$Form1.Controls.Add($Form1Label2)
$Form1.Controls.Add($Form1Label3)
$Form1.Controls.Add($Form1Label4)
$Form1.Controls.Add($Form1Label5)
$Form1.Controls.Add($Form1Label6)
$Form1.Controls.Add($Form1Label7)
$Form1.Controls.Add($Form1Label8)
$Form1.Contrils.Add($Form1Label9)
$Form2.Controls.Add($Form2Label1)
$Form2.Controls.Add($Form2Label2)
$Form2.Controls.Add($Form2Label3)
$Form2.Controls.Add($Form2Label4)
$Form3.Controls.Add($Form3Label1)
$Form3.Controls.Add($Form3Label2)
$Form3.Controls.Add($Form3Label3)
$Form3.Controls.Add($Form3Label4)
$Form3.Controls.Add($Form3Label5)
$Form3.Controls.Add($Form3Label6)
$Form3.Controls.Add($Form3Label7)
$Form3.Controls.Add($Form3Label8)
$Form3.Controls.Add($Form3Label9)
$Form3.Controls.Add($Form3Label10)
$Form4.Controls.Add($Form4Label1)
$Form4.Controls.Add($Form4Label2)
$Form4.Controls.Add($Form4Label3)
$Form4.Controls.Add($Form4Label4)
$Form4.Controls.Add($Form4Label5)
$Form4.Controls.Add($Form4Label6)
######################  Comboboxy ###################### 
$Form1.Controls.Add($Form1ComboBox1)
$Form1.ShowDialog()


if ($HideConsole -eq $False) {
	Write-Host "Press any key to exit"
	Read-Host | Out-Null
}