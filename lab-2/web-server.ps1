Configuration WebsiteServer {

  Import-DscResource -ModuleName PsDesiredStateConfiguration

  Node 'localhost' {

    WindowsFeature WebServer {
      Ensure = "Present"
      Name   = "Web-Server"
    }
  }
}
WebsiteServer