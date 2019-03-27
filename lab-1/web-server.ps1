Configuration WebsiteTest {

  Import-DscResource -ModuleName PsDesiredStateConfiguration

  Node 'localhost' {

      WindowsFeature WebServer {
          Ensure = "Present"
          Name   = "Web-Server"
      }

      File WebsiteContent {
          Ensure = 'Present'
          SourcePath = 'c:\DSC-Lab-1\index.html'
          DestinationPath = 'c:\inetpub\wwwroot'
      }
  }
}
WebsiteTest