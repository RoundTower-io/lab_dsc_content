Configuration IISInstall {

  Node 'localhost' {

      WindowsFeature IIS {
          Ensure = "Present"
          Name   = "Web-Server"
      }
  }
}