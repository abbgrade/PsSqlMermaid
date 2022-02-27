task InstallBuildDependencies -Jobs {
    Install-Module platyPs, psdocker -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
    Install-Module PsDockerMermaid, PsDac -ErrorAction Stop
}
