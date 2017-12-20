###################### USTAWIENIA SKRYPTU								
[bool]$HideConsole = 1
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
###################### FORCE EXECUTIONPOLICY						
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Scope Process
###################### LOAD MODULE
try {
	if ($PSScriptRoot) {
		$ScriptPath = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
	}
	else {
	$ScriptPath = Split-Path -Parent ([Environment]::GetCommandLineArgs()[0])
	}
	Import-Module $ScriptPath\Module\Module.psm1 -ErrorAction Stop
}
catch {
	$ErrorMessage = $_.Exception | Format-List -Force | Out-String
	Write-Host "CMMS Module is missing from $ScriptPath\Module\. Make sure script is located in the same location as module folder and run again." -ForegroundColor Red
	Write-Host "ERROR MESSAGE: $ErrorMessage"
	Read-Host 'Press Enter to continue...' | Out-Null
	break
}
###################### UKRYCIE KONSOLI
Hide-Console
###################### ZALADOWANIE ZALEZNOSCI				
Add-Type -AssemblyName System.Windows.Forms, PresentationCore, PresentationFramework
###################### DEFINIOWANIE GUI									
Setup-GUI
###################### MULTIWYBÓR
if ($MultiChoose -eq $True) {
	$Form1Button8.Enabled = $True
	$Form1Label8.Text = "Directory:"
	$Form1ComboBox1.Enabled = $True
	$Form1Button8.Text = "Load data"
	foreach ($Directory in $MultiChooseDirectories) {
            $Form1ComboBox1.Items.Add($Directory)
			}
	$Form1ComboBox1.SelectedIndex = 0
	$FilePath = $Form1ComboBox1.Text 
}
else {
	$FilePath = $CMMSDirectory
}
###################### SPRAWDZANIE STRUKTURY KATALOGÓW & TWORZENIE ZMIENNYCH	
$NewStructure = $FilePath + "\RestService\"
$OldStructure = $FilePath + "\RRM3RestService\"
$CheckNewPath = Test-Path $NewStructure
$CheckOldPath = Test-Path $OldStructure
if ($CheckNewPath -eq $True) {
    $RestFilePath = $FilePath + "\RestService\"
    $ServiceFilePath = $FilePath + "\Service\"
    $WebClientFilePath = $FilePath + "\WebClient\"
    $ClientFilePath = $FilePath + "\Client\"
    $Attachments = $FilePath + "\Attachments"
    $Labels = $FilePath + "\Service\Labels"
    $Temp = $FilePath + "\Service\Temp"
    $Mobile = $FilePath + "\Service\Temp\RRM3Mobile\RRM3Mobile.exe"
    $Apk = $FilePath + "\RestService\Android\CMMSMobile.apk"
    $TV = $FilePath + "\RestService\Tv\Tv.zip"
    $RestConfig = $RestFilePath + "Web.config"
    $ServiceConfig = $ServiceFilePath + "Web.config"
    $WebClientConfig = $WebClientFilePath + "Web.config"
    $ClientConfig = $ClientFilePath + "RRM3.exe.config"
    $ExeFile = $ClientFilePath + "RRM3.exe"
}
else {
    if ($CheckOldPath -eq $True) {
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
        [System.Windows.MessageBox]::Show("Nie odnaleziono struktury katalogow CMMS. Upewnij sie, ze wybrana sciezka jest prawidlowa!.", "System failure!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
        return
    }
}
###################### ZALADOWANIE DANYCH Z AUTOMATU
###################### POBRANIE WERSJI Z RRM3.EXE					
[xml]$ClientConfigContents = Get-Content $ClientConfig
$ClientVersion = $ClientConfigContents.SelectSingleNode('/configuration/appSettings/add')
$ClientVersion = $ClientVersion.Value
###################### ZALADOWANIE DANYCH DO EDITBOXOW				
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

###################### ZALADOWANIE DANYCH BUTTONEM
$Form1Button8.Add_Click(
	{
		$FilePath = $Form1ComboBox1.Text 
		###################### SPRAWDZANIE STRUKTURY KATALOGÓW & TWORZENIE ZMIENNYCH	
		$NewStructure = $FilePath + "\RestService\"
		$OldStructure = $FilePath + "\RRM3RestService\"
		$CheckNewPath = Test-Path $NewStructure
		$CheckOldPath = Test-Path $OldStructure
		if ($CheckNewPath -eq $True) {
			$RestFilePath = $FilePath + "\RestService\"
			$ServiceFilePath = $FilePath + "\Service\"
			$WebClientFilePath = $FilePath + "\WebClient\"
			$ClientFilePath = $FilePath + "\Client\"
			$Attachments = $FilePath + "\Attachments"
			$Labels = $FilePath + "\Service\Labels"
			$Temp = $FilePath + "\Service\Temp"
			$Mobile = $FilePath + "\Service\Temp\RRM3Mobile\RRM3Mobile.exe"
			$Apk = $FilePath + "\RestService\Android\CMMSMobile.apk"
			$TV = $FilePath + "\RestService\Tv\Tv.zip"
			$RestConfig = $RestFilePath + "Web.config"
			$ServiceConfig = $ServiceFilePath + "Web.config"
			$WebClientConfig = $WebClientFilePath + "Web.config"
			$ClientConfig = $ClientFilePath + "RRM3.exe.config"
			$ExeFile = $ClientFilePath + "RRM3.exe"
		}
		else {
			if ($CheckOldPath -eq $True) {
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
				[System.Windows.MessageBox]::Show("Nie odnaleziono struktury katalogow CMMS. Upewnij sie, ze wybrana sciezka jest prawidlowa!.", "System failure!", [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)
				return
			}
		}
	
		###################### POBRANIE WERSJI Z RRM3.EXE					
		[xml]$ClientConfigContents = Get-Content $ClientConfig
		$ClientVersion = $ClientConfigContents.SelectSingleNode('/configuration/appSettings/add')
		$ClientVersion = $ClientVersion.Value
		###################### ZALADOWANIE DANYCH DO EDITBOXOW				
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
)
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

Init-GUI