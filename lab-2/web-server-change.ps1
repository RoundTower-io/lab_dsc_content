Configuration WebsiteServer {

  Import-DscResource -ModuleName PsDesiredStateConfiguration

  Node 'localhost' {

    WindowsFeature WebServer {
      Ensure = "Present"
      Name   = "Web-Server"
    }

    File RemoveCruft {
      Ensure = "Absent"
      Type = "File"
      DestinationPath = "C:\inetpub\wwwroot\iisstart.htm"
    }
  }
}
WebsiteServerFail