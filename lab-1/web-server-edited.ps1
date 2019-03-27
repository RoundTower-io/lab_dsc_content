Configuration WebsiteTest {

  Import-DscResource -ModuleName PsDesiredStateConfiguration

  Node 'localhost' {

      WindowsFeature WebServer {
          Ensure = "Present"
          Name   = "Web-Server"
      }

      File WebsiteContent {
          Ensure = 'Absent'
          DestinationPath = 'c:\inetpub\wwwroot\index.html'
      }
  }
}
WebsiteTest